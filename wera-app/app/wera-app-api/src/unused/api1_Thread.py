import json
from flask import Flask, Response, request, jsonify, session, g, send_from_directory
from flask_restful import Resource, Api, reqparse
from flask_api import status
import uuid
global count
count = 0
# from flask_mysqldb import MySQL
import mysql.connector

import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth
from firebase_admin import messaging
# export GOOGLE_APPLICATION_CREDENTIALS="./wera-forum-app-credentials.json"
# cred = credentials.Certificate('./google-services.json')
cred = credentials.Certificate('./wera-forum-app-credentials.json')
# cred = credentials.Certificate('./wera-forum-app-firebase-adminsdk-credentials.json')
default_app = firebase_admin.initialize_app(cred, name="fire")
# print(default_app.name)
import threading
import redis

from datetime import date, datetime

def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""

    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError ("Type %s not serializable" % type(obj))

class API1(threading.Thread):
    user=None
    password=None
    host=None
    database=None
    localhost=None
    app = Flask(__name__)
    app.secret_key = "AHGAJKLSDBHJASDHGAKSLDFJHHASUGJRADKHGALKSDERGHASKL"
    
    @staticmethod
    def connect():
        return mysql.connector.connect(user=API1.user, password=API1.password, host=API1.localhost, database=API1.database)

    #firebase_admin.delete_app(default_app)

    def __init__(self, host, localhost, port):
        global count
        threading.Thread.__init__(self)
        # self.cred = credentials.Certificate("wera-forum-app-firebase-adminsdk-credentials.json")
        # print("initialize count: "+ str(count))
        # if not firebase_admin._apps:
        #     print("initializing")
        #     self.default_app = firebase_admin.initialize_app(self.cred)
        
        # self.default_app = firebase_admin.get_app()
        # print(self.default_app)

        count = count + 1
        self.api = Api(API1.app)
        global mysql
        # mysql = MySQL()
        # mysql.init_app(app)
        self.api.add_resource(Song, '/Song', '/Song/<int:song_id>')
        self.api.add_resource(Songs,'/Songs')
        self.api.add_resource(Tcp,'/Tcp')
        self.api.add_resource(Permissions,'/Permissions')
        self.api.add_resource(UserPermission,'/UserPermission','/UserPermission/<int:idUser>','/UserPermission/<int:idUser>/<int:idPermission>')
        self.api.add_resource(Users,'/Users')
        self.api.add_resource(User,'/User')
        self.api.add_resource(Superuser,'/Superuser/<int:id_user>')
        self.api.add_resource(FirebaseMessage,'/FirebaseMessage')
        self.api.add_resource(SendToNews,'/SendToNews')
        self.api.add_resource(SubscribeToNews,'/SubscribeToNews')
        self.api.add_resource(Token,'/Token')
        self.api.add_resource(Node,'/Node','/Node/<int:id>')
        self.api.add_resource(Nodes,'/Nodes')
        #self.host = host
        self.localhost = localhost
        self.port=port

        API1.localhost = localhost
        API1.user='wera-app-api'
        API1.password='2f39f1df1043c6c1d661f95de773d072'
        API1.host = '{WERA_STEUERUNG_API_DOMAIN}' #host
        API1.database='app'

    def run(self):
        print('API1 #> '+self.host+':'+str(self.port))
        # API1.app.run(ssl_context=('ssl/server.crt', 'ssl/server.key'), host=self.host, port=self.port, debug=False)
        API1.app.run(ssl_context=('{WERA_STEUERUNG_API_CERTS}/cert.pem', '{WERA_STEUERUNG_API_KEYS}privkey.pem'), host=self.host, port=self.port, debug=False)
        
        

    # def test(self):
    #     print("Test")

def log(uid, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody):
    # # print("log")
    # # conn = c()
    connection = API1.connect()
    cursor = connection.cursor()

    # # if len(uid) != 256:
    # print("uid: "+str(uid))
    # sql = "select idUser from user where uid = (%s)"
    # cursor.execute(sql, (uid,))
    # id = cursor.fetchone()
    # print("id: " + str(id))

    # sql = "select idUser from user where uid = (%s)"
    # cursor.execute(sql, (uid,))
    # id = cursor.fetchall()
    # print("id: " + str(id))
    # # else:
    # #     sql = "select idUser from user where idToken = (%s)"
    # #     cursor.execute(sql, (uid,))
    # #     id = cursor.fetchone()[0]
    # #print(id)
    sql = "insert into apilog (fiUser, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    #print(uid)
    #print(decodedToken)
    
    # print("api 1 >> user: " + str(id))

    cursor.execute(sql, (uid, requestIp, requestPath, requestMethod, requestEndpoint, str(requestHeader), requestBody))

    if cursor.rowcount > 0:
        connection.commit()

