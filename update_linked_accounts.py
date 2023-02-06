import re
import csv
import json
import os
import requests
import sys
import codecs
from requests.exceptions import HTTPError

from settings import *
UPDATE_IZ = sys.argv[1]
REPORT_FILE = sys.argv[2]
UPDATE_IZ_KEY = IZ_READ_WRITE_KEYS[UPDATE_IZ]

# We want to make certain to use HTTP keep-alive!!!
requests_session = requests.Session()

def flush_print(*args, **kwargs):
  print(*args, file=sys.stdout, flush=True, **kwargs)

def alma_get(resource, apikey, params=None, fmt='json'):
    '''
    makes a generic alma api call, pass in a resource
    '''
    params = params or {}
    params['apikey'] = apikey
    params['format'] = fmt
    try:
      r = requests_session.get(resource, params=params) 
      r.raise_for_status()
    except HTTPError as http_err:
        print('HTTP error occurred: ' + str(http_err))
        print('Error response text: ' + r.text)
        raise http_err
    except Exception as err:
        print('Other error occurred: ' + str(err))
        print('Error response text ' + r.text)
        raise err
    return r

def alma_put(resource, apikey, payload=None, params=None, fmt='json'):

    '''
    makes a generic post request to alma api.
    '''
    payload = payload or {}
    params = params or {}
    params['format'] = fmt
    headers =  {
        'Content-type': 'application/{fmt}'.format(fmt=fmt),
        'Authorization' : 'apikey ' + apikey,
    }
    try:
      r = requests_session.put(
                     resource,
                     headers=headers,
                     params=params,
                     data=payload)
      r.raise_for_status()
    except HTTPError as http_err:
        print('HTTP error occurred: ' + str(http_err))
        print('Error response text ' + r.text)
        raise http_err
    except Exception as err:
        print('Other error occurred: ' + str(err))
        print('Error response text ' + r.text)
        raise err
    return r


def remove_bom_inplace(path):
    """Removes BOM mark, if it exists, from a file and rewrites it in-place"""
    buffer_size = 4096
    bom_length = len(codecs.BOM_UTF8)
 
    with open(path, "r+b") as fp:
        chunk = fp.read(buffer_size)
        if chunk.startswith(codecs.BOM_UTF8):
            i = 0
            chunk = chunk[bom_length:]
            while chunk:
                fp.seek(i)
                fp.write(chunk)
                i += len(chunk)
                fp.seek(bom_length, os.SEEK_CUR)
                chunk = fp.read(buffer_size)
            fp.seek(-bom_length, os.SEEK_CUR)
            fp.truncate()

def read_report_generator(report):
    remove_bom_inplace(report)

    with open(report, encoding='utf-8-sig') as fh:
        # is it tab-delimeted?
        line = fh.readline(1024)
        delim = ',' # default: csv
        if re.search('\t', line):
          delim = '\t'
        fh.seek(0)

        reader = csv.DictReader(fh, delimiter=delim)
        for row in reader:
            yield row

def get_home_id_by_email(email, home_iz):
    r = alma_get(ALMA_SERVER + USERS_ROUTE,
                LINKED_IZ_KEYS[home_iz],
                params = {'q' : 'email~' + email})
    if r.json()['total_record_count'] == 1:
        return r.json()['user'][0]['primary_id']
    else:
        return False

def get_details_by_pid(home_pid, apikey):
    r = alma_get(ALMA_SERVER + USER_ROUTE.format(user_id=home_pid),
                apikey)
    try:
        return r.json()
    except:
        return False

def main():
    count_all_records = 0
    success = 0
    required = 0
    not_required = 0
    no_pid_error = 0
    update_failed_error = 0
    general_error = 0
    for row in read_report_generator(REPORT_FILE):
        linked_pid = row['User Primary Identifier']
        linked_email = row['Preferred Email']
        home_iz = row['User - Linked From Institution Code']
        if not linked_pid or not linked_email or not home_iz:
            continue
        # request by email here
        try:
            home_pid = get_home_id_by_email(linked_email, home_iz)
        except:
            pass
        if home_pid:
            # if any of these fail, just move on and report that no update was done
            try:
                expiry_date = get_details_by_pid(home_pid, LINKED_IZ_KEYS[home_iz])['expiry_date']
                linked_account_details = get_details_by_pid(linked_pid, UPDATE_IZ_KEY)
                if linked_account_details['expiry_date'] == expiry_date:
                    success += 1
                    not_required += 1
                    flush_print('No update required for {email}.'
                          ' Dates match at {date}'.format(email=linked_email, date=expiry_date))
                else:
                    required += 1
                    flush_print('Update required for {email}. '
                          'linked date is {ld}, '
                          'home date is {hd}'.format(email=linked_email,
                                                     ld=linked_account_details['expiry_date'],
                                                     hd=expiry_date))
                    linked_account_details['expiry_date'] = expiry_date
                    # post update
                    updated_account = alma_put(ALMA_SERVER + USER_ROUTE.format(user_id=linked_pid),
                                                UPDATE_IZ_KEY,
                                                payload=json.dumps(linked_account_details))
                    if updated_account.status_code == 200:
                        success += 1
                        flush_print("update successful")
                    else:
                        update_failed_error += 1
                        flush_print("update failed for {}".format(linked_pid))
            except Exception as e:
                general_error += 1
                flush_print("Exception: {} - {}".format(e.args[0], row))

        else:
            flush_print("no pid for {} - {}".format(linked_pid, row))
            no_pid_error += 1
        count_all_records += 1
    flush_print("TOTAL RECORDS: {}".format(count_all_records))
    flush_print("SUCCESS RATE: {:.0f}%".format(float(success)/float(count_all_records)*100.0))
    flush_print("success: {}".format(success))
    flush_print("updates required: {}".format(required))
    flush_print("updates not required: {}".format(not_required))
    flush_print("no pid errors: {}".format(no_pid_error))
    flush_print("update failed errors: {}".format(update_failed_error))
    flush_print("general errors: {}".format(general_error))
    

if __name__ == '__main__':
    main()
