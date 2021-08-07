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
$ ./ocm-cli_analyze.sh 4e3d89be-567a-4dff-984e-5db63bbbXXXX
Cluster Name or Label ..: 4e3d89be-567a-4dff-984e-5db63bbbXXXX
Cluster ID .............: 1lfa4gc938civ1XXXXXXXXXXXXXXXXXXXXXX
C.RH.C Link ............: https://console.redhat.com/openshift/details/s/1uGxSqOfREACi7mTujGOR5Uvb9A

# Node Information
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