def create_user_if_not_exists(idToken, firebaseToken, fcmToken, deviceName, deviceVersion, identifier):
    # conn = c()
    # print(session["id"]+" > create_user_if_not_exists")
    connection = API1.connect()
    cursor = connection.cursor()
    sql = "select idUser from user WHERE idToken = %s"
    cursor.execute(sql, (idToken,))
    id = cursor.fetchall()
    # print(cursor.rowcount)
    if cursor.rowcount == 0:
        print(session["id"]+" idtoken empty or user not in database. In both cases, create a new user")
        # newUUID = searchToken(firebaseToken, fcmToken, deviceName, deviceVersion, identifier)
        
        # if newUUID == None:
        #    newUUID = uuid.uuid4()
        # print(session["id"]+" create user and send token back")
        sql = "insert into user (idToken, fcmToken) VALUES (%s, %s)"
        cursor.execute(sql, (str(idToken), fcmToken))
        if cursor.rowcount > 0:
            print(session["id"]+" inserted new user: "+str(cursor.lastrowid))
            connection.commit()
            insert_device_if_not_exists(cursor.lastrowid, deviceName, deviceVersion, identifier)
            return cursor.lastrowid
    else:
        # print("user already in database.")
        insert_device_if_not_exists(id[0][0], deviceName, deviceVersion, identifier)
        # print("found user already: " + str(id[0]))
        # print(str(id[0][0]))
        # return id[0][0]
        return id[0][0]

def check_permission(uid, requestPath, requestMethod, requestEndpoint):
    # conn = c()
    print(session["id"]+" check_permission")
    # print(uid)
    connection = API1.connect()
    cursor = connection.cursor()
    
    # check superuserPermissions
    print(session["id"]+" uid: " + str(uid))
    sql = "select fiUser from superuser WHERE fiUser = %s"
    cursor.execute(sql, (uid,))
    cursor.fetchall()
    # print(str(cursor.rowcount))
    if cursor.rowcount > 0:
        print(session["id"]+" access granted trough superuser")
        print(session["id"]+" I Am Iron Man. (superuser)")
        return True
    else:
        print(session["id"]+ " " + requestPath + " " + requestMethod)
        # print(session["id"]+" requestEndpoint)
        sql = "select idPermission from permission WHERE requestMethod = %s AND requestEndpoint = %s"
        cursor.execute(sql, (requestMethod, requestEndpoint))
        id = cursor.fetchone()
        if cursor.rowcount > 0:
            # print(session["id"]+" permission for %s is defined." % requestPath)
            # print(id)

            # check userPermissions
            # print("id[0]: (permission)" + str(id[0]))
            # print("uid: " + str(uid))
            sql = "select fiUser from userPermission join permission on idPermission = fiPermission WHERE fiUser = %s AND requestMethod = %s AND requestEndpoint = %s"
            cursor.execute(sql, (uid, requestMethod, requestEndpoint))
            cursor.fetchone()
            if cursor.rowcount > 0:
                print(session["id"]+" access granted trough userPermission")
                return True

            # check bundlePermissions
            # sql = "select fiUser from bundlePermission WHERE fiUser = %s AND requestMethod = %s AND requestEndpoint = %s"
            # cursor.execute(sql, (uid, requestMethod, requestPath))
            # cursor.fetchall()
            # if cursor.rowcount > 0:
            #     print("access granted trough bundlePermission")
            #     return True

            # check defaultPermissions
            sql = "select * from defaultPermission WHERE fiPermission = %s"
            cursor.execute(sql, (id[0],))
            cursor.fetchall()
            if cursor.rowcount > 0:
                print(session["id"]+" access granted trough defaultPermission")
                return True
            print(session["id"]+" MAYBE NOTHING FOUND?? DOUBLECHECK AND if so, return False here!!!!!!")
            print(session["id"]+" access denied. - Did You Pass Context? - Is A Permission In DB? - Are You Superuser?")
            return False
        else:
            print(session["id"]+" access denied. - Did You Pass Context? - Is A Permission In DB? - Are You Superuser?")
            return False
    
