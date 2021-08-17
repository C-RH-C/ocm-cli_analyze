#!/bin/bash


#
# Developer .: Waldirio M Pinheiro <waldirio@redhat.com> | <waldirio@gmail.com>
# Date ......: 08/01/2021 
# Purpose ...: Use ocm-cli binary to check some OCP/OCM information
#


if [ "$1" == "" ]; then
  echo "Please, inform the cluster id"
  echo "exiting ..."
  exit
fi

CLUSTER_ID_LABEL=$1
CLUSTER_CHECK_DISPLAY_NAME=$(ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="display_name = '$CLUSTER_ID_LABEL'" | jq -r .items[].id | wc -l)
CLUSTER_CHECK_EXTERNAL_CLUSTER_ID=$(ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="external_cluster_id = '$CLUSTER_ID_LABEL'" | jq -r .items[].id | wc -l)

check_dn=0
check_ecid=0
check_var=0

if [ $CLUSTER_CHECK_DISPLAY_NAME -eq 1 ]; then
  check_dn=1
elif [ $CLUSTER_CHECK_EXTERNAL_CLUSTER_ID -eq 1 ]; then
  check_ecid=1
else
  check_var=1
fi

echo "Found via 'Display Name' ......: $check_dn"
echo "Found via External Cluster ID .: $check_ecid"
echo "Cluster Not Found .............: $check_var"
echo

if [ $check_var -eq 1 ]; then
  echo "Invalid cluster"
  echo "exiting ..."
  exit
fi


if [ $check_dn -eq 1 ]; then
  CLUSTER_ID=$(ocm get /api/clusters_mgmt/v1/clusters --parameter search="display_name = '$CLUSTER_ID_LABEL'" | jq -r .items[].id)
  CLUSTER_WEB_ID=$(ocm get /api/clusters_mgmt/v1/clusters --parameter search="display_name = '$CLUSTER_ID_LABEL'" | jq -r .items[].subscription.id)

  CLUSTER_MGMT=$(ocm get /api/clusters_mgmt/v1/clusters --parameter search="display_name = '$CLUSTER_ID_LABEL'" | jq -r .items[])
  CLUSTER_MGMT_CMD="ocm get /api/clusters_mgmt/v1/clusters --parameter search=\"display_name = '$CLUSTER_ID_LABEL'\" | jq -r .items[]"

  ACCOUNT_MGMT=$(ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="cluster_id = '$CLUSTER_ID'" | jq -r .items[])
  ACCOUNT_MGMT_CMD="ocm get /api/accounts_mgmt/v1/subscriptions --parameter search=\"cluster_id = '$CLUSTER_ID'\" | jq -r .items[]"
elif [ $check_ecid -eq 1 ]; then
  CLUSTER_ID=$(ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="external_cluster_id = '$CLUSTER_ID_LABEL'" | jq -r .items[].cluster_id)
  CLUSTER_WEB_ID=$(ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="external_cluster_id = '$CLUSTER_ID_LABEL'" | jq -r .items[].id)

  ACCOUNT_MGMT=$(ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="external_cluster_id = '$CLUSTER_ID_LABEL'" | jq -r .items[])
  ACCOUNT_MGMT_CMD="ocm get /api/accounts_mgmt/v1/subscriptions --parameter search=\"external_cluster_id = '$CLUSTER_ID_LABEL'\" | jq -r .items[]"
fi


echo "Cluster Name or Label ..: $CLUSTER_ID_LABEL"
echo "Cluster ID .............: $CLUSTER_ID"
echo "Display Name ...........: $(echo $ACCOUNT_MGMT | jq -r .display_name)"
echo "C.RH.C Link ............: https://console.redhat.com/openshift/details/s/$CLUSTER_WEB_ID"
echo

user_info()
{
  echo "# User Information"
  echo "---"
  echo "ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .first_name"
  echo "ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .last_name"
  echo "ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .username"
  echo "ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .email"
  echo "ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .organization.ebs_account_id"
  echo "---"
  echo "First Name ..........:" $(ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .first_name)
  echo "Last Name ...........:" $(ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .last_name)
  echo "Username ............:" $(ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .username)
  echo "Email ...............:" $(ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .email)
  echo "EBS Account Number ..:" $(ocm get $(echo $ACCOUNT_MGMT | jq -r .creator.href) | jq -r .organization.ebs_account_id)
  echo
}

