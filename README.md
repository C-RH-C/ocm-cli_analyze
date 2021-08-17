# OCM-CLI Analyze

Please, keep in mind you need your ocm-cli working as expected. After that, feel free to download this script and execute.

```
$ wget https://raw.githubusercontent.com/C-RH-C/ocm-cli_analyze/master/ocm-cli_analyze.sh
$ chmod +x ocm-cli_analyze.sh
$ ./ocm-cli_analyze.sh 
Please, inform the cluster id
exiting ...
```
As you can see above, it's necessary to pass the `cluster id`.

```
$ ./ocm-cli_analyze.sh 4e3d89be-567a-4dff-984e-5db63bbb629d
Found via 'Display Name' ......: 1
Found via External Cluster ID .: 0
Cluster Not Found .............: 0

Cluster Name or Label ..: 4e3d89be-567a-4dff-984e-5db63bbb629d
Cluster ID .............: 1lfa4gc938civ1kmu7ur8r6dv6nvchue
Display Name ...........: 4e3d89be-567a-4dff-984e-5db63bbb629d
C.RH.C Link ............: https://console.redhat.com/openshift/details/s/1uGxSqOfREACi7mTujGOR5Uvb9A

# User Information
---
ocm get /api/accounts_mgmt/v1/accounts/1OVtgoQkp1YEFpIXEaBs93YIcVl | jq -r .first_name
ocm get /api/accounts_mgmt/v1/accounts/1OVtgoQkp1YEFpIXEaBs93YIcVl | jq -r .last_name
ocm get /api/accounts_mgmt/v1/accounts/1OVtgoQkp1YEFpIXEaBs93YIcVl | jq -r .username
ocm get /api/accounts_mgmt/v1/accounts/1OVtgoQkp1YEFpIXEaBs93YIcVl | jq -r .email
ocm get /api/accounts_mgmt/v1/accounts/1OVtgoQkp1YEFpIXEaBs93YIcVl | jq -r .organization.ebs_account_id
---
First Name ..........: CEE Ops
Last Name ...........: Automation Account
Username ............: cee-ops-automation
Email ...............: email@redhat.com
EBS Account Number ..: 999999

# Node Information
---
ocm get /api/accounts_mgmt/v1/subscriptions --parameter search="cluster_id = '1lfa4gc938civ1kmu7ur8r6dv6nvchue'" | jq -r .items[] | jq .metrics[].nodes
---
{
  "total": 6,
  "master": 4,
  "compute": 2
}
...
```

Just download the code and execute it in your local system.

I really hope this helps you.

If you need anything else of if you are facing issues trying to use it, please let me know.

waldirio@redhat.com / waldirio@gmail.com
