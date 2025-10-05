

import json
import mysql.connector

import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth

from datetime import date, datetime

cred = credentials.Certificate("wera-forum-app-firebase-adminsdk-credentials.json")
default_app = firebase_admin.initialize_app(cred)

def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""

    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError ("Type %s not serializable" % type(obj))

global mysql

def create_user_if_not_exists(decodedToken, uid):
    # print("create user if not exists")
    conn = c()
    cursor = conn.cursor()

    sql = "select idUser from user WHERE uid = %s"
    cursor.execute(sql, (uid,))
    cursor.fetchall()
    #print(cursor.rowcount)
    if cursor.rowcount == 0:
        sql = "insert into user (decodedToken, uid) VALUES (%s, %s)"
        cursor.execute(sql, (decodedToken, uid,))
        if cursor.rowcount > 0:
            conn.commit()

def isAuthorized(id_token):
    uid=""
    # [START verify_token_id_check_revoked]
    a = None
    b = None
    try:
        if id_token != None:
            # Verify the ID token while checking if the token is revoked by
            # passing check_revoked=True.
            decoded_token = auth.verify_id_token(id_token, check_revoked=True)
            # Token is valid and not revoked.
            uid = decoded_token['uid']
            aud = decoded_token['aud']

            # print(uid)
            # print(aud)
            #print(decoded_token)
            if aud == "wera-forum-app":
                if uid != "":
                    create_user_if_not_exists(str(decoded_token), uid)
                    a = uid
                    b = str(decoded_token)
                    # with user
                else: # auth fail
                    a = None
                    b = None # anonymously
    except auth.RevokedIdTokenError:
        # Token revoked, inform the user to reauthenticate or signOut().
        pass
    except auth.InvalidIdTokenError:
        # Token is invalid
        pass
    return a, b
def c():
	return mysql.connector.connect(user='root', password='', host='127.0.0.1', database='app')