def searchToken(firebaseToken, fcmToken, deviceName, deviceVersion, identifier):
    connection = API1.connect()
    cursor = connection.cursor()
    # FALLE EINBAUEN! FALLS ETWAS ABWEICHT, STATUS CODE ZURÜCK GEBEN.
    sql = '''select idToken from user
                join deviceUser on deviceUser.idfiUser = user.idUser
                join device ON idDevice = idfiDevice
                join firebaseuserUser on firebaseuserUser.idfiUser = user.idUser
                join firebaseuser on idfiFirebaseUser = idFirebaseUser
                WHERE firebaseToken = %s
                OR fcmToken = %s
                OR (deviceName = %s AND deviceVersion = %s AND identifier = %s)                
                '''
    cursor.execute(sql, (firebaseToken, fcmToken, deviceName, deviceVersion, identifier))
    id = cursor.fetchall()
    if cursor.rowcount == 0:
        return None
    else:
        print(session["id"]+" i found a uuid from the specified headers: " + id[0][0])
        return id[0][0]

    # cursor = connection.cursor()
    # sql = '''select idToken from user
    #     join deviceUser on user.idUser = deviceUser.idfiUser
    #     join device on deviceUser.idfiDevice = device.idDevice
    #     join firebaseuserUser on firebaseuserUser.idfiUser = user.idUser
    #     join firebaseuser on firebaseuserUser.idfiFirebaseUser = firebaseuser.idFirebaseuser

    #     WHERE
    #         firebaseuser.firebaseToken = %s
    #         or
    #         user.fcmToken = %s
    #         or
    #         device.deviceName = %s and device.deviceVersion = %s and device.identifier = %s
    # '''
    # cursor.execute(sql, (firebaseToken, fcmToken, deviceName, deviceVersion, identifier))
    # realIdToken = cursor.fetchall()
    # if cursor.rowcount > 0:
    #     print("HEEE!! I GOT YOU ALREADY!: " + realIdToken)
    #     idToken = realIdToken

    # # print(session["id"]+" inserted or found idUser: "+str(idUser))
    # sql = "select idToken from user where idUser = %s"
    # cursor.execute(sql, (idUser,))
    # UUID = cursor.fetchall()
    # # print(session["id"]+" idToken: "+idToken)
    # if idToken == "null" or idToken != UUID[0][0]:
    #     # print(session["id"]+" null or idToken != UUID[0][0]")
    #     # session[identifier]=UUID[0][0]
    #     return {'uuid': UUID[0][0]}, status.HTTP_200_OK
    # if idToken == None:
    #     # print(session["id"]+" None")
    #     # session[identifier]=UUID[0][0]
    #     return {'uuid': UUID[0][0]}, status.HTTP_200_OK
    # # print(session["id"]+" rowcount: "+str(cursor.rowcount))
    # if cursor.rowcount > 0:
    #     # print(str(UUID[0][0]))
    #     # if idUser > -1:
    #     #         return {'uuid': UUID[0][0]}, status.HTTP_200_OK
    #     # else:
    #     cursor = connection.cursor()
    #     # print(session["id"]+" idToken for that user: "+str(UUID[0][0]))
    #     sql = "select idUser from user where idToken = %s"
    #     cursor.execute(sql, (UUID[0][0],))
    #     IDUSER = cursor.fetchall()
    #     if cursor.rowcount > 0:
    #         idUser = IDUSER[0][0]

    # print(session["id"]+" print idUser again... lol remove above: "+str(idUser))

def insert_device_if_not_exists(idUser, deviceName, deviceVersion, identifier):
    # print(session["id"]+" insert_device_if_not_exists")
    connection = API1.connect()
    cursor = connection.cursor()
    sql = "select idfiUser from deviceUser join device ON idDevice = idfiDevice WHERE deviceName = %s AND deviceVersion = %s AND identifier = %s"
    cursor.execute(sql, (deviceName, deviceVersion, identifier))
    id = cursor.fetchall()
    if cursor.rowcount == 0:
        # print(session["id"]+" insert device")
        sql = "insert into device (deviceName, deviceVersion, identifier) VALUES (%s, %s, %s)"
        cursor.execute(sql, (deviceName, deviceVersion, identifier))
        if cursor.rowcount > 0:    
            connection.commit()
        idDevice = cursor.lastrowid

        sql = "insert into deviceUser (idfiDevice, idfiUser) VALUES (%s, %s)"
        cursor.execute(sql, (idDevice, idUser))
        if cursor.rowcount > 0:
            connection.commit()
        print(session["id"]+" new device inserted.")
    else:
        pass
        # print("device %s already registered for User: %s" % str(id[0][0]), str(idUser))
        # print("device "+str(id[0][0])+" already registered for User: " + str(idUser))

