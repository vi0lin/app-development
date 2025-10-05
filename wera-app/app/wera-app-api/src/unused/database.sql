CREATE DATABASE IF NOT EXISTS app;
DROP DATABASE app;
SET NAMES 'utf8';
CREATE DATABASE IF NOT EXISTS app;
# CHARACTER SET = 'utf8mb4'
# COLLATE = 'utf8mb4_unicode_ci';
USE app;

CREATE TABLE if not exists user (
    idUser INT NOT NULL AUTO_INCREMENT,
    idToken TEXT NULL,
    fcmToken TEXT NULL, # >>Muss entweder in den User oder in den firebaseUser<<
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idUser)
);

                CREATE TABLE if not exists person(
                    fiUser INT NOT NULL,
                    vorname VARCHAR(50),
                    nachname VARCHAR(50),
                    geburtsdatum DATETIME,
                    email VARCHAR(100),
                    phone VARCHAR(20),
                    FOREIGN KEY(fiUser) REFERENCES user(idUser)
                );

        CREATE TABLE if not exists device(
            idDevice INT NOT NULL AUTO_INCREMENT,
            deviceName VARCHAR(50) NOT NULL,
            deviceVersion VARCHAR(50) NOT NULL,
            identifier VARCHAR(50) NOT NULL,
            created DATETIME DEFAULT CURRENT_TIMESTAMP,
            modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY(idDevice)
        );

                CREATE TABLE if not exists deviceUser (
                    idfiDevice INT NOT NULL,
                    idfiUser INT NOT NULL,
                    FOREIGN KEY(idfiDevice) REFERENCES device(idDevice),
                    FOREIGN KEY(idfiUser) REFERENCES user(idUser),
                    PRIMARY KEY(idfiDevice, idfiUser)
                );

        CREATE TABLE if not exists firebaseuser (
            idFirebaseuser INT NOT NULL AUTO_INCREMENT,
            uid VARCHAR(28) NULL,
            firebaseToken TEXT NOT NULL,
            decodedToken TEXT NULL,
            created DATETIME DEFAULT CURRENT_TIMESTAMP,
            modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (idFirebaseuser, uid)
        );

                CREATE TABLE if not exists firebaseuserUser (
                    idfiUser INT,
                    idfiFirebaseuser INT,
                    PRIMARY KEY(idfiUser, idfiFirebaseuser),
                    FOREIGN KEY(idfiUser) REFERENCES user(idUser),
                    FOREIGN KEY(idfiFirebaseuser) REFERENCES firebaseuser(idFirebaseuser)
                );

CREATE TABLE if not exists bundle (
    idBundle INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idBundle)
);

CREATE TABLE if not exists userBundle (
    fiUser INT,
    fiBundle INT,
    FOREIGN KEY(fiUser) REFERENCES user(idUser),
    FOREIGN KEY(fiBundle) REFERENCES bundle(idBundle)
);

CREATE TABLE if not exists push (
    idPush INT NOT NULL AUTO_INCREMENT,
    text TEXT NULL,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idPush)
);

CREATE TABLE if not exists song (
    id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(45) NULL,
    text TEXT NULL,
    chordsJson TEXT NULL,
    img blob,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);

CREATE TABLE if not exists permission (
	idPermission INT NOT NULL AUTO_INCREMENT,
    requestPath VARCHAR(50),
	requestMethod VARCHAR(5),
    requestEndpoint VARCHAR(50),
    PRIMARY KEY(idPermission)
);

CREATE TABLE if not exists userPermission (
    fiUser INT NOT NULL,
	fiPermission INT NOT NULL,
	# fiUserMaster INT NULL,
	# delegateGrant INT DEFAULT -1
    FOREIGN KEY(fiUser) REFERENCES user(idUser),
    FOREIGN KEY(fiPermission) REFERENCES permission(idPermission),
    PRIMARY KEY(fiUser, fiPermission)
);

CREATE TABLE if not exists bundlePermission (
    fiBundle INT NOT NULL,
	fiPermission INT,
    FOREIGN KEY(fiBundle) REFERENCES bundle(idBundle),
    FOREIGN KEY(fiPermission) REFERENCES permission(idPermission)
);

CREATE TABLE if not exists defaultPermission (
	fiPermission INT,
    FOREIGN KEY(fiPermission) REFERENCES permission(idPermission),
    PRIMARY KEY(fiPermission)
);
CREATE TABLE if not exists superuser (
	fiUser INT,
    FOREIGN KEY(fiUser) REFERENCES user(idUser),
    PRIMARY KEY(fiUser)
);

CREATE TABLE if not exists apilog (
    fiUser INT NULL,
    requestIp VARCHAR(50),
    requestPath VARCHAR(50),
    requestMethod VARCHAR(5),
    requestEndpoint VARCHAR(50),
    requestHeader TEXT,
    requestBody TEXT,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(fiUser) REFERENCES user(idUser)
);


CREATE TABLE if not exists widgetType(
    idWidgetType INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    PRIMARY KEY(idWidgetType)
);

