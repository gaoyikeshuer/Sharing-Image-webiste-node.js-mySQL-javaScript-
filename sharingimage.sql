-- MySQL dump 10.13  Distrib 8.0.28, for macos11 (x86_64)
--
-- Host: 127.0.0.1    Database: sharingimage
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `commentid` int unsigned NOT NULL AUTO_INCREMENT,
  `commenttext` text NOT NULL,
  `commenttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `postid` int unsigned NOT NULL,
  `userid` int unsigned NOT NULL,
  PRIMARY KEY (`commentid`),
  KEY `postid` (`postid`),
  KEY `Comments_ibfk_2_idx` (`userid`),
  CONSTRAINT `Comments_ibfk_1` FOREIGN KEY (`postid`) REFERENCES `posts` (`postid`),
  CONSTRAINT `Comments_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'It\'s so nice','2022-04-05 21:38:21',4,1),(2,'I love this image!','2022-04-05 21:44:43',7,3);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `likeid` int unsigned NOT NULL AUTO_INCREMENT,
  `postid` int unsigned NOT NULL,
  `userid` int unsigned NOT NULL,
  `likecount` int NOT NULL,
  PRIMARY KEY (`likeid`),
  KEY `Likes_idfk_1_idx` (`postid`),
  KEY `Likes_idfk_2_idx` (`userid`),
  CONSTRAINT `Likes_idfk_1` FOREIGN KEY (`postid`) REFERENCES `posts` (`postid`),
  CONSTRAINT `Likes_idfk_2` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (3,4,1,1),(5,5,2,1),(6,4,2,1),(7,7,3,1),(8,9,2,1);
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `postid` int unsigned NOT NULL AUTO_INCREMENT,
  `userid` int unsigned NOT NULL,
  `posttitle` varchar(50) DEFAULT NULL,
  `posttag` varchar(25) DEFAULT NULL,
  `imageurl` varchar(255) NOT NULL,
  `posttime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `likecount` int unsigned DEFAULT '0',
  `commentcount` int unsigned DEFAULT '0',
  PRIMARY KEY (`postid`),
  UNIQUE KEY `imageurl` (`imageurl`),
  KEY `Posts_ibfk_1_idx` (`userid`),
  CONSTRAINT `Posts_idfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (4,1,NULL,NULL,'http://localhost:8000/uploads/col8.jpeg','2022-04-05 21:43:43',2,1),(5,2,NULL,NULL,'http://localhost:8000/uploads/col16.jpeg','2022-04-05 21:43:43',1,0),(6,2,NULL,NULL,'http://localhost:8000/uploads/attackontitan.jpeg','2022-04-05 21:42:40',1,0),(7,3,NULL,NULL,'http://localhost:8000/uploads/col11.jpeg','2022-04-05 21:44:56',1,1),(8,3,NULL,NULL,'http://localhost:8000/uploads/col17.jpeg','2022-04-05 21:44:56',0,0),(9,2,NULL,NULL,'http://localhost:8000/uploads/col2.jpeg','2022-04-05 21:45:41',0,0);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile` (
  `profileid` int unsigned NOT NULL AUTO_INCREMENT,
  `userid` int unsigned DEFAULT NULL,
  `pictureurl` varchar(255) NOT NULL,
  PRIMARY KEY (`profileid`),
  UNIQUE KEY `pictureurl` (`pictureurl`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userid` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'1234','1234'),(2,'yikegao','3333'),(3,'yoeri','1234');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-05 22:47:01