cluster_node_info()
{
  echo "# Node Information"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq .metrics[].nodes"
  echo "---"
  echo $ACCOUNT_MGMT | jq .metrics[].nodes
  echo
}

cluster_creation_date()
{
  echo "# Cluster Creation Date"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .created_at"
  echo "$ACCOUNT_MGMT_CMD | jq -r .updated_at"
  echo "---"
  echo "Created At .............: $(echo $ACCOUNT_MGMT | jq -r .created_at)"
  echo "Updated At  ............: $(echo $ACCOUNT_MGMT | jq -r .updated_at)"
  echo
}

cluster_version()
{
  echo "# Cluster Version"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].openshift_version"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .metrics[].openshift_version
  echo
}

cluster_state()
{
  echo "# Cluster State"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].state"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].state_description"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .metrics[].state
  echo $ACCOUNT_MGMT | jq -r .metrics[].state_description
  echo
}

cluster_status()
{
  echo "# Cluster Status"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .status"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .status
  echo
}

cluster_subscription()
{
  echo "# Cluster Subscription"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .support_level"
  echo "$ACCOUNT_MGMT_CMD | jq -r .service_level"
  echo "$ACCOUNT_MGMT_CMD | jq -r .usage"
  echo "$ACCOUNT_MGMT_CMD | jq -r .system_units"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].subscription_obligation_exists"
  echo "---"
  echo "Service level agreement (SLA) ...:" $(echo $ACCOUNT_MGMT | jq -r .support_level)
  echo "Support type  ...................:" $(echo $ACCOUNT_MGMT | jq -r .service_level)
  echo "Cluster usage  ..................:" $(echo $ACCOUNT_MGMT | jq -r .usage)
  echo "Subscription units ..............:" $(echo $ACCOUNT_MGMT | jq -r .system_units)
  echo "Subscriptions Obligations .......:" $(echo $ACCOUNT_MGMT | jq -r .metrics[].subscription_obligation_exists)
  echo
}

cluster_etcd_encryption()
{
  echo "# Cluster ETCD Encryption"
  echo "---"
  echo "$CLUSTER_MGMT_CMD | jq -r .etcd_encryption"
  echo "---"
  echo $CLUSTER_MGMT | jq -r .etcd_encryption
  echo
}

cluster_billing_model()
{
  echo "# Cluster Billing Model"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .cluster_billing_model"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .cluster_billing_model
  echo
}

managed_cluster()
{
  echo "# Managed Cluster"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .managed"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .managed
  echo
}

provenance()
{
  echo "# Provenance"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .provenance"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .provenance
  echo
}

reconcile()
{
  echo "# Last Reconcile Date"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq .metrics[].nodes"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .last_reconcile_date
  echo
}

console_url()
{
  echo "# Console URL"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .console_url"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .console_url
  echo
}

health_state()
{
  echo "# Health State"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].health_state"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .metrics[].health_state
  echo
}


cluster_memory()
{
  echo "# Cluster Memory Summary"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].memory"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .metrics[].memory
  echo
  ocm cluster status $CLUSTER_ID
  echo
}


cluster_upgrade()
{
  echo "# Cluster Upgrade"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].upgrade"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .metrics[].upgrade
  echo
}

cluster_cloud_provider()
{
  echo "# Cloud Provider"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].cloud_provider"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].region"
  echo "---"
  echo $ACCOUNT_MGMT | jq -r .metrics[].cloud_provider
  echo $ACCOUNT_MGMT | jq -r .metrics[].region
  echo
}

cluster_alerts()
{
  echo "# Cluster Alerts"
  echo "---"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].critical_alerts_firing"
  echo "$ACCOUNT_MGMT_CMD | jq -r .metrics[].operators_condition_failing"
  echo "---"
  echo "Critical Alerts Firing .......:" $(echo $ACCOUNT_MGMT | jq -r .metrics[].critical_alerts_firing)
  echo "Operators Condition Failing ..:" $(echo $ACCOUNT_MGMT | jq -r .metrics[].operators_condition_failing)
  echo
}



## Main
user_info
cluster_node_info
cluster_subscription
managed_cluster
cluster_status
provenance
reconcile
console_url
health_state

# TOCHECK
cluster_memory

cluster_upgrade
cluster_state
cluster_version
cluster_cloud_provider
cluster_alerts
cluster_billing_model

# TOCHECK
cluster_etcd_encryption

cluster_creation_date