def insert_firebase_user_if_not_exists_or_update(idUser, uid, firebaseToken, decodedToken):
    # print("insert firebase user or update")
    connection = API1.connect()
    cursor = connection.cursor()
    sql = "select idfiUser from firebaseuserUser join user ON idUser = idfiUser WHERE idUser = %s"
    cursor.execute(sql, (idUser,))
    id = cursor.fetchall()
    # print("rowcount firebaseuserUser: "+str(cursor.rowcount))
    if cursor.rowcount == 0:
        # print("insert firebaseuser")
        sql = "insert into firebaseuser (uid, firebaseToken, decodedToken) VALUES (%s, %s, %s)"
        # print(uid)
        # print(firebaseToken)
        # print(decodedToken)
        cursor.execute(sql, (uid, firebaseToken, str(decodedToken)))
        if cursor.rowcount > 0:    
            connection.commit()
        idFirebaseuser = cursor.lastrowid

        sql = "insert into firebaseuserUser (idfiUser, idfiFirebaseuser) VALUES (%s, %s)"
        cursor.execute(sql, (idUser, idFirebaseuser))
        if cursor.rowcount > 0:
            connection.commit()
        print(session["id"]+" firebaseuser inserted. idUser: " + str(idUser))
    else:
        # print("firebaseuser already in database")
        pass

r = redis.Redis(host=API1.host, port=6379, db=0)
def verify_token_uid_check_revoke(requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody):
    # print("verify_token_uid_check_revoke")
    # print("\n")
    connection = API1.connect()
    # print(session["id"]+" " + requestHeader["idToken"])
    # print("\n")
    try:
        idToken = requestHeader["idToken"]
        firebaseToken = requestHeader["firebaseToken"]
        fcmToken = requestHeader["fcmToken"]
        deviceName = requestHeader["deviceName"]
        deviceVersion = requestHeader["deviceVersion"]
        identifier = requestHeader["identifier"]
    except Exception as e:
        print(session["id"]+" Exception occured.")
        print(e)
    uid=""
    aud=""
    a = None
    b = None
    try:
        # if idToken == None:
        # print("no id token provided.")
        # 1. Token aus Gerätedaten ermitteln.
        # 2. Wenn nicht vorhanden, neu generieren.
        # 3. Token an Client übermitteln.
        idUser = create_user_if_not_exists(idToken, firebaseToken, fcmToken, deviceName, deviceVersion, identifier)
        
        
        print(session["id"] + " idUser: " + str(idUser))
        # else:
        # print("id token provided.")
        # 1. Das Token muss überprüft werden.
        # 2. Das Gerät wird auch überprüft.
        # a = create_user_if_not_exists(idToken, fcmToken, deviceName, deviceVersion, identifier)
        # b = None
        # return None, status.HTTP_403_FORBIDDEN # ERROR!!
        # return {'next_steps': 'check firebase token.'}, status.HTTP_200_OK

        #print("firebaseToken: " + firebaseToken)
        # print(len(firebaseToken))
        # print(firebaseToken != None)
        if firebaseToken != None and firebaseToken != "null":
            # Verify the ID token while checking if the token is revoked by
            # passing check_revoked=True.
            aud = None
            uid = None
            decodedToken = auth.verify_id_token(firebaseToken, check_revoked=True)
            # Token is valid and not revoked.
            # print("\n\n")
            # print(decodedToken)
            # print("\n\n")
            
            uid = decodedToken['uid']
            aud = decodedToken['aud']
            iat = decodedToken['iat']
            exp = decodedToken['exp']
            #print(uid)
            #print(aud)
            #print(decodedToken)
            if aud == "wera-forum-app":
                if uid != "":
                    #Auth okay.
                    #a = create_user_if_not_exists(idToken, fcmToken, deviceName, deviceVersion, identifier)
                    # b = str(decodedToken)
                    # print(session["id"]+" inserting firebase user.")
                    insert_firebase_user_if_not_exists_or_update(idUser, uid, firebaseToken, decodedToken)
                    #import datetime
                    #your_timestamp = 1331856000000
                    #date = datetime.datetime.fromtimestamp(your_timestamp / 1e3)
                    #return {"status": "quit."}, status.HTTP_200_OK

                else:
                    #Auth fail.
                    print(session["id"]+" Auth fail")
                    return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR
            else:
                print(session["id"]+" Auth fail")
                return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR
        print(session["id"]+" requestIp: " + requestIp)
        r.set('isonline:idUser:'+str(idUser), requestIp, ex=60)        
        log(idUser, requestIp, requestPath, requestMethod, requestEndpoint, requestHeader, requestBody)
        permission = check_permission(idUser, requestPath, requestMethod, requestEndpoint)
        print(session["id"]+" permission: " + str(permission))
        return permission
    except auth.RevokedIdTokenError:
        # Token revoked, inform the user to reauthenticate or signOut().
        # pass # return??
        return False
    except auth.InvalidIdTokenError:
        # Token is invalid
        # pass # return ??
        return False
    # [END verify_token_id_check_revoked]
