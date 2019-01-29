# Linked account updater
This is a utility to update linked account expiration dates accross Alma institution zones.

## Settings
Settings are set in the `settings.py` file. You need to have Users read/write keys for the IZ you want to update patrons in, and at least read-only keys for the IZs you want updates from. You can also have the script get settings from the os environment instead by setting SETTINGS_FROM_ENV to True.


## installation
Before installing, make sure you have python 3 installed. This was developed in python 3.6. 
```
#set up a virtual environment
python3 -m venv venv
source venv/bin/activate

# install the module and requirements
pip install -r requirements.txt
```
## Running this script
This script takes two arguments. The first is the IZ code of the IZ you want to make updates in. It must be equal to one of the keys in IZ_READ_WRITE_KEYS. The second argument is the report of linked users you want to run the script on. It can be retrieved from the update IZ's analytics under: /Shared Folders/Community/Reports/Consortia/WRLC/Reports. Note that you need to leave the header in the report (i.e. the first row should be the field names column) Example:
```
python linked_account_update/update_linked_accounts.py scf linked_users_in_IZ_activeloan_scf.csv
```
