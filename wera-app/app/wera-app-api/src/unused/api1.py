import json
from flask import Flask, Response, request, jsonify
from flask_restful import Resource, Api, reqparse
# from flask_mysqldb import MySQL
import mysql.connector

import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth

from datetime import date, datetime

        
cred = credentials.Certificate("wera-forum-app-firebase-adminsdk-credentials.json")
default_app = firebase_admin.initialize_app(cred)
#firebase_admin.delete_app(default_app)

def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""

    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError ("Type %s not serializable" % type(obj))

app = Flask(__name__)

def init():
	api = Api(app)
	global mysql
	# mysql = MySQL()
	# mysql.init_app(app)
	api.add_resource(Song, '/Song', '/Song/<int:song_id>')
	api.add_resource(Songs,'/Songs')

def c():
	return mysql.connector.connect(user='root', password='', host='127.0.0.1', database='app')

def check_permission(uid, requestPath, requestMethod, requestEndpoint):
    conn = c()
    cursor = conn.cursor()
    
    sql = "select idPermission from permission WHERE requestPath = %s AND requestMethod = %s AND requestEndpoint = %s"
    cursor.execute(sql, (requestPath, requestMethod, requestEndpoint))
    id = cursor.fetchone()[0]
    print(id)

    # check userPermissions
    # sql = "select fiUser from userPermission WHERE fiUser = %s AND requestMethod = %s AND requestEndpoint = %s"
    # cursor.execute(sql, (uid, requestMethod, requestPath))
    
    # check bundlePermissions
    # sql = "select fiUser from bundlePermission WHERE fiUser = %s AND requestMethod = %s AND requestEndpoint = %s"
    # cursor.execute(sql, (uid, requestMethod, requestPath))

    # check defaultPermissions
    sql = "select * from defaultPermission WHERE fiPermission = %s"
    cursor.execute(sql, (id,))
    cursor.fetchall()
    print(cursor.rowcount)

    if cursor.rowcount > 0:
        print("Permission allowed")
        pass
    else:
        print("Permission denied")
        return

def create_user_if_not_exists(decodedToken, uid):
    # print("create user if not exists")
    conn = c()
    cursor = conn.cursor()

    sql = "select idUser from user WHERE uid = %s"
    cursor.execute(sql, (uid,))
    cursor.fetchall()
    print(cursor.rowcount)
    if cursor.rowcount == -1:
        sql = "insert into user (decodedToken, uid) VALUES (%s, %s)"
        cursor.execute(sql, (decodedToken, uid,))
        if cursor.rowcount > 0:
            conn.commit()

def log(uid, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody, response):
    # print("log")
    conn = c()
    cursor = conn.cursor()

    if uid != None:
        sql = "select idUser from user where uid = (%s)"
        cursor.execute(sql, (uid,))
        id = cursor.fetchone()[0]
    else:
        id = None
    #print(id)
    sql = "insert into apilog (fiUser, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody, response) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    #print(uid)
    #print(decodedToken)
    
    cursor.execute(sql, (id, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody, response))
    if cursor.rowcount > 0:
        conn.commit()

def verify_token_uid_check_revoke(id_token, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody, response):
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

            #print(uid)
            #print(aud)
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
            else:
                a = None
                b = None # anonymously
        check_permission(a, requestPath, requestMethod, requestEndpoint)
        log(a, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody, response)
    except auth.RevokedIdTokenError:
        # Token revoked, inform the user to reauthenticate or signOut().
        pass # return??
    except auth.InvalidIdTokenError:
        # Token is invalid
        pass # return ??
    # [END verify_token_id_check_revoked]

def check_user_token():
    try:
        j = None
        try:
            j = request.json['idtoken']
        except Exception as a:
            j = None
        requestIp = request.remote_addr
        requestPath = request.path
        requestMethod = request.method
        requestEndpoint = request.endpoint
        requestHeader = str(request.headers)
        requestBody = str(request.data)
        response = ""
        return verify_token_uid_check_revoke(j, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, None, response)
    except Exception as e:
        print(e)