def check_user_token():
    try:
        requestIp = request.remote_addr
        requestPath = request.path
        requestMethod = request.method
        requestEndpoint = request.endpoint
        requestHeader = request.headers
        requestBody = request.data
        return verify_token_uid_check_revoke(requestIp, requestPath, requestMethod, requestEndpoint, request.headers, requestBody)
    except Exception as e:
        print(e)

requestingUuidDict = {}

def foundInDatabase(idToken):
    connection = API1.connect()
    cursor = connection.cursor()
    sql = 'select idToken from user where idToken = %s'
    cursor.execute(sql, (idToken,))
    cursor.fetchall()
    if cursor.rowcount > 0:
        print(session["id"]+" before_request: found token in db.")
        return True
    else:
        print(session["id"]+" before_request: token NOT found in db.")
        return False

global i
i = 0

# app = Flask(__name__, static_url_path='')
# @app.route('/', defaults={'path': '/path/'})
# @app.route('/path/<path:path>')
# def get(path):
#     print(path)
#     return send_from_directory('/var/www', path)
# app.run(host="0.0.0.0", port=80, debug=False)
# # ssl_context=('ssl/server.crt', 'ssl/server.key'), 


@API1.app.before_request
# def before_calback(self):
def before_request():
    global i
    session["id"] = str(i)
    i = i+1
    #g.username = "root"
    print(session["id"]+" -------new request")
    # print(request.remote_addr)
    # print(request.headers)
    # print(request.path)
    # print(session["id"]+" "+request.endpoint)
    requestHeader = request.headers
    idToken = requestHeader["idToken"]
    # firebaseToken = requestHeader["firebaseToken"]
    # fcmToken = requestHeader["fcmToken"]
    # deviceName = requestHeader["deviceName"]
    # deviceVersion = requestHeader["deviceVersion"]
    # identifier = requestHeader["identifier"]
        
    if not foundInDatabase(idToken) and request.endpoint != 'token':
        return {"message": "Internal Server Error"}, status.HTTP_403_FORBIDDEN
    elif request.endpoint != 'token':
        if not check_user_token():
            return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR
@API1.app.after_request
def after_request(response):
    print(session["id"] + " " + str(response.get_data()[0:50])[0:37])
    return response

class Tcp(Resource):
    def post(self):
        # print("TCP - we are inside.")
        try:
           
            # r.set("")
            # Parse the arguments
            parser = reqparse.RequestParser()
            parser.add_argument('idToken', type=str, help='idToken')
            args = parser.parse_args()
            _idToken = args['idToken']
            print(session["id"]+" "+_idToken)
            return {'Message': 'Success'}, status.HTTP_200_OK
        except:
            a = 0

class Song(Resource):
    def post(self):
        try:
            connection = API1.connect()
            # Parse the arguments
            parser = reqparse.RequestParser()
            parser.add_argument('title', type=str, help='title')
            parser.add_argument('text', type=str, help='text')
            parser.add_argument('chordsJson', type=str, help='Chords in JSON Format')
            args = parser.parse_args()

            _title = args['title']
            _text = args['text']
            _chordsJson = args['chordsJson']

            # conn = c()
            cursor = connection.cursor()
            sql = "insert into song (title, text, chordsJson)values(%s, %s, %s)"
            cursor.execute(sql, (_title, _text, _chordsJson,))
            if cursor.rowcount > 0:
                connection.commit()
                return {'Message': 'Success'}, status.HTTP_200_OK
        except Exception as e:
            print(session["id"]+" Something went wrong: " + e)
    def get(self, song_id):
        # conn = c()
        connection = API1.connect()
        cursor = connection.cursor()
        sql = "select * from song WHERE id = %s"
        cursor.execute(sql, (song_id,))
        data = cursor.fetchone()
        row_headers=[x[0] for x in cursor.description] #this will extract row headers
        json_data=dict(zip(row_headers,data))
        return Response(json.dumps(json_data, default=json_serial), mimetype='application/json')
    def patch(self, song_id):
        try:
            connection = API1.connect()
            # Parse the arguments
            parser = reqparse.RequestParser()
            parser.add_argument('title', type=str, help='title')
            parser.add_argument('text', type=str, help='text')
            parser.add_argument('chordsJson', type=str, help='Chords in JSON Format')
            args = parser.parse_args()

            _title = args['title']
            _text = args['text']
            _chordsJson = args['chordsJson']
        
            # conn = c()
            cursor = connection.cursor()
            sql = "update song set title=%s, text=%s, chordsJson=%s where id=%s"
            cursor.execute (sql, (_title, _text, _chordsJson, song_id))
            if cursor.rowcount > 0:
                connection.commit()
                return {'StatusCode':'200','Message': 'Song patch success'}
            else:
                return {'StatusCode':'1000','Message': 'Song patch fail'}
        except Exception as e:
            return {'error': str(e)}
            
    # usage
    # results = dictfetchall(cursor)
    # json_results = json.dumps(results)