CREATE TABLE if not exists node(
    idNode INT NOT NULL AUTO_INCREMENT,
    fiWidgetType INT,
    jsonData TEXT,
    PRIMARY KEY(idNode),
    FOREIGN KEY(fiWidgetType) REFERENCES widgetType(idWidgetType)
);

-- CREATE TABLE if not exists nodeUserPermission(
--     fiNode INT NULL,
--     recursion INT NOT NULL DEFAULT 0,
--     FOREIGN KEY(fiNode) REFERENCES node(idNode)
-- );

CREATE TABLE if not exists nodeTree(
    idNodeTree INT NOT NULL AUTO_INCREMENT,
    fiParentNode INT NULL,
    fiNode INT NULL,
    sort INT NOT NULL,
    PRIMARY KEY(idNodeTree),
    FOREIGN KEY(fiParentNode) REFERENCES node(idNode),
    FOREIGN KEY(fiNode) REFERENCES node(idNode)
);


INSERT INTO `permission` VALUES
    (null, '/Songs', 'GET', 'songs'),
    (null, '/Token', 'GET', 'songs'),
    (null, '/Users', 'GET', 'users'),
    (null, "/Superuser/%", "PUT", "superuser"),
    (null, "/Superuser/%", "DELETE", "superuser"),
    (null, '/Node', 'GET', 'node'),
    (null, '/Node', 'PUT', 'node'),
    (null, "/Node/%", "PUT", "node"),
    (null, '/Node', 'DELETE', 'node'),
    (null, '/Nodes', 'GET', 'nodes');

INSERT INTO `defaultPermission` VALUES (1), (2);

INSERT INTO widgetType (name) VALUES ('site'), ('text'), ('image'), ('html'), ('audio'), ('video');

--INSERT INTO `userPermission` VALUES ('1');
--INSERT INTO `bundlePermission` VALUES ('', '1');
INSERT INTO `song` (id, title,  text, chordsJson, created, modified) VALUES (1,'No Longer Slaves','Du umgibst mich Herr, mit dem Siegeslied.\nJesus du hast mich befreit.\nHeute fürcht\' ich nicht, was der Morgen bringt.\nIch bin mit dir vereint.\n\nEin Knecht der Sünde bin ich nicht mehr.\nDenn ich bin ein Kind des Herrn.\nEin Knecht der Sünde bin ich nicht mehr,\nDenn ich bin ein Kind des Herrn.\n\nVon Anbeginn, bin ich auserwählt,\nbeim Namen nennst du micht.\nJesus durch dein Blut, hast du mich erlöst,\nwie sehr liebst du mich.','{ \"C\" }','2020-04-27 22:09:56','2020-04-30 18:34:07'),(2,'Da ist Kraft','Da ist Kraft in dem Namen Jesus.\nDa ist Kraft in dem Namen Jesus.\nEr bricht jede Kette, er bricht jede Kette,\ner bricht jeden Fluch. test\n','{ \"C\" }','2020-04-27 22:10:34','2020-05-08 16:29:37'),(3,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht,\nFeuer in mir entfacht!\n\nUnd ich stecke mich aus und rufe zu dir!\nSei der Neustart in mir. Sei der Neustart in mir!\n\nIch schau nie mehr zurück, ich schau nach vorn.\nich bin ein neuer Mensch, ich bin neu geboren.\nNeugeboren!\n\nNeu geboren.\nNeu Geboren.\n\nStrophe\n\nSei der Neustart in mir.\nSei der Neustart in mir.','{ \"C\" }','2020-04-28 10:43:33','2020-04-30 18:30:19'),(4,'Da ist ein Feuer','Da ist ein Feuer, das in mir brennt,\nund das die Welt nicht löschen kann.\nDa ist ein Feuer, das in mir brennt,\nund das ist: Jesus!\n\nBrenne noch stärker, nimm alles, was ich bin.\nIch sage: brenne noch stärker in mir.','{ \"C\" }','2020-04-28 10:43:43','2020-04-30 18:28:28'),(17,'Freier als der Wind','Eyo, Freier als der Wind\nweil wir Gottes Kinder sind.\n\nGott ist gut und er hat gesiegt,\nweil seine Liebe immer überwiegt.','{ \"C\" }','2020-04-28 12:06:53','2020-04-30 18:35:16'),(18,'Gnade','Lob erfüllt unser Herz, deine Gnade ist treu.\nWir danken für dein Kreuz.\n\nGnade, Gnade so endlos wie die Zeit.\nIch sing dein, Halleluja, bis in die Ewigkeit.','{ \"C\" }','2020-04-28 12:06:53','2020-05-04 12:09:39'),(19,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht -\nFeuer in mir entfacht!','{ \"C\" }','2020-05-08 10:19:14','2020-05-08 10:19:14'),(20,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht -\nFeuer in mir entfacht!','{ \"C\" }','2020-05-08 10:26:36','2020-05-08 10:26:36'),(21,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht -\nFeuer in mir entfacht!','{ \"C\" }','2020-05-08 10:27:46','2020-05-08 10:27:46');
