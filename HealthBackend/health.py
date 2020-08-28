import firebase_admin
import firebase_admin.firestore
import myfitnesspal
import datetime
import time
import os
import sys

from firebase_admin import auth
from firebase_admin import credentials
from firebase_admin import firestore

"""
Backend code for OneHealth daily calorie computation.
"""
cred = credentials.Certificate('./ServiceAccountKey.json')
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()
users_ref = db.collection(u'users')
docs = users_ref.stream()

def getClient(email, password):
    client = myfitnesspal.Client(email, password)
    return client

def getYear():
    year = datetime.datetime.now().year
    return year

def getMonth():
    month = str(datetime.datetime.now().month)
    if int(month) < 10:
        month = "0" + month
    return month

def getDay():
    day = str(datetime.datetime.now().day - 1)
    print(day)
    if int(day) < 10:
        day = "0" + day
    return day
    
def getCalories(day, month, year, client):
    calories = client.get_date(year, month, day)
    print(calories)
    caloriesIndex = str(calories).find('calories') #number of cals always starts at cals + 11 index
    commaIndex = str(calories).find(',')
    return str(calories)[caloriesIndex + 11 : commaIndex]

def writeToDB(email, password):
    day = str(getDay())
    month = str(getMonth())
    year = str(getYear())
    client = getClient(email, password)
    doc_ref = db.collection(u'myfitnesspal').document(email)
    doc_ref.set({
        u'' + year + '-' + month + '-' + day: getCalories(day, month, year, client)
    }, merge = True)
    print('Calories and date successfully written to database')

def doWork(): 
    for doc in docs:
        email = doc.to_dict()['email']
        password = doc.to_dict()['password']
        writeToDB(email, password)
    

if __name__ == '__main__':
    while True:
        doWork()
        time.sleep(86400)
        os.execl(sys.executable, sys.executable, *sys.argv)


    