def dictfetchall(cursor):
    """Returns all rows from a cursor as a list of dicts"""
    desc = cursor.description
    return [ dict(zip([col[0] for col in desc], row)) for row in cursor.fetchall() ]

class Songs(Resource):
    def get(self):
        connection = API1.connect()
        # conn = c()
        cursor = connection.cursor()
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

    # if __name__ == '__main__':
    #     init()
    #     # app.run(debug=True)
    #     app.run(host= '0.0.0.0', port=9000, debug=False)

class Users(Resource):
    def get(self):
        try:
            print("/Users")
            connection = API1.connect()
            cursor = connection.cursor()
            sql = "select user.*, superuser.fiUser as superuser from user left join superuser on idUser = fiUser"
            cursor.execute(sql)
            result = dictfetchall(cursor)
            print(cursor.rowcount)
            if cursor.rowcount > 0:
                print(session["id"]+" lastrowid: " + str(cursor.lastrowid))
                return Response(json.dumps(result, default=json_serial), mimetype='application/json')
            else:
                return {"message": "Internal Server Errorr"}, status.HTTP_500_INTERNAL_SERVER_ERROR
        except Exception as e:
            print(e)

class User(Resource):
    def patch(self):
        try:
            print(session["id"]+" Patching!")
            # # Parse the arguments
            # parser = reqparse.RequestParser()
            # parser.add_argument('title', type=str, help='title')
            # parser.add_argument('text', type=str, help='text')
            # parser.add_argument('chordsJson', type=str, help='Chords in JSON Format')
            # args = parser.parse_args()

            # _title = args['title']
            # _text = args['text']
            # _chordsJson = args['chordsJson']
        
            # # conn = c()
            # cursor = connection.cursor()
            # sql = "update song set title=%s, text=%s, chordsJson=%s where id=%s"
            # cursor.execute (sql, (_title, _text, _chordsJson, song_id))
            # if cursor.rowcount > 0:
            #     connection.commit()
            #     return {'StatusCode':'200','Message': 'Song patch success'}
            # else:
            #     return {'StatusCode':'1000','Message': 'Song patch fail'}
        except Exception as e:
            return {'error': str(e)}

class Superuser(Resource):
    def put(self, id_user):
        connection = API1.connect()
        cursor = connection.cursor()
        print(session["id"]+" Make Superuser: %s" % id_user)
        sql = "insert into superuser VALUES (%s)"
        cursor.execute(sql, (id_user,))
        if cursor.rowcount > 0:
            # print("inserted superuser\n\t->idUser: %s, lastrowid: %s" % str(id_user), str(cursor.lastrowid))
            connection.commit()
    def delete(self, id_user):
        connection = API1.connect()
        cursor = connection.cursor()
        print(session["id"]+" Remove Superuser: %s" % id_user)
        sql = "delete from superuser where fiUser = %s"
        cursor.execute(sql, (id_user,))
        if cursor.rowcount > 0:
            # print("deleted superuser\n\t->idUser: %s, lastrowid: %s" % str(id_user), str(cursor.lastrowid))
            connection.commit()

class SubscribeToNews(Resource):
    def post(self):
        requestHeader = request.headers
        fcmToken = requestHeader["fcmToken"]
        messaging.subscribe_to_topic(fcmToken, "news", app=default_app)
        print(session["id"]+" Firebase Subscription triggered.")
        return {'Message': 'Success'}, status.HTTP_200_OK

class FirebaseMessage(Resource):
    def post(self):
        import datetime
        requestHeader = request.headers
        fcmToken = requestHeader["fcmToken"]
        message = messaging.Message(
            notification=messaging.Notification(
                title='Title',
                body='Body',
            ),
            android=messaging.AndroidConfig(
                ttl=datetime.timedelta(seconds=3600),
                priority='normal',
                notification=messaging.AndroidNotification(
                    icon='stock_ticker_update',
                    color='#f45342'
                ),
            ),
            apns=messaging.APNSConfig(
                payload=messaging.APNSPayload(
                    aps=messaging.Aps(badge=42),
                ),
            ),
            token=fcmToken,
        )
        response = messaging.send(message, app=default_app)
        # Response is a message ID string.
        print('Successfully sent message:', response)

        print(session["id"]+" FirebaseMessage triggered.")
        return {'Message': 'Success'}, status.HTTP_200_OK