@app.before_request
def before_calback():
    return check_user_token()

class Song(Resource):
    def post(self):
        try:
            # Parse the arguments
            parser = reqparse.RequestParser()
            parser.add_argument('title', type=str, help='title')
            parser.add_argument('text', type=str, help='text')
            parser.add_argument('chordsJson', type=str, help='Chords in JSON Format')
            args = parser.parse_args()

            _title = args['title']
            _text = args['text']
            _chordsJson = args['chordsJson']

            conn = c()
            cursor = conn.cursor()
            sql = "insert into song (title, text, chordsJson)values(%s, %s, %s)"
            cursor.execute(sql, (_title, _text, _chordsJson,))
            if cursor.rowcount > 0:
                conn.commit()
                return {'StatusCode':'200','Message': 'Song post success'}
            else:
                return {'StatusCode':'1000','Message': 'error'}
        except Exception as e:
            return {'error': str(e)}
    def get(self, song_id):
        conn = c()
        cursor = conn.cursor()
        sql = "select * from song WHERE id = %s"
        cursor.execute(sql, (song_id,))
        data = cursor.fetchone()
        row_headers=[x[0] for x in cursor.description] #this will extract row headers
        json_data=dict(zip(row_headers,data))
        return Response(json.dumps(json_data, default=json_serial), mimetype='application/json')
    def patch(self, song_id):
        try:
            # Parse the arguments
            parser = reqparse.RequestParser()
            parser.add_argument('title', type=str, help='title')
            parser.add_argument('text', type=str, help='text')
            parser.add_argument('chordsJson', type=str, help='Chords in JSON Format')
            args = parser.parse_args()

            _title = args['title']
            _text = args['text']
            _chordsJson = args['chordsJson']
        
            conn = c()
            cursor = conn.cursor()
            sql = "update song set title=%s, text=%s, chordsJson=%s where id=%s"
            cursor.execute (sql, (_title, _text, _chordsJson, song_id))
            if cursor.rowcount > 0:
                conn.commit()
                return {'StatusCode':'200','Message': 'Song patch success'}
            else:
                return {'StatusCode':'1000','Message': 'Song patch fail'}
        except Exception as e:
            return {'error': str(e)}

def dictfetchall(cursor):
    """Returns all rows from a cursor as a list of dicts"""
    desc = cursor.description
    return [ dict(zip([col[0] for col in desc], row)) for row in cursor.fetchall() ]
# usage
# results = dictfetchall(cursor)
# json_results = json.dumps(results)

class Songs(Resource):
    def get(self):
        
        conn = c()
        cursor = conn.cursor()
        sql = "select * from song"
        cursor.execute(sql)
        # results = dictfetchall(cursor)
        # data = cursor.fetchall()
        # row_headers=[x[0] for x in cursor.description] #this will extract row headers 
        # buffer=""
        # json_data=[]
        # for result in data:
        #     json_data=dict(zip(row_headers,result))
        return Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json')
        # return Response(json.dumps(results, default=json_serial), mimetype='application/json')
        # return Response(json.dumps(data, default=json_serial), mimetype='application/json')
        # return jsonify(username="A", email="B", id="C")
        # return jsonify(results)
        # data = cursor.fetchall()
        # row_headers=[x[0] for x in cursor.description] #this will extract row headers
        # json_data=dict(zip(row_headers,data))
        # return Response(json.dumps(json_data, default=json_serial), mimetype='application/json')
        # row_headers=[x[0] for x in cursor.description] #this will extract row headers
        # json_data=[]
        # for result in data:
        #     json_data=(dict(zip(row_headers,result)))
        # json_dumps(json_data))
        # # json.JSONEncoder().encode(
        #return Response(json.dumps(, default=json_serial), mimetype='application/json')

if __name__ == '__main__':
	init()
	# app.run(debug=True)
	app.run(host= '0.0.0.0', port=9000, debug=False)

