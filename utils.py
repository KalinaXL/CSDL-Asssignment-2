import re

def is_phone_number(phone):
    if len(phone) not in (10, 11):
        return False
    return bool(re.compile("0[1-9]\d*").match(phone))
def is_email(email):
    return bool(re.match("\w+..@..\w*\.[a-zA-Z]*", email))
def is_name(name):
    return bool(re.match("[\D|.|!]", name))
def is_valid_date(date):
    l = date.split('/')
    if len(l) != 3:
        return False
    if int(l[0]) < 1 or int(l[0]) > 31:
        return False
    if int(l[1]) < 1 or int(l[1]) > 12:
        return False
    if int(l[-1]) < 1930 or int(l[-1]) > 2010:
        return False
    return True

def convert_to_date_iso8601(date):
    return '-'.join(date.split('/')[::-1])