class SendToNews(Resource):
    def post(self):

        # Send notification messages or data messages
        # Send notification messages that are displayed to your user. Or send data messages and determine completely what happens in your application code.

        # Versatile message targeting
        # Send To Single Device
        # Send To Group of Devices
        # Send To Devices Registered To A Topic

        # Send messages from client apps
        # Send acknowledgments, chats, and other messages from devices back to your server over FCM’s reliable and battery-efficient connection channel.


        # A trusted environment such as Cloud Functions for Firebase or an app server on which to build, target, and send messages.
        # An iOS, Android, or web (JavaScript) client app that receives messages via the corresponding platform-specific transport service.



        # See documentation on defining a message payload.
        message = messaging.Message(
            notification=messaging.Notification(
                title='title',
                body='body'
            ),
            topic='news'
        )
        # {
        #     'score': '850',
        #     'time': '2:45',
        # }

        # Send a message to the device corresponding to the provided
        # registration token.
        response = messaging.send(message, app=default_app)
        # Response is a message ID string.
        print('Successfully sent message:', response)

        print(session["id"]+" FirebaseMessage send to topic.")
        return {'Message': 'Success'}, status.HTTP_200_OK

class Token(Resource):
    def get(self):
        try:
            requestHeader = request.headers
            firebaseToken = requestHeader["firebaseToken"]
            fcmToken = requestHeader["fcmToken"]
            deviceName = requestHeader["deviceName"]
            deviceVersion = requestHeader["deviceVersion"]
            identifier = requestHeader["identifier"]
            try:
                newUUID = searchToken(firebaseToken, fcmToken, deviceName, deviceVersion, identifier)
                if newUUID == None:
                    newUUID = uuid.uuid4()
                create_user_if_not_exists(str(newUUID), firebaseToken, fcmToken, deviceName, deviceVersion, identifier)
                return {"uuid": str(newUUID)}, status.HTTP_200_OK
            except Exception as e:
                print(e)
        except Exception as e:
            return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR

class Permissions(Resource):
    def get(self):
        connection = API1.connect()
        cursor = connection.cursor()
        sql = '''select idPermission, requestPath, requestMethod, requestEndpoint from permission'''
        cursor.execute(sql)
        return Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json')

class UserPermission(Resource):
    def put(self):
        print(request.data)
        idUser = request.json["idUser"]
        idPermission = request.json["idPermission"]
        print(idUser)
        print(idPermission)
        connection = API1.connect()
        cursor = connection.cursor()
        sql = "insert into userPermission VALUES (%s, %s)"
        cursor.execute(sql, (idUser, idPermission))
        if cursor.rowcount > 0:
            print(session["id"]+" Add userPermission for fiUser: %s and fiPermission: %s" % (str(idUser), str(idPermission)) )
            connection.commit()
            return {'Message': 'Success'}, status.HTTP_200_OK
        return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR
    def delete(self, idUser, idPermission):
        # print(request.data)
        # idUser = request.data["idUser"]
        # idPermission = request.data["idPermission"]
        print(idUser)
        print(idPermission)
        connection = API1.connect()
        cursor = connection.cursor()
        print(session["id"]+" Remove userPermission: %s" % idUser)
        sql = "delete from userPermission where fiUser = %s and fiPermission = %s"
        cursor.execute(sql, (idUser, idPermission,))
        if cursor.rowcount > 0:
            print(session["id"]+" Del userPermission for fiUser: %s and fiPermission: %s" % (str(idUser), str(idPermission)) )
            connection.commit()
            return {'Message': 'Success'}, status.HTTP_200_OK
        return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR
    def get(self, idUser):
    # def post(self):
        try:
            # print("/Permission")
            # idToken = request.json["idToken"]
            
            requestHeader = request.headers
            firebaseToken = requestHeader["firebaseToken"]
            fcmToken = requestHeader["fcmToken"]
            deviceName = requestHeader["deviceName"]
            deviceVersion = requestHeader["deviceVersion"]
            identifier = requestHeader["identifier"]

            connection = API1.connect()
            cursor = connection.cursor()
            sql = '''select idPermission, requestPath, requestMethod, requestEndpoint from permission
                join userPermission on fiPermission = idPermission
                join user on fiUser = idUser
                WHERE idUser = %s
            '''
            cursor.execute(sql, (idUser,))
            return Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json')

        except Exception as e:
            return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR


