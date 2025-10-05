-- MariaDB dump 10.17  Distrib 10.4.12-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: app
-- ------------------------------------------------------
-- Server version	10.4.12-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `apilog`
--

DROP TABLE IF EXISTS `apilog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apilog` (
  `fiUser` int(11) DEFAULT NULL,
  `requestIp` varchar(50) DEFAULT NULL,
  `requestPath` varchar(50) DEFAULT NULL,
  `requestMethod` varchar(5) DEFAULT NULL,
  `requestEndpoint` varchar(50) DEFAULT NULL,
  `requestHeader` text DEFAULT NULL,
  `requestBody` text DEFAULT NULL,
  `response` text DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `modified` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  KEY `fiUser` (`fiUser`),
  CONSTRAINT `apilog_ibfk_1` FOREIGN KEY (`fiUser`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apilog`
--

LOCK TABLES `apilog` WRITE;
/*!40000 ALTER TABLE `apilog` DISABLE KEYS */;
INSERT INTO `apilog` VALUES (NULL,'0.0.0.0','/Song/4','GET','song','Host: localhost\r\nConnection: keep-alive\r\nCache-Control: no-cache\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Safari/537.36\r\nPostman-Token: b467749c-9d6c-afd7-5f88-1298bbc24175\r\nAccept: */*\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-08 16:27:34','2020-05-08 16:27:34'),(NULL,'0.0.0.0','/Song/4','GET','song','Host: localhost:9000\r\nConnection: keep-alive\r\nCache-Control: no-cache\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Safari/537.36\r\nPostman-Token: cb66b80a-5c6a-3bfe-4c33-176ebdb012b1\r\nAccept: */*\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-08 16:27:34','2020-05-08 16:27:34'),(NULL,'0.0.0.0','/Song/2','PATCH','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json; charset=utf-8\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 281\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:29:37','2020-05-08 16:29:37'),(NULL,'0.0.0.0','/Song/2','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:32:42','2020-05-08 16:32:42'),(NULL,'0.0.0.0','/Song/4','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:32:45','2020-05-08 16:32:45'),(NULL,'0.0.0.0','/Song/2','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:32:46','2020-05-08 16:32:46'),(NULL,'0.0.0.0','/Song/18','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:32:59','2020-05-08 16:32:59'),(NULL,'0.0.0.0','/Song/2','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:33:00','2020-05-08 16:33:00'),(NULL,'0.0.0.0','/Song/3','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:33:01','2020-05-08 16:33:01'),(NULL,'0.0.0.0','/Song/17','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:33:02','2020-05-08 16:33:02'),(NULL,'0.0.0.0','/Song/1','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:33:03','2020-05-08 16:33:03'),(NULL,'0.0.0.0','/Song/2','GET','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 16:33:04','2020-05-08 16:33:04'),(NULL,'0.0.0.0','/Songs','GET','songs','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 0\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 18:35:07','2020-05-08 18:35:07'),(NULL,'0.0.0.0','/Song','POST','song','User-Agent: Dart/2.7 (dart:io)\r\nContent-Type: application/json; charset=utf-8\r\nAccept: application/json\r\nAccept-Encoding: gzip\r\nContent-Length: 281\r\nHost: 0.0.0.0:9000\r\n\r\n',NULL,'','2020-05-08 18:35:07','2020-05-08 18:35:07'),(NULL,'0.0.0.0','/','GET',NULL,'Host: 0.0.0.0:9000\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Linux; Android 9; ANE-LX1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Mobile Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-26 13:24:18','2020-05-26 13:24:18'),(NULL,'0.0.0.0','/favicon.ico','GET',NULL,'Host: 0.0.0.0:9000\r\nConnection: keep-alive\r\nUser-Agent: Mozilla/5.0 (Linux; Android 9; ANE-LX1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Mobile Safari/537.36\r\nAccept: image/webp,image/apng,image/*,*/*;q=0.8\r\nReferer: http://0.0.0.0:9000/\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-26 13:24:18','2020-05-26 13:24:18'),(NULL,'0.0.0.0','/Songs','GET','songs','Host: 0.0.0.0:9000\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Linux; Android 9; ANE-LX1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Mobile Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-26 13:26:00','2020-05-26 13:26:00'),(NULL,'0.0.0.0','/Songs','GET','songs','Host: 0.0.0.0:9000\r\nConnection: keep-alive\r\nCache-Control: max-age=0\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Linux; Android 9; ANE-LX1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Mobile Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-26 13:28:03','2020-05-26 13:28:03'),(NULL,'0.0.0.0','/Songs','GET','songs','Host: 0.0.0.0:9000\r\nConnection: keep-alive\r\nCache-Control: max-age=0\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Linux; Android 9; ANE-LX1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Mobile Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7\r\n\r\n',NULL,'','2020-05-26 13:28:06','2020-05-26 13:28:06');
/*!40000 ALTER TABLE `apilog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission` (
  `fiUser` int(11) NOT NULL,
  `requestMethod` varchar(5) DEFAULT NULL,
  `requestEndpoint` varchar(50) DEFAULT NULL,
  `fiUserMaster` int(11) DEFAULT NULL,
  `delegateGrant` int(11) DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `song` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(45) DEFAULT NULL,
  `text` text DEFAULT NULL,
  `chordsJson` text DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `modified` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'No Longer Slaves','Du umgibst mich Herr, mit dem Siegeslied.\nJesus du hast mich befreit.\nHeute fürcht\' ich nicht, was der Morgen bringt.\nIch bin mit dir vereint.\n\nEin Knecht der Sünde bin ich nicht mehr.\nDenn ich bin ein Kind des Herrn.\nEin Knecht der Sünde bin ich nicht mehr,\nDenn ich bin ein Kind des Herrn.\n\nVon Anbeginn, bin ich auserwählt,\nbeim Namen nennst du micht.\nJesus durch dein Blut, hast du mich erlöst,\nwie sehr liebst du mich.','{ \"C\" }','2020-04-27 22:09:56','2020-04-30 18:34:07'),(2,'Da ist Kraft','Da ist Kraft in dem Namen Jesus.\nDa ist Kraft in dem Namen Jesus.\nEr bricht jede Kette, er bricht jede Kette,\ner bricht jeden Fluch. test\n','{ \"C\" }','2020-04-27 22:10:34','2020-05-08 16:29:37'),(3,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht,\nFeuer in mir entfacht!\n\nUnd ich stecke mich aus und rufe zu dir!\nSei der Neustart in mir. Sei der Neustart in mir!\n\nIch schau nie mehr zurück, ich schau nach vorn.\nich bin ein neuer Mensch, ich bin neu geboren.\nNeugeboren!\n\nNeu geboren.\nNeu Geboren.\n\nStrophe\n\nSei der Neustart in mir.\nSei der Neustart in mir.','{ \"C\" }','2020-04-28 10:43:33','2020-04-30 18:30:19'),(4,'Da ist ein Feuer','Da ist ein Feuer, das in mir brennt,\nund das die Welt nicht löschen kann.\nDa ist ein Feuer, das in mir brennt,\nund das ist: Jesus!\n\nBrenne noch stärker, nimm alles, was ich bin.\nIch sage: brenne noch stärker in mir.','{ \"C\" }','2020-04-28 10:43:43','2020-04-30 18:28:28'),(17,'Freier als der Wind','Eyo, Freier als der Wind\nweil wir Gottes Kinder sind.\n\nGott ist gut und er hat gesiegt,\nweil seine Liebe immer überwiegt.','{ \"C\" }','2020-04-28 12:06:53','2020-04-30 18:35:16'),(18,'Gnade','Lob erfüllt unser Herz, deine Gnade ist treu.\nWir danken für dein Kreuz.\n\nGnade, Gnade so endlos wie die Zeit.\nIch sing dein, Halleluja, bis in die Ewigkeit.','{ \"C\" }','2020-04-28 12:06:53','2020-05-04 12:09:39'),(19,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht -\nFeuer in mir entfacht!','{ \"C\" }','2020-05-08 10:19:14','2020-05-08 10:19:14'),(20,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht -\nFeuer in mir entfacht!','{ \"C\" }','2020-05-08 10:26:36','2020-05-08 10:26:36'),(21,'Neustart','Heute ist alles neu!\nHeute ist die Zeit zum freuen!\nDenn du hast mich befreit,\nDu hast mein Herz geheilt.\n\nDas alte ist vorbei,\nwerd\' nie der alte sein.\nDu hast mich neu gemacht -\nFeuer in mir entfacht!','{ \"C\" }','2020-05-08 10:27:46','2020-05-08 10:27:46');
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `decodedToken` text DEFAULT NULL,
  `uid` varchar(28) NOT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `modified` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`,`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-01  9:43:16