def select(sql, params):
    print("select")
    connection = API1.connect()
    cursor = connection.cursor()
    cursor.execute(sql, params)
    # cursor.fetchall()
    return cursor.rowcount, Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json')
    # json.dumps(dictfetchall(cursor))

def insert(insertSql, params):
    print("insert")
    connection = API1.connect()
    cursor = connection.cursor()
    cursor.execute(insertSql, params)
    if cursor.rowcount > 0:
        print("added: " + str(cursor.lastrowid))
        connection.commit()
        return cursor.lastrowid
    return -1

def update(updateSql, params):
    print("update")
    connection = API1.connect()
    cursor = connection.cursor()
    cursor.execute(updateSql, params)    
    cursor.execute (updateSql, params)
    if cursor.rowcount > 0:
        connection.commit()
        return cursor.lastrowid
    return -1

def delete(deleteSql, params):
    connection = API1.connect()
    cursor = connection.cursor()
    cursor.execute(deleteSql, params)
    if cursor.rowcount > 0:
        connection.commit()
        return cursor.lastrowid
    return -1

class Node(Resource):
    def get(self, id):
        print("get")
        node = select("select * from node where idNode > %s", (id,))
        print(node[0])
        print(node[1])
        return {'Message': 'Success'}, status.HTTP_200_OK
        # connection = API1.connect()
        # cursor = connection.cursor()
        # sql = '''select idNode, fiWidgetType, jsonData from node
        #     WHERE idNode = %s'''
        # cursor.execute(sql, (id,))
        # return Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json')
    def put(self):
        print("put with parent")

        idNode = request.json["idNode"]
        fiWidgetType = request.json["fiWidgetType"]
        jsonData = request.json["jsonData"]
        fiParentNode = None
        id = insert("insert into node VALUES (%s, %s, %s)", (idNode, fiWidgetType, jsonData))
        print(str(id))
        # insert("insert into nodeTree (idNodeTree, fiParentNode, fiNode, sort) select null, %s, %s, max(sort)+500 from nodeTree where fiParentNode = %s", (id, fiParentNode, fiParentNode))
        insert("insert into nodeTree select null, %s, %s, max(sort)+500 from nodeTree where fiParentNode = %s", (id, fiParentNode, fiParentNode))
        return select("select idNode, fiWidgetType, jsonData from node where idNode = %s", (id,))[1]
        # ??? return Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json') ???
        # return {'Message': 'Success'}, status.HTTP_200_OK
        # update("update node set fiWidgetType=%s, jsonData=%s where id=%s", (fiWidgetType, jsonData))
        # print(request.data)
        # idNode = request.json["idNode"]
        # fiWidgetType = request.json["fiWidgetType"]
        # jsonData = request.json["jsonData"]

        # connection = API1.connect()
        # cursor = connection.cursor()

        # print(idNode)
        # print(request.json["idNode"])
        # print(idParent)

        # sql = "select idNode from node where idNode = %s"
        # cursor.execute(sql, (idNode,))
        # cursor.fetchall()
        # if cursor.rowcount == 0:
        #     sql = "insert into node VALUES (%s, %s, %s)"
        #     cursor.execute(sql, (idNode, fiWidgetType, jsonData))
        #     if cursor.rowcount > 0:
        #         print("added Node." + str(cursor.lastrowid))
        #         connection.commit()
        #         sql = '''select idNode, fiWidgetType, jsonData from node
        #             WHERE idNode = %s'''
        #         cursor.execute(sql, (cursor.lastrowid,))

        #         if idParent:

        #             print("inserting in nodeTree")
        #             sql = "insert into nodeTree VALUES (%s, %s, (select max(sort)+500 from nodeTree where ) )"
        #             cursor.execute(sql, (fiParentNode, idNode, sort))
        #             if cursor.rowcount > 0:
        #                 print("added Node." + str(cursor.lastrowid))
        #                 connection.commit()


        #         return Response(json.dumps(dictfetchall(cursor), default=json_serial), mimetype='application/json')
        #         # return {'Message': 'Success'}, status.HTTP_200_OK
        # else:
        #     sql = "update node set fiWidgetType=%s, jsonData=%s where id=%s"
        #     cursor.execute (sql, (fiWidgetType, jsonData, idNode))
        #     if cursor.rowcount > 0:
        #         connection.commit()
        #         return {'StatusCode':'200','Message': 'Node patch success'}
        # return {"message": "Internal Server Error"}, status.HTTP_500_INTERNAL_SERVER_ERROR
    def delete(self, id):
        print("delete")
        print(str(id))
        return {'Message': 'Success'}, status.HTTP_200_OK

class Nodes(Resource):
    def get(self, idParent, page):
        print("all nodes")
