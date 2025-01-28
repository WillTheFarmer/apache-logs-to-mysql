-- # Licensed under the Apache License, Version 2.0 (the "License");
-- # you may not use this file except in compliance with the License.
-- # You may obtain a copy of the License at
-- #
-- #     http://www.apache.org/licenses/LICENSE-2.0
-- #
-- # Unless required by applicable law or agreed to in writing, software
-- # distributed under the License is distributed on an "AS IS" BASIS,
-- # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- # See the License for the specific language governing permissions and
-- # limitations under the License.
-- #
-- # version 3.0.0 - 01/28/2025 - IP Geolocation integration, table & column renames, refinements - see changelog
-- #
-- # Copyright 2024 Will Raymond <farmfreshsoftware@gmail.com>
-- #
-- # CHANGELOG.md in repository - https://github.com/WillTheFarmer/apache-logs-to-mysql
-- #
-- file: apache_logs_schema.sql 
-- synopsis: Data definition language (DDL) for creating MySQL schema apache_logs for ApacheLogs2MySQL application
-- author: Will Raymond <farmfreshsoftware@gmail.com>

CREATE DATABASE  IF NOT EXISTS `apache_logs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `apache_logs`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: apache_logs
-- ------------------------------------------------------
-- Server version	9.1.0

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
-- Temporary view structure for view `access_client_list`
--

DROP TABLE IF EXISTS `access_client_list`;
/*!50001 DROP VIEW IF EXISTS `access_client_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_client_list` AS SELECT 
 1 AS `Access Log Client Name`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_cookie_list`
--

DROP TABLE IF EXISTS `access_cookie_list`;
/*!50001 DROP VIEW IF EXISTS `access_cookie_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_cookie_list` AS SELECT 
 1 AS `Access Log Cookie`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_importfile_list`
--

DROP TABLE IF EXISTS `access_importfile_list`;
/*!50001 DROP VIEW IF EXISTS `access_importfile_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_importfile_list` AS SELECT 
 1 AS `Access Log Import File`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `access_log`
--

DROP TABLE IF EXISTS `access_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `logged` datetime NOT NULL,
  `serverid` int DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
  `serverportid` int DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
  `clientid` int DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
  `clientportid` int DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
  `refererid` int DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
  `requestlogid` int DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
  `bytes_received` int NOT NULL,
  `bytes_sent` int NOT NULL,
  `bytes_transferred` int NOT NULL,
  `reqtime_milli` int NOT NULL,
  `reqtime_micro` int NOT NULL,
  `reqdelay_milli` int NOT NULL,
  `reqbytes` int NOT NULL,
  `reqstatusid` int DEFAULT NULL,
  `reqprotocolid` int DEFAULT NULL,
  `reqmethodid` int DEFAULT NULL,
  `requriid` int DEFAULT NULL,
  `reqqueryid` int DEFAULT NULL,
  `remoteuserid` int DEFAULT NULL,
  `remotelognameid` int DEFAULT NULL,
  `cookieid` int DEFAULT NULL,
  `useragentid` int DEFAULT NULL,
  `importfileid` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `F_access_reqstatus` (`reqstatusid`),
  KEY `F_access_reqprotocol` (`reqprotocolid`),
  KEY `F_access_reqmethod` (`reqmethodid`),
  KEY `F_access_requri` (`requriid`),
  KEY `F_access_reqquery` (`reqqueryid`),
  KEY `F_access_remotelogname` (`remotelognameid`),
  KEY `F_access_remoteuser` (`remoteuserid`),
  KEY `F_access_useragent` (`useragentid`),
  KEY `F_access_cookie` (`cookieid`),
  KEY `F_access_importfile` (`importfileid`),
  KEY `F_access_clientport` (`clientportid`),
  KEY `F_access_referer` (`refererid`),
  KEY `F_access_serverport` (`serverportid`),
  KEY `F_access_requestlogid` (`requestlogid`),
  KEY `I_access_log_logged` (`logged`),
  KEY `I_access_log_serverid_logged` (`serverid`,`logged`),
  KEY `I_access_log_serverid_serverportid` (`serverid`,`serverportid`),
  KEY `I_access_log_clientid_clientportid` (`clientid`,`clientportid`),
  CONSTRAINT `F_access_client` FOREIGN KEY (`clientid`) REFERENCES `log_client` (`id`),
  CONSTRAINT `F_access_clientport` FOREIGN KEY (`clientportid`) REFERENCES `log_clientport` (`id`),
  CONSTRAINT `F_access_cookie` FOREIGN KEY (`cookieid`) REFERENCES `access_log_cookie` (`id`),
  CONSTRAINT `F_access_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`),
  CONSTRAINT `F_access_referer` FOREIGN KEY (`refererid`) REFERENCES `log_referer` (`id`),
  CONSTRAINT `F_access_remotelogname` FOREIGN KEY (`remotelognameid`) REFERENCES `access_log_remotelogname` (`id`),
  CONSTRAINT `F_access_remoteuser` FOREIGN KEY (`remoteuserid`) REFERENCES `access_log_remoteuser` (`id`),
  CONSTRAINT `F_access_reqmethod` FOREIGN KEY (`reqmethodid`) REFERENCES `access_log_reqmethod` (`id`),
  CONSTRAINT `F_access_reqprotocol` FOREIGN KEY (`reqprotocolid`) REFERENCES `access_log_reqprotocol` (`id`),
  CONSTRAINT `F_access_reqquery` FOREIGN KEY (`reqqueryid`) REFERENCES `access_log_reqquery` (`id`),
  CONSTRAINT `F_access_reqstatus` FOREIGN KEY (`reqstatusid`) REFERENCES `access_log_reqstatus` (`id`),
  CONSTRAINT `F_access_requestlogid` FOREIGN KEY (`requestlogid`) REFERENCES `log_requestlogid` (`id`),
  CONSTRAINT `F_access_requri` FOREIGN KEY (`requriid`) REFERENCES `access_log_requri` (`id`),
  CONSTRAINT `F_access_server` FOREIGN KEY (`serverid`) REFERENCES `log_server` (`id`),
  CONSTRAINT `F_access_serverport` FOREIGN KEY (`serverportid`) REFERENCES `log_serverport` (`id`),
  CONSTRAINT `F_access_useragent` FOREIGN KEY (`useragentid`) REFERENCES `access_log_useragent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is core table for access logs and contains foreign keys to relate to log attribute tables.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log`
--

LOCK TABLES `access_log` WRITE;
/*!40000 ALTER TABLE `access_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_cookie`
--

DROP TABLE IF EXISTS `access_log_cookie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_cookie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(400) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_cookie` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_cookie`
--

LOCK TABLES `access_log_cookie` WRITE;
/*!40000 ALTER TABLE `access_log_cookie` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_cookie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_remotelogname`
--

DROP TABLE IF EXISTS `access_log_remotelogname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_remotelogname` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_remotelogname` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_remotelogname`
--

LOCK TABLES `access_log_remotelogname` WRITE;
/*!40000 ALTER TABLE `access_log_remotelogname` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_remotelogname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_remoteuser`
--

DROP TABLE IF EXISTS `access_log_remoteuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_remoteuser` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_remoteuser` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_remoteuser`
--

LOCK TABLES `access_log_remoteuser` WRITE;
/*!40000 ALTER TABLE `access_log_remoteuser` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_remoteuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_reqmethod`
--

DROP TABLE IF EXISTS `access_log_reqmethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_reqmethod` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_reqmethod` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_reqmethod`
--

LOCK TABLES `access_log_reqmethod` WRITE;
/*!40000 ALTER TABLE `access_log_reqmethod` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_reqmethod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_reqprotocol`
--

DROP TABLE IF EXISTS `access_log_reqprotocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_reqprotocol` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_reqprotocol` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_reqprotocol`
--

LOCK TABLES `access_log_reqprotocol` WRITE;
/*!40000 ALTER TABLE `access_log_reqprotocol` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_reqprotocol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_reqquery`
--

DROP TABLE IF EXISTS `access_log_reqquery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_reqquery` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(2000) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_reqquery`
--

LOCK TABLES `access_log_reqquery` WRITE;
/*!40000 ALTER TABLE `access_log_reqquery` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_reqquery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_reqstatus`
--

DROP TABLE IF EXISTS `access_log_reqstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_reqstatus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_reqstatus` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_reqstatus`
--

LOCK TABLES `access_log_reqstatus` WRITE;
/*!40000 ALTER TABLE `access_log_reqstatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_reqstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_requri`
--

DROP TABLE IF EXISTS `access_log_requri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_requri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(2000) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_requri`
--

LOCK TABLES `access_log_requri` WRITE;
/*!40000 ALTER TABLE `access_log_requri` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_requri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua`
--

DROP TABLE IF EXISTS `access_log_ua`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua`
--

LOCK TABLES `access_log_ua` WRITE;
/*!40000 ALTER TABLE `access_log_ua` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_browser`
--

DROP TABLE IF EXISTS `access_log_ua_browser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_browser` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_browser` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_browser`
--

LOCK TABLES `access_log_ua_browser` WRITE;
/*!40000 ALTER TABLE `access_log_ua_browser` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_browser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_browser_family`
--

DROP TABLE IF EXISTS `access_log_ua_browser_family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_browser_family` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_browser_family` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_browser_family`
--

LOCK TABLES `access_log_ua_browser_family` WRITE;
/*!40000 ALTER TABLE `access_log_ua_browser_family` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_browser_family` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_browser_version`
--

DROP TABLE IF EXISTS `access_log_ua_browser_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_browser_version` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_browser_version` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_browser_version`
--

LOCK TABLES `access_log_ua_browser_version` WRITE;
/*!40000 ALTER TABLE `access_log_ua_browser_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_browser_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_device`
--

DROP TABLE IF EXISTS `access_log_ua_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_device` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_device` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_device`
--

LOCK TABLES `access_log_ua_device` WRITE;
/*!40000 ALTER TABLE `access_log_ua_device` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_device_brand`
--

DROP TABLE IF EXISTS `access_log_ua_device_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_device_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_device_brand` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_device_brand`
--

LOCK TABLES `access_log_ua_device_brand` WRITE;
/*!40000 ALTER TABLE `access_log_ua_device_brand` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_device_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_device_family`
--

DROP TABLE IF EXISTS `access_log_ua_device_family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_device_family` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_device_family` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_device_family`
--

LOCK TABLES `access_log_ua_device_family` WRITE;
/*!40000 ALTER TABLE `access_log_ua_device_family` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_device_family` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_device_model`
--

DROP TABLE IF EXISTS `access_log_ua_device_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_device_model` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_device_model` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_device_model`
--

LOCK TABLES `access_log_ua_device_model` WRITE;
/*!40000 ALTER TABLE `access_log_ua_device_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_device_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_os`
--

DROP TABLE IF EXISTS `access_log_ua_os`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_os` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_os` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_os`
--

LOCK TABLES `access_log_ua_os` WRITE;
/*!40000 ALTER TABLE `access_log_ua_os` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_os` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_os_family`
--

DROP TABLE IF EXISTS `access_log_ua_os_family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_os_family` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_os_family` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_os_family`
--

LOCK TABLES `access_log_ua_os_family` WRITE;
/*!40000 ALTER TABLE `access_log_ua_os_family` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_os_family` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_ua_os_version`
--

DROP TABLE IF EXISTS `access_log_ua_os_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_ua_os_version` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_access_ua_os_version` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_ua_os_version`
--

LOCK TABLES `access_log_ua_os_version` WRITE;
/*!40000 ALTER TABLE `access_log_ua_os_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_ua_os_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_log_useragent`
--

DROP TABLE IF EXISTS `access_log_useragent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_useragent` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(2000) NOT NULL,
  `ua` varchar(300) DEFAULT NULL,
  `ua_browser` varchar(300) DEFAULT NULL,
  `ua_browser_family` varchar(300) DEFAULT NULL,
  `ua_browser_version` varchar(300) DEFAULT NULL,
  `ua_device` varchar(300) DEFAULT NULL,
  `ua_device_family` varchar(300) DEFAULT NULL,
  `ua_device_brand` varchar(300) DEFAULT NULL,
  `ua_device_model` varchar(300) DEFAULT NULL,
  `ua_os` varchar(300) DEFAULT NULL,
  `ua_os_family` varchar(300) DEFAULT NULL,
  `ua_os_version` varchar(300) DEFAULT NULL,
  `uaid` int DEFAULT NULL,
  `uabrowserid` int DEFAULT NULL,
  `uabrowserfamilyid` int DEFAULT NULL,
  `uabrowserversionid` int DEFAULT NULL,
  `uadeviceid` int DEFAULT NULL,
  `uadevicefamilyid` int DEFAULT NULL,
  `uadevicebrandid` int DEFAULT NULL,
  `uadevicemodelid` int DEFAULT NULL,
  `uaosid` int DEFAULT NULL,
  `uaosfamilyid` int DEFAULT NULL,
  `uaosversionid` int DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `F_useragent_ua` (`uaid`),
  KEY `F_useragent_ua_browser` (`uabrowserid`),
  KEY `F_useragent_ua_browser_family` (`uabrowserfamilyid`),
  KEY `F_useragent_ua_browser_version` (`uabrowserversionid`),
  KEY `F_useragent_ua_device` (`uadeviceid`),
  KEY `F_useragent_ua_device_brand` (`uadevicebrandid`),
  KEY `F_useragent_ua_device_family` (`uadevicefamilyid`),
  KEY `F_useragent_ua_device_model` (`uadevicemodelid`),
  KEY `F_useragent_ua_os` (`uaosid`),
  KEY `F_useragent_ua_os_family` (`uaosfamilyid`),
  KEY `F_useragent_ua_os_version` (`uaosversionid`),
  CONSTRAINT `F_useragent_ua` FOREIGN KEY (`uaid`) REFERENCES `access_log_ua` (`id`),
  CONSTRAINT `F_useragent_ua_browser` FOREIGN KEY (`uabrowserid`) REFERENCES `access_log_ua_browser` (`id`),
  CONSTRAINT `F_useragent_ua_browser_family` FOREIGN KEY (`uabrowserfamilyid`) REFERENCES `access_log_ua_browser_family` (`id`),
  CONSTRAINT `F_useragent_ua_browser_version` FOREIGN KEY (`uabrowserversionid`) REFERENCES `access_log_ua_browser_version` (`id`),
  CONSTRAINT `F_useragent_ua_device` FOREIGN KEY (`uadeviceid`) REFERENCES `access_log_ua_device` (`id`),
  CONSTRAINT `F_useragent_ua_device_brand` FOREIGN KEY (`uadevicebrandid`) REFERENCES `access_log_ua_device_brand` (`id`),
  CONSTRAINT `F_useragent_ua_device_family` FOREIGN KEY (`uadevicefamilyid`) REFERENCES `access_log_ua_device_family` (`id`),
  CONSTRAINT `F_useragent_ua_device_model` FOREIGN KEY (`uadevicemodelid`) REFERENCES `access_log_ua_device_model` (`id`),
  CONSTRAINT `F_useragent_ua_os` FOREIGN KEY (`uaosid`) REFERENCES `access_log_ua_os` (`id`),
  CONSTRAINT `F_useragent_ua_os_family` FOREIGN KEY (`uaosfamilyid`) REFERENCES `access_log_ua_os_family` (`id`),
  CONSTRAINT `F_useragent_ua_os_version` FOREIGN KEY (`uaosversionid`) REFERENCES `access_log_ua_os_version` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log_useragent`
--

LOCK TABLES `access_log_useragent` WRITE;
/*!40000 ALTER TABLE `access_log_useragent` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_log_useragent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `access_period_day_list`
--

DROP TABLE IF EXISTS `access_period_day_list`;
/*!50001 DROP VIEW IF EXISTS `access_period_day_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_period_day_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Day`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_period_hour_list`
--

DROP TABLE IF EXISTS `access_period_hour_list`;
/*!50001 DROP VIEW IF EXISTS `access_period_hour_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_period_hour_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Day`,
 1 AS `Hour`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_period_month_list`
--

DROP TABLE IF EXISTS `access_period_month_list`;
/*!50001 DROP VIEW IF EXISTS `access_period_month_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_period_month_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_period_week_list`
--

DROP TABLE IF EXISTS `access_period_week_list`;
/*!50001 DROP VIEW IF EXISTS `access_period_week_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_period_week_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Week`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_period_year_list`
--

DROP TABLE IF EXISTS `access_period_year_list`;
/*!50001 DROP VIEW IF EXISTS `access_period_year_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_period_year_list` AS SELECT 
 1 AS `Year`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_referer_list`
--

DROP TABLE IF EXISTS `access_referer_list`;
/*!50001 DROP VIEW IF EXISTS `access_referer_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_referer_list` AS SELECT 
 1 AS `Access Log Referer`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_remotelogname_list`
--

DROP TABLE IF EXISTS `access_remotelogname_list`;
/*!50001 DROP VIEW IF EXISTS `access_remotelogname_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_remotelogname_list` AS SELECT 
 1 AS `Access Log Remote Log Name`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_remoteuser_list`
--

DROP TABLE IF EXISTS `access_remoteuser_list`;
/*!50001 DROP VIEW IF EXISTS `access_remoteuser_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_remoteuser_list` AS SELECT 
 1 AS `Access Log Remote User`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_reqmethod_list`
--

DROP TABLE IF EXISTS `access_reqmethod_list`;
/*!50001 DROP VIEW IF EXISTS `access_reqmethod_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_reqmethod_list` AS SELECT 
 1 AS `Access Log Method`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_reqprotocol_list`
--

DROP TABLE IF EXISTS `access_reqprotocol_list`;
/*!50001 DROP VIEW IF EXISTS `access_reqprotocol_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_reqprotocol_list` AS SELECT 
 1 AS `Access Log Protocol`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_reqquery_list`
--

DROP TABLE IF EXISTS `access_reqquery_list`;
/*!50001 DROP VIEW IF EXISTS `access_reqquery_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_reqquery_list` AS SELECT 
 1 AS `Access Log Query String`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_reqstatus_list`
--

DROP TABLE IF EXISTS `access_reqstatus_list`;
/*!50001 DROP VIEW IF EXISTS `access_reqstatus_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_reqstatus_list` AS SELECT 
 1 AS `Access Log Status`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_requri_list`
--

DROP TABLE IF EXISTS `access_requri_list`;
/*!50001 DROP VIEW IF EXISTS `access_requri_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_requri_list` AS SELECT 
 1 AS `Access Log URI`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_server_list`
--

DROP TABLE IF EXISTS `access_server_list`;
/*!50001 DROP VIEW IF EXISTS `access_server_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_server_list` AS SELECT 
 1 AS `Access Log Server Name`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_server_serverport_list`
--

DROP TABLE IF EXISTS `access_server_serverport_list`;
/*!50001 DROP VIEW IF EXISTS `access_server_serverport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_server_serverport_list` AS SELECT 
 1 AS `Access Log Server Name`,
 1 AS `Server Port`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_serverport_list`
--

DROP TABLE IF EXISTS `access_serverport_list`;
/*!50001 DROP VIEW IF EXISTS `access_serverport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_serverport_list` AS SELECT 
 1 AS `Access Log Server Port`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_browser_family_list`
--

DROP TABLE IF EXISTS `access_ua_browser_family_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_browser_family_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_browser_family_list` AS SELECT 
 1 AS `Browser Family`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_browser_list`
--

DROP TABLE IF EXISTS `access_ua_browser_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_browser_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_browser_list` AS SELECT 
 1 AS `Browser`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_browser_version_list`
--

DROP TABLE IF EXISTS `access_ua_browser_version_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_browser_version_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_browser_version_list` AS SELECT 
 1 AS `Browser Version`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_device_brand_list`
--

DROP TABLE IF EXISTS `access_ua_device_brand_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_device_brand_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_device_brand_list` AS SELECT 
 1 AS `Device Brand`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_device_family_list`
--

DROP TABLE IF EXISTS `access_ua_device_family_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_device_family_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_device_family_list` AS SELECT 
 1 AS `Device Family`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_device_list`
--

DROP TABLE IF EXISTS `access_ua_device_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_device_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_device_list` AS SELECT 
 1 AS `Device`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_device_model_list`
--

DROP TABLE IF EXISTS `access_ua_device_model_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_device_model_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_device_model_list` AS SELECT 
 1 AS `Device Model`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_list`
--

DROP TABLE IF EXISTS `access_ua_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_list` AS SELECT 
 1 AS `Access Log User Agent`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_os_family_list`
--

DROP TABLE IF EXISTS `access_ua_os_family_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_os_family_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_os_family_list` AS SELECT 
 1 AS `Operating System Family`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_os_list`
--

DROP TABLE IF EXISTS `access_ua_os_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_os_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_os_list` AS SELECT 
 1 AS `Operating System`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_ua_os_version_list`
--

DROP TABLE IF EXISTS `access_ua_os_version_list`;
/*!50001 DROP VIEW IF EXISTS `access_ua_os_version_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_ua_os_version_list` AS SELECT 
 1 AS `Operating System Version`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_browser_family_list`
--

DROP TABLE IF EXISTS `access_useragent_browser_family_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_browser_family_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_browser_family_list` AS SELECT 
 1 AS `Browser Family`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_browser_list`
--

DROP TABLE IF EXISTS `access_useragent_browser_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_browser_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_browser_list` AS SELECT 
 1 AS `Browser`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_browser_version_list`
--

DROP TABLE IF EXISTS `access_useragent_browser_version_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_browser_version_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_browser_version_list` AS SELECT 
 1 AS `Browser Version`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_device_brand_list`
--

DROP TABLE IF EXISTS `access_useragent_device_brand_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_device_brand_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_device_brand_list` AS SELECT 
 1 AS `Device Brand`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_device_family_list`
--

DROP TABLE IF EXISTS `access_useragent_device_family_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_device_family_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_device_family_list` AS SELECT 
 1 AS `Device Family`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_device_list`
--

DROP TABLE IF EXISTS `access_useragent_device_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_device_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_device_list` AS SELECT 
 1 AS `Device`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_device_model_list`
--

DROP TABLE IF EXISTS `access_useragent_device_model_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_device_model_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_device_model_list` AS SELECT 
 1 AS `Device Model`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_list`
--

DROP TABLE IF EXISTS `access_useragent_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_list` AS SELECT 
 1 AS `Access Log UserAgent`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_os_browser_device_list`
--

DROP TABLE IF EXISTS `access_useragent_os_browser_device_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_os_browser_device_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_os_browser_device_list` AS SELECT 
 1 AS `Operating System`,
 1 AS `Browser`,
 1 AS `Device`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_os_family_list`
--

DROP TABLE IF EXISTS `access_useragent_os_family_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_os_family_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_os_family_list` AS SELECT 
 1 AS `Operating System Family`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_os_list`
--

DROP TABLE IF EXISTS `access_useragent_os_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_os_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_os_list` AS SELECT 
 1 AS `Operating System`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_os_version_list`
--

DROP TABLE IF EXISTS `access_useragent_os_version_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_os_version_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_os_version_list` AS SELECT 
 1 AS `Operating System Version`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `access_useragent_pretty_list`
--

DROP TABLE IF EXISTS `access_useragent_pretty_list`;
/*!50001 DROP VIEW IF EXISTS `access_useragent_pretty_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_useragent_pretty_list` AS SELECT 
 1 AS `Access Log Pretty User Agent`,
 1 AS `Log Count`,
 1 AS `HTTP Bytes`,
 1 AS `Bytes Sent`,
 1 AS `Bytes Received`,
 1 AS `Bytes Transferred`,
 1 AS `Max Request Time`,
 1 AS `Min Request Time`,
 1 AS `Max Delay Time`,
 1 AS `Min Delay Time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_apachecode_list`
--

DROP TABLE IF EXISTS `error_apachecode_list`;
/*!50001 DROP VIEW IF EXISTS `error_apachecode_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_apachecode_list` AS SELECT 
 1 AS `Error Log Apache Code`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_apachemessage_list`
--

DROP TABLE IF EXISTS `error_apachemessage_list`;
/*!50001 DROP VIEW IF EXISTS `error_apachemessage_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_apachemessage_list` AS SELECT 
 1 AS `Error Log Apache Message`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_client_clientport_list`
--

DROP TABLE IF EXISTS `error_client_clientport_list`;
/*!50001 DROP VIEW IF EXISTS `error_client_clientport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_client_clientport_list` AS SELECT 
 1 AS `Error Log Server Name`,
 1 AS `Server Port`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_client_list`
--

DROP TABLE IF EXISTS `error_client_list`;
/*!50001 DROP VIEW IF EXISTS `error_client_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_client_list` AS SELECT 
 1 AS `Error Log Client Name`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_client_port_list`
--

DROP TABLE IF EXISTS `error_client_port_list`;
/*!50001 DROP VIEW IF EXISTS `error_client_port_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_client_port_list` AS SELECT 
 1 AS `Error Log Client Port`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_importfile_list`
--

DROP TABLE IF EXISTS `error_importfile_list`;
/*!50001 DROP VIEW IF EXISTS `error_importfile_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_importfile_list` AS SELECT 
 1 AS `Error Log Import File`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_level_list`
--

DROP TABLE IF EXISTS `error_level_list`;
/*!50001 DROP VIEW IF EXISTS `error_level_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_level_list` AS SELECT 
 1 AS `Error Log Level`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `error_log`
--

DROP TABLE IF EXISTS `error_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `logged` datetime NOT NULL,
  `serverid` int DEFAULT NULL COMMENT '%v	The canonical Server of the server serving the request. Access & Error shared normalization table - log_server',
  `serverportid` int DEFAULT NULL COMMENT '%p	The canonical port of the server serving the request. Access & Error shared normalization table - log_serverport',
  `clientid` int DEFAULT NULL COMMENT 'This is %h - Remote hostname (default) for Access Log or %a - Client IP address and port of the request for Error and Access logs.',
  `clientportid` int DEFAULT NULL COMMENT 'a% - Client IP address and port of the request - Default for Error logs and can be used in Access Log LogFormat. Port value is derived from it.',
  `refererid` int DEFAULT NULL COMMENT '%{Referer}i - Access & Error shared normalization table - log_referer',
  `requestlogid` int DEFAULT NULL COMMENT '%L	Log ID of the request - Access & Error shared normalization table - log_requestlogid',
  `loglevelid` int DEFAULT NULL,
  `moduleid` int DEFAULT NULL,
  `processid` int DEFAULT NULL,
  `threadid` int DEFAULT NULL,
  `apachecodeid` int DEFAULT NULL,
  `apachemessageid` int DEFAULT NULL,
  `systemcodeid` int DEFAULT NULL,
  `systemmessageid` int DEFAULT NULL,
  `logmessageid` int DEFAULT NULL,
  `importfileid` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `F_error_level` (`loglevelid`),
  KEY `F_error_module` (`moduleid`),
  KEY `F_error_threadid` (`threadid`),
  KEY `F_error_apachecode` (`apachecodeid`),
  KEY `F_error_apachemessage` (`apachemessageid`),
  KEY `F_error_systemcode` (`systemcodeid`),
  KEY `F_error_systemmessage` (`systemmessageid`),
  KEY `F_error_message` (`logmessageid`),
  KEY `F_error_importfile` (`importfileid`),
  KEY `F_error_clientport` (`clientportid`),
  KEY `F_error_referer` (`refererid`),
  KEY `F_error_serverport` (`serverportid`),
  KEY `F_error_requestlogid` (`requestlogid`),
  KEY `I_error_log_logged` (`logged`),
  KEY `I_error_log_serverid_logged` (`serverid`,`logged`),
  KEY `I_error_log_serverid_serverportid` (`serverid`,`serverportid`),
  KEY `I_error_log_clientid_clientportid` (`clientid`,`clientportid`),
  KEY `I_error_log_processid_threadid` (`processid`,`threadid`),
  CONSTRAINT `F_error_apachecode` FOREIGN KEY (`apachecodeid`) REFERENCES `error_log_apachecode` (`id`),
  CONSTRAINT `F_error_apachemessage` FOREIGN KEY (`apachemessageid`) REFERENCES `error_log_apachemessage` (`id`),
  CONSTRAINT `F_error_client` FOREIGN KEY (`clientid`) REFERENCES `log_client` (`id`),
  CONSTRAINT `F_error_clientport` FOREIGN KEY (`clientportid`) REFERENCES `log_clientport` (`id`),
  CONSTRAINT `F_error_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`),
  CONSTRAINT `F_error_level` FOREIGN KEY (`loglevelid`) REFERENCES `error_log_level` (`id`),
  CONSTRAINT `F_error_message` FOREIGN KEY (`logmessageid`) REFERENCES `error_log_message` (`id`),
  CONSTRAINT `F_error_module` FOREIGN KEY (`moduleid`) REFERENCES `error_log_module` (`id`),
  CONSTRAINT `F_error_processid` FOREIGN KEY (`processid`) REFERENCES `error_log_processid` (`id`),
  CONSTRAINT `F_error_referer` FOREIGN KEY (`refererid`) REFERENCES `log_referer` (`id`),
  CONSTRAINT `F_error_requestlogid` FOREIGN KEY (`requestlogid`) REFERENCES `log_requestlogid` (`id`),
  CONSTRAINT `F_error_server` FOREIGN KEY (`serverid`) REFERENCES `log_server` (`id`),
  CONSTRAINT `F_error_serverport` FOREIGN KEY (`serverportid`) REFERENCES `log_serverport` (`id`),
  CONSTRAINT `F_error_systemcode` FOREIGN KEY (`systemcodeid`) REFERENCES `error_log_systemcode` (`id`),
  CONSTRAINT `F_error_systemmessage` FOREIGN KEY (`systemmessageid`) REFERENCES `error_log_systemmessage` (`id`),
  CONSTRAINT `F_error_threadid` FOREIGN KEY (`threadid`) REFERENCES `error_log_threadid` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log`
--

LOCK TABLES `error_log` WRITE;
/*!40000 ALTER TABLE `error_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_apachecode`
--

DROP TABLE IF EXISTS `error_log_apachecode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_apachecode` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_apachecode` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_apachecode`
--

LOCK TABLES `error_log_apachecode` WRITE;
/*!40000 ALTER TABLE `error_log_apachecode` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_apachecode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_apachemessage`
--

DROP TABLE IF EXISTS `error_log_apachemessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_apachemessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_apachemessage` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_apachemessage`
--

LOCK TABLES `error_log_apachemessage` WRITE;
/*!40000 ALTER TABLE `error_log_apachemessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_apachemessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_level`
--

DROP TABLE IF EXISTS `error_log_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_level` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_level`
--

LOCK TABLES `error_log_level` WRITE;
/*!40000 ALTER TABLE `error_log_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_message`
--

DROP TABLE IF EXISTS `error_log_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_message` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_message` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_message`
--

LOCK TABLES `error_log_message` WRITE;
/*!40000 ALTER TABLE `error_log_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_module`
--

DROP TABLE IF EXISTS `error_log_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_module` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_module` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_module`
--

LOCK TABLES `error_log_module` WRITE;
/*!40000 ALTER TABLE `error_log_module` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_processid`
--

DROP TABLE IF EXISTS `error_log_processid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_processid` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_processid` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_processid`
--

LOCK TABLES `error_log_processid` WRITE;
/*!40000 ALTER TABLE `error_log_processid` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_processid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_systemcode`
--

DROP TABLE IF EXISTS `error_log_systemcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_systemcode` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_systemcode` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_systemcode`
--

LOCK TABLES `error_log_systemcode` WRITE;
/*!40000 ALTER TABLE `error_log_systemcode` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_systemcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_systemmessage`
--

DROP TABLE IF EXISTS `error_log_systemmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_systemmessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_systemmessage` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_systemmessage`
--

LOCK TABLES `error_log_systemmessage` WRITE;
/*!40000 ALTER TABLE `error_log_systemmessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_systemmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_log_threadid`
--

DROP TABLE IF EXISTS `error_log_threadid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_threadid` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_error_threadid` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_log_threadid`
--

LOCK TABLES `error_log_threadid` WRITE;
/*!40000 ALTER TABLE `error_log_threadid` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_log_threadid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `error_message_list`
--

DROP TABLE IF EXISTS `error_message_list`;
/*!50001 DROP VIEW IF EXISTS `error_message_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_message_list` AS SELECT 
 1 AS `Error Log Message`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_module_list`
--

DROP TABLE IF EXISTS `error_module_list`;
/*!50001 DROP VIEW IF EXISTS `error_module_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_module_list` AS SELECT 
 1 AS `Error Log Module`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_period_day_list`
--

DROP TABLE IF EXISTS `error_period_day_list`;
/*!50001 DROP VIEW IF EXISTS `error_period_day_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_period_day_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Day`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_period_hour_list`
--

DROP TABLE IF EXISTS `error_period_hour_list`;
/*!50001 DROP VIEW IF EXISTS `error_period_hour_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_period_hour_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Day`,
 1 AS `Hour`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_period_month_list`
--

DROP TABLE IF EXISTS `error_period_month_list`;
/*!50001 DROP VIEW IF EXISTS `error_period_month_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_period_month_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_period_week_list`
--

DROP TABLE IF EXISTS `error_period_week_list`;
/*!50001 DROP VIEW IF EXISTS `error_period_week_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_period_week_list` AS SELECT 
 1 AS `Year`,
 1 AS `Month`,
 1 AS `Week`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_period_year_list`
--

DROP TABLE IF EXISTS `error_period_year_list`;
/*!50001 DROP VIEW IF EXISTS `error_period_year_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_period_year_list` AS SELECT 
 1 AS `Year`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_processid_list`
--

DROP TABLE IF EXISTS `error_processid_list`;
/*!50001 DROP VIEW IF EXISTS `error_processid_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_processid_list` AS SELECT 
 1 AS `Error Log ProcessID`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_processid_threadid_list`
--

DROP TABLE IF EXISTS `error_processid_threadid_list`;
/*!50001 DROP VIEW IF EXISTS `error_processid_threadid_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_processid_threadid_list` AS SELECT 
 1 AS `ProcessID`,
 1 AS `ThreadID`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_referer_list`
--

DROP TABLE IF EXISTS `error_referer_list`;
/*!50001 DROP VIEW IF EXISTS `error_referer_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_referer_list` AS SELECT 
 1 AS `Error Log Referer`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_server_list`
--

DROP TABLE IF EXISTS `error_server_list`;
/*!50001 DROP VIEW IF EXISTS `error_server_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_server_list` AS SELECT 
 1 AS `Error Log Server Name`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_server_serverport_list`
--

DROP TABLE IF EXISTS `error_server_serverport_list`;
/*!50001 DROP VIEW IF EXISTS `error_server_serverport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_server_serverport_list` AS SELECT 
 1 AS `Error Log Server Name`,
 1 AS `Server Port`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_serverport_list`
--

DROP TABLE IF EXISTS `error_serverport_list`;
/*!50001 DROP VIEW IF EXISTS `error_serverport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_serverport_list` AS SELECT 
 1 AS `Error Log Server Port`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_systemcode_list`
--

DROP TABLE IF EXISTS `error_systemcode_list`;
/*!50001 DROP VIEW IF EXISTS `error_systemcode_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_systemcode_list` AS SELECT 
 1 AS `Error Log System Code`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_systemmessage_list`
--

DROP TABLE IF EXISTS `error_systemmessage_list`;
/*!50001 DROP VIEW IF EXISTS `error_systemmessage_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_systemmessage_list` AS SELECT 
 1 AS `Error Log System Message`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `error_threadid_list`
--

DROP TABLE IF EXISTS `error_threadid_list`;
/*!50001 DROP VIEW IF EXISTS `error_threadid_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_threadid_list` AS SELECT 
 1 AS `Error Log ThreadID`,
 1 AS `Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `import_client`
--

DROP TABLE IF EXISTS `import_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importdeviceid` int NOT NULL,
  `ipaddress` varchar(50) NOT NULL,
  `login` varchar(200) NOT NULL,
  `expandUser` varchar(200) NOT NULL,
  `platformRelease` varchar(100) NOT NULL,
  `platformVersion` varchar(175) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_import_client` (`importdeviceid`,`ipaddress`,`login`,`expandUser`,`platformRelease`,`platformVersion`),
  CONSTRAINT `F_importclient_importdevice` FOREIGN KEY (`importdeviceid`) REFERENCES `import_device` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table tracks network, OS release, logon and IP address information. It is important to know who is loading logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_client`
--

LOCK TABLES `import_client` WRITE;
/*!40000 ALTER TABLE `import_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_device`
--

DROP TABLE IF EXISTS `import_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_device` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deviceid` varchar(150) NOT NULL,
  `platformNode` varchar(200) NOT NULL,
  `platformSystem` varchar(100) NOT NULL,
  `platformMachine` varchar(100) NOT NULL,
  `platformProcessor` varchar(200) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_import_device` (`deviceid`,`platformNode`,`platformSystem`,`platformMachine`,`platformProcessor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table tracks unique Windows, Linux and Mac devices loading logs to server application.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_device`
--

LOCK TABLES `import_device` WRITE;
/*!40000 ALTER TABLE `import_device` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_error`
--

DROP TABLE IF EXISTS `import_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_error` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importloadid` int DEFAULT NULL,
  `importprocessid` int DEFAULT NULL,
  `module` varchar(300) DEFAULT NULL,
  `mysql_errno` smallint unsigned DEFAULT NULL,
  `message_text` varchar(1000) DEFAULT NULL,
  `returned_sqlstate` varchar(250) DEFAULT NULL,
  `schema_name` varchar(64) DEFAULT NULL,
  `catalog_name` varchar(64) DEFAULT NULL,
  `comments` varchar(350) DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Application Error log. Any errors that occur in MySQL processes will be here. This is a MyISAM engine table to avoid TRANSACTION ROLLBACKS. Always look in this table for problems!';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_error`
--

LOCK TABLES `import_error` WRITE;
/*!40000 ALTER TABLE `import_error` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_error` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_file`
--

DROP TABLE IF EXISTS `import_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_file` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `importdeviceid` int NOT NULL,
  `importloadid` int NOT NULL,
  `parseprocessid` int DEFAULT NULL,
  `importprocessid` int DEFAULT NULL,
  `filesize` bigint NOT NULL,
  `filecreated` datetime NOT NULL,
  `filemodified` datetime NOT NULL,
  `server_name` varchar(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be populated before import process.',
  `server_port` int DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be populated before import process.',
  `importformatid` int NOT NULL COMMENT 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost',
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_import_file` (`importdeviceid`,`name`),
  KEY `F_importfile_importformat` (`importformatid`),
  KEY `F_importfile_importload` (`importloadid`),
  KEY `F_importfile_parseprocess` (`parseprocessid`),
  KEY `F_importfile_importprocess` (`importprocessid`),
  CONSTRAINT `F_importfile_importdevice` FOREIGN KEY (`importdeviceid`) REFERENCES `import_device` (`id`),
  CONSTRAINT `F_importfile_importformat` FOREIGN KEY (`importformatid`) REFERENCES `import_format` (`id`),
  CONSTRAINT `F_importfile_importload` FOREIGN KEY (`importloadid`) REFERENCES `import_load` (`id`),
  CONSTRAINT `F_importfile_importprocess` FOREIGN KEY (`importprocessid`) REFERENCES `import_process` (`id`),
  CONSTRAINT `F_importfile_parseprocess` FOREIGN KEY (`parseprocessid`) REFERENCES `import_process` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table contains all access and error log files loaded and processed. Created, modified and size of each file at time of loading is captured for auditability. Each file processed by Server Application must exist in this table.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_file`
--

LOCK TABLES `import_file` WRITE;
/*!40000 ALTER TABLE `import_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_format`
--

DROP TABLE IF EXISTS `import_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_format` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `comments` varchar(100) DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_import_format` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table contains import file formats imported by application. These values are inserted in schema DDL script. This table is only added for reporting purposes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_format`
--

LOCK TABLES `import_format` WRITE;
/*!40000 ALTER TABLE `import_format` DISABLE KEYS */;
INSERT INTO `import_format` VALUES (1,'common',NULL,'2025-01-27 14:53:52'),(2,'combined',NULL,'2025-01-27 14:53:52'),(3,'vhost',NULL,'2025-01-27 14:53:52'),(4,'csc2mysql',NULL,'2025-01-27 14:53:52'),(5,'error_default',NULL,'2025-01-27 14:53:52'),(6,'error_vhost',NULL,'2025-01-27 14:53:52');
/*!40000 ALTER TABLE `import_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_load`
--

DROP TABLE IF EXISTS `import_load`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_load` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importclientid` int NOT NULL,
  `errorFilesFound` int DEFAULT NULL,
  `errorFilesLoaded` int DEFAULT NULL,
  `errorParseCalled` tinyint DEFAULT NULL,
  `errorImportCalled` tinyint DEFAULT NULL,
  `combinedFilesFound` int DEFAULT NULL,
  `combinedFilesLoaded` int DEFAULT NULL,
  `combinedParseCalled` tinyint DEFAULT NULL,
  `combinedImportCalled` tinyint DEFAULT NULL,
  `vhostFilesFound` int DEFAULT NULL,
  `vhostFilesLoaded` int DEFAULT NULL,
  `vhostParseCalled` tinyint DEFAULT NULL,
  `vhostImportCalled` tinyint DEFAULT NULL,
  `csv2mysqlFilesFound` int DEFAULT NULL,
  `csv2mysqlFilesLoaded` int DEFAULT NULL,
  `csv2mysqlParseCalled` tinyint DEFAULT NULL,
  `csv2mysqlImportCalled` tinyint DEFAULT NULL,
  `userAgentRecordsParsed` int DEFAULT NULL,
  `userAgentNormalizeCalled` tinyint DEFAULT NULL,
  `ipAddressRecordsParsed` int DEFAULT NULL,
  `ipAddressNormalizeCalled` tinyint DEFAULT NULL,
  `errorOccurred` tinyint DEFAULT NULL,
  `processSeconds` int DEFAULT NULL,
  `started` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed` datetime DEFAULT NULL,
  `comments` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `F_importload_importclient` (`importclientid`),
  CONSTRAINT `F_importload_importclient` FOREIGN KEY (`importclientid`) REFERENCES `import_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table has record for every time the Python processLogs is executed. The has totals for each type and file formats were imported.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_load`
--

LOCK TABLES `import_load` WRITE;
/*!40000 ALTER TABLE `import_load` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_load` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_process`
--

DROP TABLE IF EXISTS `import_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_process` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importserverid` int NOT NULL,
  `importloadid` int DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `records` int DEFAULT NULL,
  `files` int DEFAULT NULL,
  `loads` int DEFAULT NULL,
  `errorOccurred` tinyint DEFAULT NULL,
  `processSeconds` int DEFAULT NULL,
  `started` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed` datetime DEFAULT NULL,
  `comments` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `F_importprocess_importserver` (`importserverid`),
  CONSTRAINT `F_importprocess_importserver` FOREIGN KEY (`importserverid`) REFERENCES `import_server` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table has record for every MySQL Stored Procedure import execution. If completed column is NULL the process failed. Look in import_error table for error details.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_process`
--

LOCK TABLES `import_process` WRITE;
/*!40000 ALTER TABLE `import_process` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_server`
--

DROP TABLE IF EXISTS `import_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_server` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dbuser` varchar(255) NOT NULL,
  `dbhost` varchar(255) NOT NULL,
  `dbversion` varchar(55) NOT NULL,
  `dbsystem` varchar(55) NOT NULL,
  `dbmachine` varchar(55) NOT NULL,
  `serveruuid` varchar(75) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_import_server` (`dbuser`,`dbhost`,`dbversion`,`dbsystem`,`dbmachine`,`serveruuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table for keeping track of log processing servers and login information.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_server`
--

LOCK TABLES `import_server` WRITE;
/*!40000 ALTER TABLE `import_server` DISABLE KEYS */;
/*!40000 ALTER TABLE `import_server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `load_access_combined`
--

DROP TABLE IF EXISTS `load_access_combined`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `load_access_combined` (
  `remote_host` varchar(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
  `remote_logname` varchar(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
  `remote_user` varchar(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
  `log_time_a` varchar(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
  `log_time_b` varchar(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
  `first_line_request` varchar(4000) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol',
  `req_status` int DEFAULT NULL,
  `req_bytes` int DEFAULT NULL,
  `log_referer` varchar(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
  `log_useragent` varchar(2000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
  `load_error` varchar(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
  `log_time` varchar(28) DEFAULT NULL,
  `req_protocol` varchar(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_method` varchar(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_uri` varchar(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
  `req_query` varchar(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
  `server_name` varchar(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
  `server_port` int DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `process_status` int NOT NULL DEFAULT '0' COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `F_load_access_combined_importfile` (`importfileid`),
  KEY `I_load_access_combined_process` (`process_status`),
  CONSTRAINT `F_load_access_combined_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Used for LOAD DATA command for LogFormat combined and common to bring text files into MySQL and start the process.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `load_access_combined`
--

LOCK TABLES `load_access_combined` WRITE;
/*!40000 ALTER TABLE `load_access_combined` DISABLE KEYS */;
/*!40000 ALTER TABLE `load_access_combined` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `load_access_csv2mysql`
--

DROP TABLE IF EXISTS `load_access_csv2mysql`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `load_access_csv2mysql` (
  `server_name` varchar(253) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters.',
  `server_port` int DEFAULT NULL,
  `remote_host` varchar(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
  `remote_logname` varchar(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
  `remote_user` varchar(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
  `log_time` varchar(28) DEFAULT NULL,
  `bytes_received` int DEFAULT NULL,
  `bytes_sent` int DEFAULT NULL,
  `bytes_transferred` int DEFAULT NULL,
  `reqtime_milli` int DEFAULT NULL,
  `reqtime_micro` int DEFAULT NULL,
  `reqdelay_milli` int DEFAULT NULL,
  `req_bytes` int DEFAULT NULL,
  `req_status` int DEFAULT NULL,
  `req_protocol` varchar(30) DEFAULT NULL,
  `req_method` varchar(50) DEFAULT NULL,
  `req_uri` varchar(2000) DEFAULT NULL COMMENT 'URLs under 2000 characters work in any combination of client and server software and search engines.',
  `req_query` varchar(2000) DEFAULT NULL COMMENT 'URLs under 2000 characters work in any combination of client and server software and search engines.',
  `log_referer` varchar(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
  `log_useragent` varchar(2000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
  `log_cookie` varchar(400) DEFAULT NULL COMMENT 'Use to store any Cookie VARNAME. ie - session ID in application cookie to relate with login tables on server.',
  `request_log_id` varchar(50) DEFAULT NULL COMMENT 'The request log ID from the error log (or - if nothing has been logged to the error log for this request). Look for the matching error log line to see what request caused what error.',
  `load_error` varchar(10) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `process_status` int NOT NULL DEFAULT '0' COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `F_load_access_csv2mysql_importfile` (`importfileid`),
  KEY `I_load_access_csv2mysql_process` (`process_status`),
  CONSTRAINT `F_load_access_csv2mysql_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Used for LOAD DATA command for LogFormat csv2mysql to bring text files into MySQL and start the process.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `load_access_csv2mysql`
--

LOCK TABLES `load_access_csv2mysql` WRITE;
/*!40000 ALTER TABLE `load_access_csv2mysql` DISABLE KEYS */;
/*!40000 ALTER TABLE `load_access_csv2mysql` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `load_access_vhost`
--

DROP TABLE IF EXISTS `load_access_vhost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `load_access_vhost` (
  `log_server` varchar(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters. plus : plus 6 for port',
  `remote_host` varchar(300) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name. Renamed as client and clientport in normalization to share with Error Logs',
  `remote_logname` varchar(150) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
  `remote_user` varchar(150) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
  `log_time_a` varchar(21) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
  `log_time_b` varchar(6) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
  `first_line_request` varchar(4000) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_query, req_protocol',
  `req_status` int DEFAULT NULL,
  `req_bytes` int DEFAULT NULL,
  `log_referer` varchar(750) DEFAULT NULL COMMENT '1000 characters should be more than enough for domain.',
  `log_useragent` varchar(2000) DEFAULT NULL COMMENT 'No strict size limit of User-Agent string is defined by official standards or specifications. 2 years of production logs found useragents longer than 1000 are hack attempts.',
  `load_error` varchar(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
  `log_time` varchar(28) DEFAULT NULL,
  `server_name` varchar(253) DEFAULT NULL COMMENT '253 characters is the maximum length of full domain name, including dots: e.g. www.example.com = 15 characters.',
  `server_port` int DEFAULT NULL,
  `req_protocol` varchar(30) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_method` varchar(50) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_uri` varchar(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
  `req_query` varchar(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import. URLs under 2000 characters work in any combination of client and server software and search engines.',
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `process_status` int NOT NULL DEFAULT '0' COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `F_load_access_combined_vhost_importfile` (`importfileid`),
  KEY `I_load_access_vhost_process` (`process_status`),
  CONSTRAINT `F_load_access_combined_vhost_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Used for LOAD DATA command for LogFormat vhost to bring text files into MySQL and start the process.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `load_access_vhost`
--

LOCK TABLES `load_access_vhost` WRITE;
/*!40000 ALTER TABLE `load_access_vhost` DISABLE KEYS */;
/*!40000 ALTER TABLE `load_access_vhost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `load_error_default`
--

DROP TABLE IF EXISTS `load_error_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `load_error_default` (
  `log_time` varchar(50) DEFAULT NULL,
  `log_mod_level` varchar(200) DEFAULT NULL,
  `log_processid_threadid` varchar(200) DEFAULT NULL,
  `log_parse1` varchar(2500) DEFAULT NULL,
  `log_parse2` varchar(2500) DEFAULT NULL,
  `log_message_nocode` varchar(1000) DEFAULT NULL,
  `load_error` varchar(50) DEFAULT NULL COMMENT 'This column should always be NULL. Added to catch lines larger than designed for.',
  `logtime` datetime DEFAULT NULL,
  `loglevel` varchar(100) DEFAULT NULL,
  `module` varchar(200) DEFAULT NULL,
  `processid` varchar(100) DEFAULT NULL,
  `threadid` varchar(100) DEFAULT NULL,
  `apachecode` varchar(200) DEFAULT NULL,
  `apachemessage` varchar(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
  `systemcode` varchar(200) DEFAULT NULL,
  `systemmessage` varchar(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
  `logmessage` varchar(810) DEFAULT NULL COMMENT '500 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
  `referer` varchar(1060) DEFAULT NULL COMMENT '750 is normalized table column size + 310 - 253:server_name, 50:request_log_id, 4:commas-spaces to be removed in process_error_parse',
  `client_name` varchar(253) DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP (address) and port of the request.',
  `client_port` int DEFAULT NULL COMMENT 'Column to normalize Access & Error attributes with different names. From Error Log Format %a - Client IP address and (port) of the request.',
  `server_name` varchar(253) DEFAULT NULL COMMENT 'Error logs. Added to populate Server for multiple domains import. Must be poulated before import process.',
  `server_port` int DEFAULT NULL COMMENT 'Error logs. Added to populate ServerPort for multiple domains import. Must be poulated before import process.',
  `request_log_id` varchar(50) DEFAULT NULL COMMENT 'Log ID of the request',
  `importfileid` int DEFAULT NULL COMMENT 'FOREIGN KEY used in import process to indicate file record extracted from',
  `process_status` int NOT NULL DEFAULT '0' COMMENT 'used in parse and import processes to indicate record processed - 1=parsed, 2=imported',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `F_load_error_default_importfile` (`importfileid`),
  KEY `I_load_error_default_process` (`process_status`),
  CONSTRAINT `F_load_error_default_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table used for LOAD DATA command to bring text files into MySQL and start the process.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `load_error_default`
--

LOCK TABLES `load_error_default` WRITE;
/*!40000 ALTER TABLE `load_error_default` DISABLE KEYS */;
/*!40000 ALTER TABLE `load_error_default` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_client`
--

DROP TABLE IF EXISTS `log_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(253) NOT NULL,
  `country_code` varchar(20) DEFAULT NULL,
  `country` varchar(150) DEFAULT NULL,
  `subdivision` varchar(250) DEFAULT NULL,
  `city` varchar(250) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `organization` varchar(500) DEFAULT NULL,
  `network` varchar(100) DEFAULT NULL,
  `countryid` int DEFAULT NULL,
  `subdivisionid` int DEFAULT NULL,
  `cityid` int DEFAULT NULL,
  `coordinateid` int DEFAULT NULL,
  `organizationid` int DEFAULT NULL,
  `networkid` int DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client` (`name`),
  KEY `F_log_client_city` (`cityid`),
  KEY `F_log_client_coordinate` (`coordinateid`),
  KEY `F_log_client_country` (`countryid`),
  KEY `F_log_client_network` (`networkid`),
  KEY `F_log_client_organization` (`organizationid`),
  KEY `F_log_client_subdivision` (`subdivisionid`),
  CONSTRAINT `F_log_client_city` FOREIGN KEY (`cityid`) REFERENCES `log_client_city` (`id`),
  CONSTRAINT `F_log_client_coordinate` FOREIGN KEY (`coordinateid`) REFERENCES `log_client_coordinate` (`id`),
  CONSTRAINT `F_log_client_country` FOREIGN KEY (`countryid`) REFERENCES `log_client_country` (`id`),
  CONSTRAINT `F_log_client_network` FOREIGN KEY (`networkid`) REFERENCES `log_client_network` (`id`),
  CONSTRAINT `F_log_client_organization` FOREIGN KEY (`organizationid`) REFERENCES `log_client_organization` (`id`),
  CONSTRAINT `F_log_client_subdivision` FOREIGN KEY (`subdivisionid`) REFERENCES `log_client_subdivision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client`
--

LOCK TABLES `log_client` WRITE;
/*!40000 ALTER TABLE `log_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_client_city`
--

DROP TABLE IF EXISTS `log_client_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client_city` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client_city` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client_city`
--

LOCK TABLES `log_client_city` WRITE;
/*!40000 ALTER TABLE `log_client_city` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client_city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_client_coordinate`
--

DROP TABLE IF EXISTS `log_client_coordinate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client_coordinate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client_coordinate` (`latitude`,`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client_coordinate`
--

LOCK TABLES `log_client_coordinate` WRITE;
/*!40000 ALTER TABLE `log_client_coordinate` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client_coordinate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_client_country`
--

DROP TABLE IF EXISTS `log_client_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client_country` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country` varchar(150) NOT NULL,
  `country_code` varchar(20) DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client_country` (`country`,`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client_country`
--

LOCK TABLES `log_client_country` WRITE;
/*!40000 ALTER TABLE `log_client_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `log_client_list`
--

DROP TABLE IF EXISTS `log_client_list`;
/*!50001 DROP VIEW IF EXISTS `log_client_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `log_client_list` AS SELECT 
 1 AS `Client Name`,
 1 AS `Access Log Count`,
 1 AS `Error Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `log_client_network`
--

DROP TABLE IF EXISTS `log_client_network`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client_network` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client_network` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client_network`
--

LOCK TABLES `log_client_network` WRITE;
/*!40000 ALTER TABLE `log_client_network` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client_network` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_client_organization`
--

DROP TABLE IF EXISTS `log_client_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client_organization` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client_organization` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client_organization`
--

LOCK TABLES `log_client_organization` WRITE;
/*!40000 ALTER TABLE `log_client_organization` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client_organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_client_subdivision`
--

DROP TABLE IF EXISTS `log_client_subdivision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_client_subdivision` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_client_subdivision` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_client_subdivision`
--

LOCK TABLES `log_client_subdivision` WRITE;
/*!40000 ALTER TABLE `log_client_subdivision` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_client_subdivision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_clientport`
--

DROP TABLE IF EXISTS `log_clientport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_clientport` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_clientport` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_clientport`
--

LOCK TABLES `log_clientport` WRITE;
/*!40000 ALTER TABLE `log_clientport` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_clientport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `log_clientport_list`
--

DROP TABLE IF EXISTS `log_clientport_list`;
/*!50001 DROP VIEW IF EXISTS `log_clientport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `log_clientport_list` AS SELECT 
 1 AS `Client Port`,
 1 AS `Access Log Count`,
 1 AS `Error Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `log_referer`
--

DROP TABLE IF EXISTS `log_referer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_referer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(750) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_referer` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_referer`
--

LOCK TABLES `log_referer` WRITE;
/*!40000 ALTER TABLE `log_referer` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_referer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `log_referer_list`
--

DROP TABLE IF EXISTS `log_referer_list`;
/*!50001 DROP VIEW IF EXISTS `log_referer_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `log_referer_list` AS SELECT 
 1 AS `Referer`,
 1 AS `Access Log Count`,
 1 AS `Error Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `log_requestlog_list`
--

DROP TABLE IF EXISTS `log_requestlog_list`;
/*!50001 DROP VIEW IF EXISTS `log_requestlog_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `log_requestlog_list` AS SELECT 
 1 AS `Request Log`,
 1 AS `Access Log Count`,
 1 AS `Error Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `log_requestlogid`
--

DROP TABLE IF EXISTS `log_requestlogid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_requestlogid` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_requestlogid`
--

LOCK TABLES `log_requestlogid` WRITE;
/*!40000 ALTER TABLE `log_requestlogid` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_requestlogid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_server`
--

DROP TABLE IF EXISTS `log_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_server` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(253) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_server` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_server`
--

LOCK TABLES `log_server` WRITE;
/*!40000 ALTER TABLE `log_server` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `log_server_list`
--

DROP TABLE IF EXISTS `log_server_list`;
/*!50001 DROP VIEW IF EXISTS `log_server_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `log_server_list` AS SELECT 
 1 AS `Server Name`,
 1 AS `Access Log Count`,
 1 AS `Error Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `log_serverport`
--

DROP TABLE IF EXISTS `log_serverport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_serverport` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `U_log_serverport` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table is used by Access and Error logs.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_serverport`
--

LOCK TABLES `log_serverport` WRITE;
/*!40000 ALTER TABLE `log_serverport` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_serverport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `log_serverport_list`
--

DROP TABLE IF EXISTS `log_serverport_list`;
/*!50001 DROP VIEW IF EXISTS `log_serverport_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `log_serverport_list` AS SELECT 
 1 AS `Server Port`,
 1 AS `Access Log Count`,
 1 AS `Error Log Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'apache_logs'
--
/*!50003 DROP FUNCTION IF EXISTS `access_cookie` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_cookie`(in_CookieID INTEGER) RETURNS varchar(400) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE cookie VARCHAR(400) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_cookie';
    SELECT name
      INTO cookie
      FROM apache_logs.access_log_cookie
     WHERE id = in_CookieID;
    RETURN cookie;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_cookieID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_cookieID`(in_Cookie VARCHAR(400)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE cookie_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_cookieID';
    SELECT id
      INTO cookie_ID
      FROM apache_logs.access_log_cookie
     WHERE name = in_Cookie;
    IF cookie_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_cookie (name) VALUES (in_Cookie);
        SET cookie_ID = LAST_INSERT_ID();
    END IF;
    RETURN cookie_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_remoteLogName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_remoteLogName`(in_RemoteLogNameID INTEGER) RETURNS varchar(150) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE remoteLogName VARCHAR(150) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteLogName';
    SELECT name
      INTO remoteLogName
      FROM apache_logs.access_log_remotelogname
     WHERE id = in_RemoteLogNameID;
    RETURN remoteLogName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_remoteLogNameID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_remoteLogNameID`(in_RemoteLogName VARCHAR(150)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE remoteLogName_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteLogNameID';
    SELECT id
      INTO remoteLogName_ID
      FROM apache_logs.access_log_remotelogname
     WHERE name = in_RemoteLogName;
    IF remoteLogName_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_remotelogname (name) VALUES (in_RemoteLogName);
        SET remoteLogName_ID = LAST_INSERT_ID();
    END IF;
    RETURN remoteLogName_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_remoteUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_remoteUser`(in_RemoteUserID INTEGER) RETURNS varchar(150) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE remoteUser VARCHAR(150) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteUser';
    SELECT name
      INTO remoteUser
      FROM apache_logs.access_log_remoteuser
     WHERE id = in_RemoteUserID;
    RETURN remoteUser;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_remoteUserID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_remoteUserID`(in_RemoteUser VARCHAR(150)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE remoteUser_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_remoteUserID';
    SELECT id
      INTO remoteUser_ID
      FROM apache_logs.access_log_remoteuser
     WHERE name = in_RemoteUser;
    IF remoteUser_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_remoteuser (name) VALUES (in_RemoteUser);
        SET remoteUser_ID = LAST_INSERT_ID();
    END IF;
    RETURN remoteUser_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqMethod` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqMethod`(in_ReqMethodID INTEGER) RETURNS varchar(40) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE reqMethod VARCHAR(40) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqMethod';
    SELECT name
      INTO reqMethod
      FROM apache_logs.access_log_reqmethod
     WHERE id = in_ReqMethodID;
    RETURN reqMethod;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqMethodID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqMethodID`(in_ReqMethod VARCHAR(40)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE reqMethod_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqMethodID';
    SELECT id
      INTO reqMethod_ID
      FROM apache_logs.access_log_reqmethod
     WHERE name = in_ReqMethod;
    IF reqMethod_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqmethod (name) VALUES (in_ReqMethod);
        SET reqMethod_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqMethod_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqProtocol` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqProtocol`(in_ReqProtocolID INTEGER) RETURNS varchar(20) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE reqProtocol VARCHAR(20) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqProtocol';
    SELECT name
      INTO reqProtocol
      FROM apache_logs.access_log_reqprotocol
     WHERE id = in_ReqProtocolID;
    RETURN reqProtocol;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqProtocolID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqProtocolID`(in_ReqProtocol VARCHAR(20)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE reqProtocol_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqProtocolID';
    SELECT id
      INTO reqProtocol_ID
      FROM apache_logs.access_log_reqprotocol
     WHERE name = in_ReqProtocol;
    IF reqProtocol_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqprotocol (name) VALUES (in_ReqProtocol);
        SET reqProtocol_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqProtocol_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqQuery` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqQuery`(in_ReqQueryID INTEGER) RETURNS varchar(2000) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE reqQuery VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqQuery';
    SELECT name
      INTO reqQuery
      FROM apache_logs.access_log_reqquery
     WHERE id = in_ReqQueryID;
    RETURN reqQuery;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqQueryID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqQueryID`(in_ReqQuery VARCHAR(2000)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE reqQuery_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqQueryID';
    SELECT id
      INTO reqQuery_ID
      FROM apache_logs.access_log_reqquery
     WHERE name = in_ReqQuery;
    IF reqQuery_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqquery (name) VALUES (in_ReqQuery);
        SET reqQuery_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqQuery_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqStatus`(in_ReqStatusID INTEGER) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE reqStatus INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqStatus';
    SELECT name
      INTO reqStatus
      FROM apache_logs.access_log_reqstatus
     WHERE id = in_ReqStatusID;
    RETURN reqStatus;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqStatusID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqStatusID`(in_ReqStatus INTEGER) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE reqStatus_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqStatusID';
    SELECT id
      INTO reqStatus_ID
      FROM apache_logs.access_log_reqstatus
     WHERE name = in_ReqStatus;
    IF reqStatus_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_reqstatus (name) VALUES (in_ReqStatus);
        SET reqStatus_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqStatus_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqUri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqUri`(in_ReqUriID INTEGER) RETURNS varchar(2000) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE reqUri VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqUri';
    SELECT name
      INTO reqUri
      FROM apache_logs.access_log_requri
     WHERE id = in_ReqUriID;
    RETURN reqUri;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_reqUriID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_reqUriID`(in_ReqUri VARCHAR(2000)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE reqUri_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_reqUriID';
    SELECT id
      INTO reqUri_ID
      FROM apache_logs.access_log_requri
     WHERE name = in_ReqUri;
    IF reqUri_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_requri (name) VALUES (in_ReqUri);
        SET reqUri_ID = LAST_INSERT_ID();
    END IF;
    RETURN reqUri_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_ua` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_ua`(in_uaID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_ua';
    SELECT name
      INTO ua
      FROM apache_logs.access_log_ua
     WHERE id = in_uaID;
    RETURN ua;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaBrowser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaBrowser`(in_ua_browserID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_browser VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowser';
    SELECT name
      INTO ua_browser
      FROM apache_logs.access_log_ua_browser
     WHERE id = in_ua_browserID;
    RETURN ua_browser;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaBrowserFamily` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaBrowserFamily`(in_ua_browser_familyID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_browser_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserFamily';
    SELECT name
      INTO ua_browser_family
      FROM apache_logs.access_log_ua_browser_family
     WHERE id = in_ua_browser_familyID;
    RETURN ua_browser_family;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaBrowserFamilyID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaBrowserFamilyID`(in_ua_browser_family VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_browser_family_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserFamilyID';
    SELECT id
      INTO ua_browser_family_ID
      FROM apache_logs.access_log_ua_browser_family
     WHERE name = in_ua_browser_family;
    IF ua_browser_family_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_browser_family (name) VALUES (in_ua_browser_family);
        SET ua_browser_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_family_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaBrowserID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaBrowserID`(in_ua_browser VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_browser_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserID';
    SELECT id
      INTO ua_browser_ID
      FROM apache_logs.access_log_ua_browser
     WHERE name = in_ua_browser;
    IF ua_browser_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_browser (name) VALUES (in_ua_browser);
        SET ua_browser_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaBrowserVersion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaBrowserVersion`(in_ua_browser_versionID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_browser_version VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserVersion';
    SELECT name
      INTO ua_browser_version
      FROM apache_logs.access_log_ua_browser_version
     WHERE id = in_ua_browser_versionID;
    RETURN ua_browser_version;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaBrowserVersionID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaBrowserVersionID`(in_ua_browser_version VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_browser_version_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaBrowserVersionID';
    SELECT id
      INTO ua_browser_version_ID
      FROM apache_logs.access_log_ua_browser_version
     WHERE name = in_ua_browser_version;
    IF ua_browser_version_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_browser_version (name) VALUES (in_ua_browser_version);
        SET ua_browser_version_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_browser_version_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDevice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDevice`(in_ua_deviceID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_device VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDevice';
    SELECT name
      INTO ua_device
      FROM apache_logs.access_log_ua_device
     WHERE id = in_ua_deviceID;
    RETURN ua_device;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceBrand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceBrand`(in_ua_device_brandID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_device_brand VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceBrand';
    SELECT name
      INTO ua_device_brand
      FROM apache_logs.access_log_ua_device_brand
     WHERE name = in_ua_device_brandID;
    RETURN ua_device_brand;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceBrandID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceBrandID`(in_ua_device_brand VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_device_brand_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceBrandID';
    SELECT id
      INTO ua_device_brand_ID
      FROM apache_logs.access_log_ua_device_brand
     WHERE name = in_ua_device_brand;
    IF ua_device_brand_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device_brand (name) VALUES (in_ua_device_brand);
        SET ua_device_brand_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_brand_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceFamily` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceFamily`(in_ua_device_familyID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_device_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceFamily';
    SELECT name
      INTO ua_device_family
      FROM apache_logs.access_log_ua_device_family
     WHERE id = in_ua_device_familyID;
    RETURN ua_device_family;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceFamilyID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceFamilyID`(in_ua_device_family VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_device_family_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceFamilyID';
    SELECT id
      INTO ua_device_family_ID
      FROM apache_logs.access_log_ua_device_family
     WHERE name = in_ua_device_family;
    IF ua_device_family_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device_family (name) VALUES (in_ua_device_family);
        SET ua_device_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_family_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceID`(in_ua_device VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_device_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceID'; 
    SELECT id
      INTO ua_device_ID
      FROM apache_logs.access_log_ua_device
     WHERE name = in_ua_device;
    IF ua_device_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device (name) VALUES (in_ua_device);
        SET ua_device_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceModel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceModel`(in_ua_device_modelID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_device_model VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceModel';
    SELECT name
      INTO ua_device_model
      FROM apache_logs.access_log_ua_device_model
     WHERE id = in_ua_device_modelID;
    RETURN ua_device_model;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaDeviceModelID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaDeviceModelID`(in_ua_device_model VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_device_model_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaDeviceModelID';
    SELECT id
      INTO ua_device_model_ID
      FROM apache_logs.access_log_ua_device_model
     WHERE name = in_ua_device_model;
    IF ua_device_model_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_device_model (name) VALUES (in_ua_device_model);
        SET ua_device_model_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_device_model_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaID`(in_ua VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaID';
    SELECT id
      INTO ua_ID
      FROM apache_logs.access_log_ua
     WHERE name = in_ua;
    IF ua_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua (name) VALUES (in_ua);
        SET ua_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaOs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaOs`(in_ua_osID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_os VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOs';
    SELECT name
      INTO ua_os
      FROM apache_logs.access_log_ua_os
     WHERE id = in_ua_osID;
    RETURN ua_os;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaOsFamily` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaOsFamily`(in_ua_os_familyID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_os_family VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsFamily';
    SELECT name
      INTO ua_os_family
      FROM apache_logs.access_log_ua_os_family
     WHERE id = in_ua_os_familyID;
    RETURN ua_os_family;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaOsFamilyID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaOsFamilyID`(in_ua_os_family VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_os_family_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsFamilyID';
    SELECT id
      INTO ua_os_family_ID
      FROM apache_logs.access_log_ua_os_family
     WHERE name = in_ua_os_family;
    IF ua_os_family_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_os_family (name) VALUES (in_ua_os_family);
        SET ua_os_family_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_family_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaOsID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaOsID`(in_ua_os VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_os_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsID'; 
    SELECT id
      INTO ua_os_ID
      FROM apache_logs.access_log_ua_os
     WHERE name = in_ua_os;
    IF ua_os_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_os (name) VALUES (in_ua_os);
        SET ua_os_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaOsVersion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaOsVersion`(in_ua_os_versionID INTEGER) RETURNS varchar(300) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE ua_os_version VARCHAR(300) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsVersion';
    SELECT name
      INTO ua_os_version
      FROM apache_logs.access_log_ua_os_version
     WHERE id = in_ua_os_versionID;
    RETURN ua_os_version;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_uaOsVersionID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_uaOsVersionID`(in_ua_os_version VARCHAR(300)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE ua_os_version_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_uaOsVersionID';
    SELECT id
      INTO ua_os_version_ID
      FROM apache_logs.access_log_ua_os_version
     WHERE name = in_ua_os_version;
    IF ua_os_version_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_ua_os_version (name) VALUES (in_ua_os_version);
        SET ua_os_version_ID = LAST_INSERT_ID();
    END IF;
    RETURN ua_os_version_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_userAgent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_userAgent`(in_UserAgentID INTEGER) RETURNS varchar(2000) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE userAgent VARCHAR(2000) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_userAgent';
    SELECT name
      INTO userAgent
      FROM apache_logs.access_log_useragent
     WHERE id = in_UserAgentID;
    RETURN userAgent;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_userAgentID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `access_userAgentID`(in_UserAgent VARCHAR(2000)) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE userAgent_ID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'access_userAgentID';
    SELECT id
      INTO userAgent_ID
      FROM apache_logs.access_log_useragent
     WHERE name = in_UserAgent;
    IF userAgent_ID IS NULL THEN
        INSERT INTO apache_logs.access_log_useragent (name) VALUES (in_UserAgent);
        SET userAgent_ID = LAST_INSERT_ID();
    END IF;
    RETURN userAgent_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `clientID_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `clientID_logs`(in_clientID INTEGER,
   in_Log VARCHAR(1)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'clientID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE clientID = in_clientID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE clientID = in_clientID;
  END IF;
  RETURN logCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `clientPortID_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `clientPortID_logs`(in_clientPortID INTEGER,
   in_Log VARCHAR(1)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'clientPortID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE clientPortID = in_clientPortID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE clientPortID = in_clientPortID;
  END IF;
  RETURN logCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_apacheCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheCode`(in_apacheCodeID INTEGER) RETURNS varchar(400) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE apacheCode VARCHAR(400) DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheCode';
  SELECT name
    INTO apacheCode
    FROM apache_logs.error_log_apachecode
    WHERE id = in_apacheCodeID;
  RETURN apacheCode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_apacheCodeID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheCodeID`(in_apacheCode VARCHAR(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE apacheCodeID INTEGER DEFAULT null;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheCodeID';
  SELECT id
    INTO apacheCodeID
    FROM apache_logs.error_log_apachecode
    WHERE name = in_apacheCode;
  IF apacheCodeID IS NULL THEN
      INSERT INTO apache_logs.error_log_apachecode (name) VALUES (in_apacheCode);
      SET apacheCodeID = LAST_INSERT_ID();
  END IF;
  RETURN apacheCodeID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_apacheMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheMessage`(in_apacheMessageID INTEGER) RETURNS varchar(400) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE apacheMessage VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheMessage';
  SELECT name
    INTO apacheMessage
    FROM apache_logs.error_log_apachemessage
    WHERE id = in_apacheMessageID;
  RETURN apacheMessage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_apacheMessageID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_apacheMessageID`(in_apacheMessage VARCHAR(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE apacheMessageID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_apacheMessageID';
  SELECT id
    INTO apacheMessageID
    FROM apache_logs.error_log_apachemessage
    WHERE name = in_apacheMessage;
  IF apacheMessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_apachemessage (name) VALUES (in_apacheMessage);
      SET apacheMessageID = LAST_INSERT_ID();
  END IF;
  RETURN apacheMessageID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_logLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logLevel`(in_loglevelID INTEGER) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE logLevel VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logLevel';
  SELECT name
    INTO logLevel
    FROM apache_logs.error_log_level
    WHERE id = in_loglevelID;
  RETURN logLevel;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_logLevelID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logLevelID`(in_loglevel VARCHAR(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logLevelID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logLevelID';
  SELECT id
    INTO logLevelID
    FROM apache_logs.error_log_level
    WHERE name = in_loglevel;
  IF logLevelID IS NULL THEN
      INSERT INTO apache_logs.error_log_level (name) VALUES (in_loglevel);
      SET logLevelID = LAST_INSERT_ID();
  END IF;
  RETURN logLevelID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_logMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logMessage`(in_messageID INTEGER) RETURNS varchar(500) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE logMessage VARCHAR(500) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logMessage';
  SELECT name
    INTO logMessage
    FROM apache_logs.error_log_message
    WHERE id = in_messageID;
  RETURN logMessage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_logMessageID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_logMessageID`(in_message VARCHAR(500)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE messageID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_logMessageID';
  SELECT id
    INTO messageID
    FROM apache_logs.error_log_message
    WHERE name = in_message;
  IF messageID IS NULL THEN
      INSERT INTO apache_logs.error_log_message (name) VALUES (in_message);
      SET messageID = LAST_INSERT_ID();
  END IF;
  RETURN messageID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_module` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_module`(in_module INTEGER) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE module VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_module';
  SELECT name
    INTO module
    FROM apache_logs.error_log_module
    WHERE id = in_moduleID;
  RETURN module;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_moduleID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_moduleID`(in_module VARCHAR(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE moduleID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_moduleID';
  SELECT id
    INTO moduleID
    FROM apache_logs.error_log_module
    WHERE name = in_module;
  IF moduleID IS NULL THEN
      INSERT INTO apache_logs.error_log_module (name) VALUES (in_module);
      SET moduleID = LAST_INSERT_ID();
  END IF;
  RETURN moduleID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_process`(in_processidID INTEGER) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE process  VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_process';
  SELECT name
    INTO process
    FROM apache_logs.error_log_processid
    WHERE id = in_processidID;
  RETURN process;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_processID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_processID`(in_processid VARCHAR(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE process_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_processID';
  SELECT id
    INTO process_ID
    FROM apache_logs.error_log_processid
    WHERE name = in_processid;
  IF process_ID IS NULL THEN
      INSERT INTO apache_logs.error_log_processid (name) VALUES (in_processid);
      SET process_ID = LAST_INSERT_ID();
  END IF;
  RETURN process_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_systemCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemCode`(in_systemCodeID INTEGER) RETURNS varchar(400) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE systemCode VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemCode';
  SELECT name
    INTO systemCode
    FROM apache_logs.error_log_systemcode
    WHERE id = in_systemCodeID;
  RETURN systemCode;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_systemCodeID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemCodeID`(in_systemCode VARCHAR(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE systemCodeID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemCodeID';
  SELECT id
    INTO systemCodeID
    FROM apache_logs.error_log_systemcode
    WHERE name = in_systemCode;
  IF systemCodeID IS NULL THEN
      INSERT INTO apache_logs.error_log_systemcode (name) VALUES (in_systemCode);
      SET systemCodeID = LAST_INSERT_ID();
  END IF;
  RETURN systemCodeID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_systemMessage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemMessage`(in_systemMessageID INTEGER) RETURNS varchar(400) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE systemMessage VARCHAR(400) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemMessage';
  SELECT name
    INTO systemMessage
    FROM apache_logs.error_log_systemmessage
    WHERE id = in_systemMessageID;
  RETURN systemMessage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_systemMessageID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_systemMessageID`(in_systemMessage VARCHAR(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE systemMessageID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_systemMessageID';
  SELECT id
    INTO systemMessageID
    FROM apache_logs.error_log_systemmessage
    WHERE name = in_systemMessage;
  IF systemMessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_systemmessage (name) VALUES (in_systemMessage);
      SET systemMessageID = LAST_INSERT_ID();
  END IF;
  RETURN systemMessageID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_thread` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_thread`(in_threadidID INTEGER) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE thread VARCHAR(100) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_thread';
  SELECT name
    INTO thread
    FROM apache_logs.error_log_threadid
    WHERE id = in_threadidID;
  RETURN thread;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_threadID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `error_threadID`(in_threadid VARCHAR(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE thread_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'error_threadID';
  SELECT id
    INTO thread_ID
    FROM apache_logs.error_log_threadid
    WHERE name = in_threadid;
  IF thread_ID IS NULL THEN
      INSERT INTO apache_logs.error_log_threadid (name) VALUES (in_threadid);
      SET thread_ID = LAST_INSERT_ID();
  END IF;
  RETURN thread_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importClientID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importClientID`(in_ipaddress VARCHAR(50),
   in_login VARCHAR(200),
   in_expandUser VARCHAR(200),
   in_platformRelease VARCHAR(100),
   in_platformVersion VARCHAR(175),
   in_importdevice_id VARCHAR(30)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importClient_ID INTEGER DEFAULT null;
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
		CALL apache_logs.errorProcess('importclientID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', null, null);
	END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
	  SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importClient_ID
    FROM apache_logs.import_client
   WHERE ipaddress = in_ipaddress
     AND login = in_login
     AND expandUser = in_expandUser
     AND platformRelease = in_platformRelease
     AND platformVersion = in_platformVersion
     AND importdeviceid = importDevice_ID;
  IF importClient_ID IS NULL THEN
  	INSERT INTO apache_logs.import_client 
      (ipaddress,
       login,
       expandUser,
       platformRelease,
       platformVersion,
       importdeviceid)
    VALUES
      (in_ipaddress,
       in_login,
       in_expandUser,
       in_platformRelease,
       in_platformVersion,
       importDevice_ID);
	  SET importClient_ID = LAST_INSERT_ID();
  END IF;
  RETURN importClient_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importDeviceID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importDeviceID`(in_deviceid VARCHAR(150),
   in_platformNode VARCHAR(200),
   in_platformSystem VARCHAR(100),
   in_platformMachine VARCHAR(100),
   in_platformProcessor VARCHAR(200)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
		CALL apache_logs.errorProcess('importdeviceID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', null, null);
	END;
  SELECT id
    INTO importDevice_ID
    FROM apache_logs.import_device
   WHERE deviceid = in_deviceid
     AND platformNode = in_platformNode
     AND platformSystem = in_platformSystem
     AND platformMachine = in_platformMachine
     AND platformProcessor = in_platformProcessor;
  IF importDevice_ID IS NULL THEN
  	INSERT INTO apache_logs.import_device 
      (deviceid,
       platformNode,
       platformSystem,
       platformMachine,
       platformProcessor)
    VALUES
      (in_deviceid,
       in_platformNode,
       in_platformSystem,
       in_platformMachine,
       in_platformProcessor);
	  SET importDevice_ID = LAST_INSERT_ID();
  END IF;
  RETURN importDevice_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importFileCheck` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileCheck`(importfileid INTEGER,
   processid INTEGER,
   processType VARCHAR(10)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importFileName VARCHAR(300) DEFAULT null;
  DECLARE parseProcess_ID INTEGER DEFAULT null;
  DECLARE importProcess_ID INTEGER DEFAULT null;
  DECLARE processFile INTEGER DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importFileCheck'; 
  SELECT name,
         parseprocessid,
         importprocessid 
    INTO importFileName,
         parseProcess_ID,
         importProcess_ID
    FROM apache_logs.import_file
   WHERE id = importfileid;
  -- IF none of these things happen all is well. processing records from same file.
  IF importFileName IS NULL THEN
  -- This is an error. Import File must be in table when import processing.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = `ERROR - Import File is not found in import_file table.`,
      MYSQL_ERRNO = ER_SIGNAL_EXCEPTION;
  ELSEIF processid IS NULL THEN
  -- This is an error. This function is only called when import processing. ProcessID must be valid.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = `ERROR - ProcessID required when import processing.`,
      MYSQL_ERRNO = ER_SIGNAL_EXCEPTION;
  ELSEIF processType = 'parse' AND parseProcess_ID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE apache_logs.import_file SET parseprocessid = processid WHERE id = importFileID;
  ELSEIF  processType = 'parse' AND processid != parseProcess_ID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = `ERROR - Previous PARSE process found. File has already been PARSED.`,
      MYSQL_ERRNO = ER_SIGNAL_EXCEPTION;
  ELSEIF processType = 'import' AND importProcess_ID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE apache_logs.import_file SET importprocessid = processid WHERE id = importFileID;
  ELSEIF  processType = 'import' AND processid != importProcess_ID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = `ERROR - Previous IMPORT process found. File has already been IMPORTED.`,
      MYSQL_ERRNO = ER_SIGNAL_EXCEPTION;
  END IF;
  RETURN processFile;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importFileExists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileExists`(in_importFile VARCHAR(300),
   in_importdevice_id VARCHAR(30)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importFileID INTEGER DEFAULT null;
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importFileExists', e1, e2, e3, 'apache_logs', 'logs2mysql.py', null, null );
	END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
	  SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importFileID
    FROM apache_logs.import_file
   WHERE name = in_importFile
     AND importdeviceid = importDevice_ID;
  RETURN NOT ISNULL(importFileID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importFileID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileID`(importFile VARCHAR(300),
   file_size VARCHAR(30),
   file_created VARCHAR(30),
   file_modified VARCHAR(30),
   in_importdevice_id VARCHAR(10),
   in_importload_id VARCHAR(10),
   fileformat VARCHAR(10)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importFile_ID INTEGER DEFAULT null;
  DECLARE importLoad_ID INTEGER DEFAULT null;
  DECLARE importDevice_ID INTEGER DEFAULT null;
  DECLARE formatfile_ID INTEGER DEFAULT 0;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importFileID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', importload_id, null );
	END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
	  SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importFile_ID
    FROM apache_logs.import_file
   WHERE name = importFile
     AND importdeviceid = importDevice_ID;
  IF importFile_ID IS NULL THEN
    IF NOT CONVERT(in_importload_id, UNSIGNED) = 0 THEN
  	  SET importLoad_ID = CONVERT(in_importload_id, UNSIGNED);
    END IF;
    IF NOT CONVERT(fileformat, UNSIGNED) = 0 THEN
  	  SET formatFile_ID = CONVERT(fileformat, UNSIGNED);
    END IF;
    INSERT INTO apache_logs.import_file 
			(name,
			 filesize,
			 filecreated,
			 filemodified,
       importdeviceid,
       importloadid,
       importformatid)
    VALUES 
      (importFile, 
       CONVERT(file_size, UNSIGNED),
       STR_TO_DATE(file_created,'%a %b %e %H:%i:%s %Y'),
       STR_TO_DATE(file_modified,'%a %b %e %H:%i:%s %Y'),
       importDevice_ID,
       importLoad_ID,
       formatFile_ID);
    SET importFile_ID = LAST_INSERT_ID();
  END IF;
  RETURN importFile_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importLoadID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importLoadID`(in_importclient_id VARCHAR(30)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importLoad_ID INTEGER DEFAULT null;
  DECLARE importclient_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL apache_logs.errorProcess('importLoadID', e1, e2, e3, 'apache_logs', 'logs2mysql.py', importLoad_ID, null );
	END;
  IF NOT CONVERT(in_importclient_id, UNSIGNED) = 0 THEN
	  SET importclient_ID = CONVERT(in_importclient_id, UNSIGNED);
  END IF;
  INSERT INTO apache_logs.import_load (importclientid) VALUES (importclient_ID);
  SET importLoad_ID = LAST_INSERT_ID();
  RETURN importLoad_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importProcessID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importProcessID`(processType VARCHAR(100),
   processName VARCHAR(100)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importProcess_ID INTEGER DEFAULT NULL;
  DECLARE importServer_ID INTEGER DEFAULT NULL;
  DECLARE db_user VARCHAR(255) DEFAULT NULL;
  DECLARE db_host VARCHAR(255) DEFAULT NULL;
  DECLARE db_version VARCHAR(255) DEFAULT NULL;
  DECLARE db_system VARCHAR(255) DEFAULT NULL;
  DECLARE db_machine VARCHAR(255) DEFAULT NULL;
  DECLARE db_server VARCHAR(255) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  	BEGIN
	  	IF @error_count=1 THEN RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importServerID called from importProcessID'; ELSE RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importProcessID'; END IF;
	  END;
  SET @error_count = 0;
	SELECT user(),
    @@hostname,
    @@version,
    @@version_compile_os,
    @@version_compile_machine,
    @@server_uuid
  INTO 
    db_user,
    db_host,
    db_version,
    db_system,
    db_machine,
    db_server;
	SET importServer_ID = importServerID(db_user, db_host, db_version, db_system, db_machine, db_server);
	INSERT INTO apache_logs.import_process
      (type,
       name,
       importserverid)
    VALUES
      (processType,
       processName,
       importServer_ID);
  SET importProcess_ID = LAST_INSERT_ID();
  RETURN importProcess_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `importServerID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `importServerID`(in_user VARCHAR(255),
	 in_host VARCHAR(255),
   in_version VARCHAR(55),
   in_system VARCHAR(55),
   in_machine VARCHAR(55),
	 in_server VARCHAR(75)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importServer_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
  	SET @error_count = 1;
	  RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'importServerID'; 
  END;
  SELECT id
	  INTO importServer_ID
	  FROM apache_logs.import_server
   WHERE dbuser = in_user
     AND dbhost = in_host
     AND dbversion = in_version
     AND dbsystem = in_system
     AND dbmachine = in_machine
     AND serveruuid = in_server;
  IF importServer_ID IS NULL THEN
    INSERT INTO apache_logs.import_server 
      (dbuser,
       dbhost,
       dbversion,
       dbsystem,
       dbmachine,
       serveruuid)
    VALUES
      (in_user,
       in_host,
       in_version,
       in_system,
       in_machine,
       in_server);
    SET importServer_ID = LAST_INSERT_ID();
  END IF;
  RETURN importServer_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_client` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_client`(in_clientID INTEGER) RETURNS varchar(253) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE client VARCHAR(253) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_client';
  SELECT name
    INTO client
    FROM apache_logs.log_client
   WHERE id = in_clientID;
  RETURN client;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientCityID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientCityID`(in_city VARCHAR(250)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientCity_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientCityID';
  SELECT id
    INTO clientCity_ID
    FROM apache_logs.log_client_city
   WHERE name = in_city;
  IF clientCity_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_city (name) VALUES (in_city);
    SET clientCity_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCity_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientCoordinateID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientCoordinateID`(in_latitude DECIMAL(10,8),
   in_longitude DECIMAL(11,8)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientCoordinate_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientCoordinateID';
  SELECT id
    INTO clientCoordinate_ID
    FROM apache_logs.log_client_coordinate
   WHERE latitude = in_latitude
     AND longitude = in_longitude;
  IF clientCoordinate_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_coordinate (latitude, longitude) VALUES (in_latitude, in_longitude);
    SET clientCoordinate_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCoordinate_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientCountryID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientCountryID`(in_country VARCHAR(150),
   in_country_code VARCHAR(20)
  ) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientCountry_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientCountryID';
  SELECT id
    INTO clientCountry_ID
    FROM apache_logs.log_client_country
   WHERE country = in_country
     AND country_code = in_country_code;
  IF clientCountry_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_country (country, country_code) VALUES (in_country, in_country_code);
    SET clientCountry_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientCountry_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientID`(in_client VARCHAR(253)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE client_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientID';
  SELECT id
    INTO client_ID
    FROM apache_logs.log_client
   WHERE name = in_client;
  IF client_ID IS NULL THEN
    INSERT INTO apache_logs.log_client (name) VALUES (in_client);
    SET client_ID = LAST_INSERT_ID();
  END IF;
  RETURN client_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientNetworkID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientNetworkID`(in_network VARCHAR(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientNetwork_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientNetworkID';
  SELECT id
    INTO clientNetwork_ID
    FROM apache_logs.log_client_network
   WHERE name = in_network;
  IF clientNetwork_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_network (name) VALUES (in_network);
    SET clientNetwork_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientNetwork_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientOrganizationID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientOrganizationID`(in_organization VARCHAR(500)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientOrganization_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientOrganizationID';
  SELECT id
    INTO clientOrganization_ID
    FROM apache_logs.log_client_organization
   WHERE name = in_organization;
  IF clientOrganization_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_organization (name) VALUES (in_organization);
    SET clientOrganization_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientOrganization_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientPort` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientPort`(in_ClientPortID INTEGER) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientPort INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientPort';
  SELECT name
    INTO clientPort
    FROM apache_logs.log_clientport
   WHERE id = in_ClientPortID;
  RETURN clientPort;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientPortID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientPortID`(in_ClientPort INTEGER) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientPort_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientPortID';
  SELECT id
    INTO clientPort_ID
    FROM apache_logs.log_clientport
   WHERE name = in_ClientPort;
  IF clientPort_ID IS NULL THEN
    INSERT INTO apache_logs.log_clientport (name) VALUES (in_ClientPort);
    SET clientPort_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientPort_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_clientSubdivisionID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_clientSubdivisionID`(in_subdivision VARCHAR(250)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE clientSubdivision_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_clientSubdivisionID';
  SELECT id
    INTO clientSubdivision_ID
    FROM apache_logs.log_client_subdivision
   WHERE name = in_subdivision;
  IF clientSubdivision_ID IS NULL THEN
    INSERT INTO apache_logs.log_client_subdivision (name) VALUES (in_subdivision);
    SET clientSubdivision_ID = LAST_INSERT_ID();
  END IF;
  RETURN clientSubdivision_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_referer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_referer`(in_RefererID INTEGER) RETURNS varchar(1000) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE referer VARCHAR(1000) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_referer';
  SELECT name
    INTO referer
    FROM apache_logs.log_referer
   WHERE id = in_RefererID;
  RETURN referer;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_refererID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_refererID`(in_Referer VARCHAR(1000)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE referer_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_refererID';
  SELECT id
    INTO referer_ID
    FROM apache_logs.log_referer
   WHERE name = in_Referer;
  IF referer_ID IS NULL THEN
    INSERT INTO apache_logs.log_referer (name) VALUES (in_Referer);
    SET referer_ID = LAST_INSERT_ID();
  END IF;
  RETURN referer_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_requestLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_requestLog`(in_RequestLogID INTEGER) RETURNS varchar(50) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE requestLog VARCHAR(50) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_requestLog';
  SELECT name
    INTO requestLog
    FROM apache_logs.log_requestlogid
   WHERE name = in_RequestLogID;
  RETURN requestLog;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_requestLogID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_requestLogID`(in_RequestLog VARCHAR(50)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE requestLog_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_requestLogID';
  SELECT id
    INTO requestLog_ID
    FROM apache_logs.log_requestlogid
   WHERE name = in_RequestLog;
  IF requestLog_ID IS NULL THEN
    INSERT INTO apache_logs.log_requestlogid (name) VALUES (in_RequestLog);
    SET requestLog_ID = LAST_INSERT_ID();
  END IF;
  RETURN requestLog_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_server` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_server`(in_ServerID INTEGER) RETURNS varchar(253) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE server VARCHAR(253) DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_server';
  SELECT name
    INTO server
    FROM apache_logs.log_server
   WHERE id = in_ServerID;
  RETURN server;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_serverID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_serverID`(in_Server VARCHAR(253)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE server_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_serverID';
  SELECT id
    INTO server_ID
    FROM apache_logs.log_server
   WHERE name = in_Server;
  IF server_ID IS NULL THEN
    INSERT INTO apache_logs.log_server (name) VALUES (in_Server);
    SET server_ID = LAST_INSERT_ID();
  END IF;
  RETURN server_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_serverPort` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_serverPort`(in_ServerPortID INTEGER) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE serverPort INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_serverPort';
  SELECT name
    INTO serverPort
    FROM apache_logs.log_serverport
   WHERE id = in_ServerPortID;
  RETURN serverPort;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_serverPortID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_serverPortID`(in_ServerPort INTEGER) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE serverPort_ID INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'log_serverPortID';
  SELECT id
    INTO serverPort_ID
    FROM apache_logs.log_serverport
   WHERE name = in_ServerPort;
  IF serverPort_ID IS NULL THEN
    INSERT INTO apache_logs.log_serverport (name) VALUES (in_ServerPort);
    SET serverPort_ID = LAST_INSERT_ID();
  END IF;
  RETURN serverPort_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `refererID_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `refererID_logs`(in_refererID INTEGER,
   in_Log VARCHAR(1)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'refererID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE refererID = in_refererID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE refererID = in_refererID;
  END IF;
  RETURN logCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `requestLogID_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `requestLogID_logs`(in_requestLogID INTEGER,
   in_Log VARCHAR(1)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'requestLogID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE requestLogID = in_requestLogID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE requestLogID = in_requestLogID;
  END IF;
  RETURN logCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `serverID_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `serverID_logs`(in_ServerID INTEGER,
   in_Log VARCHAR(1)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'serverID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE serverID = in_ServerID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE serverID = in_ServerID;
  END IF;
  RETURN logCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `serverPortID_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `serverPortID_logs`(in_serverPortID INTEGER,
   in_Log VARCHAR(1)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logCount INTEGER DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'apache_logs', CATALOG_NAME = 'serverPortID_logs';
  IF in_Log = 'A' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.access_log
     WHERE serverPortID = in_serverPortID;
  ELSEIF in_Log = 'E' THEN
    SELECT COUNT(id)
      INTO logCount
      FROM apache_logs.error_log
     WHERE serverPortID = in_serverPortID;
  END IF;
  RETURN logCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `errorLoad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `errorLoad`(IN in_module VARCHAR(300),
     IN in_mysqlerrno VARCHAR(10),
     IN in_messagetext VARCHAR(1000), 
     IN in_loadID VARCHAR(10))
BEGIN
	DECLARE mysqlerrno INTEGER DEFAULT 0;
	DECLARE loadID INTEGER DEFAULT 0;
    IF NOT CONVERT(in_mysqlerrno, UNSIGNED) = 0 THEN
	    SET mysqlerrno = CONVERT(in_mysqlerrno, UNSIGNED);
    END IF;
    IF NOT CONVERT(in_loadID, UNSIGNED) = 0 THEN
	    SET loadID = CONVERT(in_loadID, UNSIGNED);
    END IF;
	INSERT INTO import_error 
			(module,
			mysql_errno,
			message_text,
      importloadid,
      schema_name)
		VALUES
			(in_module,
			mysqlerrno,
			in_messagetext,
      loadID,
      'logs2mysql.py');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `errorProcess` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `errorProcess`(IN in_module VARCHAR(300),
	 IN in_mysqlerrno INTEGER, 
   IN in_messagetext VARCHAR(1000), 
   IN in_returnedsqlstate VARCHAR(250), 
   IN in_schemaname VARCHAR(64),
   IN in_catalogname VARCHAR(64),
   IN in_loadID INTEGER,
   IN in_processID INTEGER)
BEGIN
	INSERT INTO import_error 
			(module,
			mysql_errno,
			message_text,
			returned_sqlstate,
			schema_name,
      catalog_name,
      importloadid,
      importprocessid)
		VALUES
			(in_module,
			in_mysqlerrno,
			in_messagetext,
			in_returnedsqlstate,
			in_schemaname,
			in_catalogname,
      in_loadID,
      in_processID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `normalize_client` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `normalize_client`(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
  DECLARE v_country_code VARCHAR(20) DEFAULT NULL;
  DECLARE v_country VARCHAR(150) DEFAULT NULL;
  DECLARE v_subdivision VARCHAR(250) DEFAULT NULL;
  DECLARE v_city VARCHAR(250) DEFAULT NULL;
  DECLARE v_latitude DECIMAL(10,8) DEFAULT NULL;
  DECLARE v_longitude DECIMAL(11,8) DEFAULT NULL;
  DECLARE v_organization VARCHAR(500) DEFAULT NULL;
  DECLARE v_network VARCHAR(100) DEFAULT NULL;
  DECLARE recid INTEGER DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
  DECLARE country_id,
          subdivision_id,
          city_id,
          coordinate_id,
          organization_id,
          network_id INTEGER DEFAULT NULL;
  -- declare cursor for log_client format
  DECLARE logClient CURSOR FOR 
      SELECT country_code,
             country,
             subdivision,
             city,
             latitude,
             longitude,
             organization,
             network,
             id
        FROM apache_logs.log_client
       WHERE countryid IS NULL;
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('normalize_client', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF LENGTH(in_processName) < 8 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be minimum of 8 characters';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  SET importProcessID = apache_logs.importProcessID('normalize_client', in_processName);
  OPEN logClient;
  START TRANSACTION;	
  process_normalize: LOOP
    FETCH logClient
     INTO v_country_code,
          v_country,
          v_subdivision,
          v_city,
          v_latitude,
          v_longitude,
          v_organization,
          v_network,
          recid;
    IF done = true THEN 
      LEAVE process_normalize;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    SET country_id = null,
        subdivision_id = null,
        city_id = null,
        coordinate_id = null,
        organization_id = null,
        network_id = null;
    -- normalize import staging table 
    IF v_country IS NOT NULL AND LENGTH(v_country) > 0 THEN
      SET country_id = apache_logs.log_clientCountryID(v_country, v_country_code);
    END IF;
    IF v_subdivision IS NOT NULL AND LENGTH(v_subdivision) > 0 THEN
      SET subdivision_id = apache_logs.log_clientSubdivisionID(v_subdivision);
    END IF;
    IF v_city IS NOT NULL AND LENGTH(v_city) > 0 THEN
      SET city_id = apache_logs.log_clientCityID(v_city);
    END IF;
    IF v_latitude IS NOT NULL AND LENGTH(v_latitude) > 0 THEN
      SET coordinate_id = apache_logs.log_clientCoordinateID(v_latitude, v_longitude);
    END IF;
    IF v_organization IS NOT NULL AND LENGTH(v_organization) > 0 THEN
      SET organization_id = apache_logs.log_clientOrganizationID(v_organization);
    END IF;
    IF v_network IS NOT NULL AND LENGTH(v_network) > 0 THEN
      SET network_id = apache_logs.log_clientNetworkID(v_network);
    END IF;
    UPDATE apache_logs.log_client
       SET countryid = country_id,
           subdivisionid = subdivision_id,
           cityid = city_id,
           coordinateid = coordinate_id,
           organizationid = organization_id,
           networkid = network_id
     WHERE id = recid;
  END LOOP;
  -- to remove SQL calculating filesProcessed when recordsProcessed = 0. Set=1 by default.
  IF recordsProcessed=0 THEN
    SET filesProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed,
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  -- close the cursor
  CLOSE logClient;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `normalize_useragent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `normalize_useragent`(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
	-- standard variables for processes
	DECLARE e1 INT UNSIGNED;
	DECLARE e2, e3 VARCHAR(128);
	DECLARE e4, e5 VARCHAR(64);
	DECLARE done BOOL DEFAULT false;
	DECLARE importProcessID INTEGER DEFAULT NULL;
	DECLARE importLoad_ID INTEGER DEFAULT NULL;
	DECLARE recordsProcessed INTEGER DEFAULT 0;
	DECLARE filesProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
	DECLARE v_ua VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_browser VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_browser_family VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_browser_version VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_os VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_os_family VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_os_version VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_device VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_device_family VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_device_brand VARCHAR(200) DEFAULT NULL;
	DECLARE v_ua_device_model VARCHAR(200) DEFAULT NULL;
	DECLARE userAgent_id INTEGER DEFAULT NULL;
	-- Primary IDs for the normalized Attribute tables
	DECLARE ua_id,
    uabrowser_id,
    uabrowserfamily_id,
    uabrowserversion_id,
    uaos_id,
    uaosfamily_id,
    uaosversion_id,
    uadevice_id,
    uadevicefamily_id,
    uadevicebrand_id,
    uadevicemodel_id INTEGER DEFAULT NULL;
	-- declare cursor for userAgent format
  DECLARE userAgent CURSOR FOR 
   SELECT ua,
         	ua_browser,
          ua_browser_family,
         	ua_browser_version,
          ua_os,
       	  ua_os_family,
          ua_os_version,
         	ua_device,
          ua_device_family,
         	ua_device_brand,
          ua_device_model,
          id
     FROM apache_logs.access_log_useragent
    WHERE uaid IS NULL;
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
 			CALL apache_logs.errorProcess('normalize_useragent', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
 			ROLLBACK;
		END;
	-- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF LENGTH(in_processName) < 8 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be minimum of 8 characters';
  END IF;
	IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
		SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
	END IF;
  SET importProcessID = apache_logs.importProcessID('normalize_useragent', in_processName);
	OPEN userAgent;
  START TRANSACTION;	
  process_normalize: LOOP
    FETCH userAgent
     INTO v_ua,
          v_ua_browser,
          v_ua_browser_family,
          v_ua_browser_version,
          v_ua_os,
          v_ua_os_family,
          v_ua_os_version,
          v_ua_device,
          v_ua_device_family,
          v_ua_device_brand,
          v_ua_device_model,
          userAgent_id;
    IF done = true THEN 
      LEAVE process_normalize;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    SET ua_id = null,
        uabrowser_id = null,
        uabrowserfamily_id = null,
        uabrowserversion_id = null,
        uaos_id = null,
        uaosfamily_id = null,
        uaosversion_id = null,
        uadevice_id = null,
        uadevicefamily_id = null,
        uadevicebrand_id = null,
        uadevicemodel_id = null;
        -- normalize import staging table 
    IF v_ua IS NOT NULL THEN
      SET ua_Id = apache_logs.access_uaID(v_ua);
    END IF;
    IF v_ua_browser IS NOT NULL THEN
      SET uabrowser_id = apache_logs.access_uaBrowserID(v_ua_browser);
    END IF;
    IF v_ua_browser_family IS NOT NULL THEN
      SET uabrowserfamily_id = apache_logs.access_uaBrowserFamilyID(v_ua_browser_family);
    END IF;
    IF v_ua_browser_version IS NOT NULL THEN
      SET uabrowserversion_id = apache_logs.access_uaBrowserVersionID(v_ua_browser_version);
    END IF;
    IF v_ua_os IS NOT NULL THEN
      SET uaos_id = apache_logs.access_uaOsID(v_ua_os);
    END IF;
    IF v_ua_os_family IS NOT NULL THEN
      SET uaosfamily_id = apache_logs.access_uaOsFamilyID(v_ua_os_family);
    END IF;
    IF v_ua_os_version IS NOT NULL THEN
      SET uaosversion_id = apache_logs.access_uaOsVersionID(v_ua_os_version);
    END IF;
    IF v_ua_device IS NOT NULL THEN
      SET uadevice_id = apache_logs.access_uaDeviceID(v_ua_device);
    END IF;
    IF v_ua_device_family IS NOT NULL THEN
      SET uadevicefamily_id = apache_logs.access_uaDeviceFamilyID(v_ua_device_family);
    END IF;
    IF v_ua_device_brand IS NOT NULL THEN
      SET uadevicebrand_id = apache_logs.access_uaDeviceBrandID(v_ua_device_brand);
    END IF;
    IF v_ua_device_model IS NOT NULL THEN
      SET uadevicemodel_id = apache_logs.access_uaDeviceModelID(v_ua_device_model);
    END IF;
    UPDATE apache_logs.access_log_useragent 
       SET uaid = ua_id,
           uabrowserid = uabrowser_id,
           uabrowserfamilyid = uabrowserfamily_id,
           uabrowserversionid = uabrowserversion_id,
           uaosid = uaos_id,
           uaosfamilyid = uaosfamily_id,
           uaosversionid = uaosversion_id,
           uadeviceid = uadevice_id,
           uadevicefamilyid = uadevicefamily_id,
           uadevicebrandid = uadevicebrand_id,
           uadevicemodelid = uadevicemodel_id
     WHERE id = userAgent_id;
  END LOOP;
  -- to remove SQL calculating filesProcessed when recordsProcessed = 0. Set=1 by default.
  IF recordsProcessed=0 THEN
    SET filesProcessed = 0;
  END IF;
  -- update import process table
	UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed,
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
	COMMIT;
    -- close the cursor
	CLOSE userAgent;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_access_import` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_access_import`(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
	DECLARE e1 INT UNSIGNED;
	DECLARE e2, e3 VARCHAR(128);
	DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFile_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
	DECLARE logTime VARCHAR(50) DEFAULT NULL;
	DECLARE logTimeConverted DATETIME DEFAULT now();
	DECLARE remoteLogName VARCHAR(150) DEFAULT NULL;
	DECLARE remoteUser VARCHAR(150) DEFAULT NULL;
	DECLARE bytesReceived INTEGER DEFAULT 0;
	DECLARE bytesSent INTEGER DEFAULT 0;
	DECLARE bytesTransferred INTEGER DEFAULT 0;
	DECLARE reqTimeMilli INTEGER DEFAULT 0;
	DECLARE reqTimeMicro INTEGER DEFAULT 0;
	DECLARE reqDelayMilli INTEGER DEFAULT 0;
	DECLARE reqBytes INTEGER DEFAULT 0;
	DECLARE reqStatus INTEGER DEFAULT 0;
	DECLARE reqProtocol VARCHAR(30) DEFAULT NULL;
	DECLARE reqMethod VARCHAR(50) DEFAULT NULL;
	DECLARE reqUri VARCHAR(2000) DEFAULT NULL;
	DECLARE reqQuery VARCHAR(2000) DEFAULT NULL;
	DECLARE reqQueryConverted VARCHAR(2000) DEFAULT NULL;
	DECLARE referer VARCHAR(1000) DEFAULT NULL;
	DECLARE refererConverted VARCHAR(2000) DEFAULT NULL;
	DECLARE userAgent VARCHAR(2000) DEFAULT NULL;
	DECLARE logCookie VARCHAR(400) DEFAULT NULL;
	DECLARE logCookieConverted VARCHAR(400) DEFAULT NULL;
	DECLARE client VARCHAR(253) DEFAULT NULL;
	DECLARE server VARCHAR(253) DEFAULT NULL;
	DECLARE serverPort INTEGER DEFAULT NULL;
	DECLARE serverFile VARCHAR(253) DEFAULT NULL;
	DECLARE serverPortFile INTEGER DEFAULT NULL;
	DECLARE requestLogID VARCHAR(50) DEFAULT NULL;
	DECLARE importFile VARCHAR(300) DEFAULT NULL;
  -- Primary IDs for the normalized Attribute tables
	DECLARE remoteLogName_Id, 
		remoteUser_Id, 
		reqStatus_Id, 
		reqProtocol_Id, 
		reqMethod_Id, 
		reqUri_Id, 
		reqQuery_Id, 
		referer_Id, 
		userAgent_Id, 
		logCookie_Id, 
		client_Id, 
		server_Id, 
		serverPort_Id, 
		requestLog_Id 
		INTEGER DEFAULT NULL;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
	DECLARE csv2mysqlStatus CURSOR FOR 
      SELECT l.remote_host, 
 		        l.remote_logname, 
    	  	  l.remote_user, 
		        l.log_time, 
		        l.bytes_received, 
      		  l.bytes_sent, 
	      	  l.bytes_transferred, 
		        l.reqtime_milli, 
    		    l.reqtime_micro, 
  	    	  l.reqdelay_milli, 
	  	      l.req_bytes, 
    		    l.req_status, 
		        l.req_protocol, 
  		      l.req_method, 
    	  	  l.req_uri, 
		        l.req_query, 
		        l.log_referer, 
      		  l.log_useragent,
	      	  l.log_cookie,
		        l.server_name, 
    		    l.server_port, 
            l.request_log_id, 
		        l.importfileid,
 	  	      f.server_name server_name_file, 
     		    f.server_port server_port_file, 
		        l.id 
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1;
  -- declare cursor for csv2mysql format - single importLoadID
	DECLARE csv2mysqlLoadID CURSOR FOR 
      SELECT l.remote_host, 
      		  l.remote_logname, 
	      	  l.remote_user, 
  		      l.log_time, 
	  	      l.bytes_received, 
    	  	  l.bytes_sent, 
	    	    l.bytes_transferred, 
		        l.reqtime_milli, 
    		    l.reqtime_micro, 
  		      l.reqdelay_milli, 
    	  	  l.req_bytes, 
    		    l.req_status, 
    		    l.req_protocol, 
      		  l.req_method, 
	      	  l.req_uri, 
		        l.req_query, 
    		    l.log_referer, 
      		  l.log_useragent,
	      	  l.log_cookie,
    		    l.server_name, 
    		    l.server_port, 
            l.request_log_id, 
		        l.importfileid,
 	  	      f.server_name server_name_file, 
     		    f.server_port server_port_file, 
    		    l.id 
  	    FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1;
  -- declare cursor for combined format - All importloadIDs not processed
	DECLARE vhostStatus CURSOR FOR 
      SELECT l.remote_host, 
    		    l.remote_logname, 
		        l.remote_user, 
      		  l.log_time, 
	      	  l.req_bytes, 
		        l.req_status, 
    		    l.req_protocol, 
  	    	  l.req_method, 
	  	      l.req_uri, 
    		    l.req_query, 
		        l.log_referer, 
  		      l.log_useragent,
	  	      l.server_name, 
    		    l.server_port, 
  	    	  l.importfileid,
 	  	      f.server_name server_name_file, 
     		    f.server_port server_port_file, 
	  	      l.id 
  	    FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1;
  -- declare cursor for combined format - single importLoadID
	DECLARE vhostLoadID CURSOR FOR 
      SELECT l.remote_host, 
    		    l.remote_logname, 
		        l.remote_user, 
      		  l.log_time, 
	      	  l.req_bytes, 
    		    l.req_status, 
		        l.req_protocol, 
  		      l.req_method, 
    	  	  l.req_uri, 
		        l.req_query, 
		        l.log_referer, 
      		  l.log_useragent,
	      	  l.server_name, 
		        l.server_port, 
      		  l.importfileid,
 	  	      f.server_name server_name_file, 
     		    f.server_port server_port_file, 
	      	  l.id 
	      FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1;
  -- declare cursor for combined format - All importloadIDs not processed
	DECLARE combinedStatus CURSOR FOR 
      SELECT l.remote_host, 
    		    l.remote_logname, 
  	    	  l.remote_user, 
    	  	  l.log_time, 
    		    l.req_bytes, 
    		    l.req_status, 
  	    	  l.req_protocol, 
    	  	  l.req_method, 
		        l.req_uri, 
		        l.req_query, 
      		  l.log_referer, 
    	  	  l.log_useragent,
	  	      l.server_name, 
    		    l.server_port, 
    		    l.importfileid,
 	  	      f.server_name server_name_file, 
     		    f.server_port server_port_file, 
		        l.id 
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status=1;
  -- declare cursor for combined format - single importLoadID
	DECLARE combinedLoadID CURSOR FOR 
      SELECT l.remote_host, 
    		    l.remote_logname, 
  	    	  l.remote_user, 
    	  	  l.log_time, 
    		    l.req_bytes, 
    		    l.req_status, 
  	    	  l.req_protocol, 
    	  	  l.req_method, 
		        l.req_uri, 
		        l.req_query, 
      		  l.log_referer, 
    	  	  l.log_useragent,
	  	      l.server_name, 
    		    l.server_port, 
    		    l.importfileid,
 	  	      f.server_name server_name_file, 
     		    f.server_port server_port_file, 
		        l.id 
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=1;
  -- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
 			CALL apache_logs.errorProcess('process_access_import', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
 			ROLLBACK;
		END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "csv2mysql,vhost,combined") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be csv2mysql, vhost OR combined';
  END IF;
	IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
		SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
	END IF;
	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_csv2mysql l
     WHERE l.process_status = 1;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_access_csv2mysql l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1;
	ELSEIF in_processName = 'csv2mysql' THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_csv2mysql l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1
       AND f.importloadid = importLoad_ID;
	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_vhost l
     WHERE l.process_status = 1;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_access_vhost l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1;
	ELSEIF in_processName = 'vhost' THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_vhost l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1
       AND f.importloadid = importLoad_ID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_combined l
     WHERE l.process_status = 1;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_access_combined l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1;
	ELSE
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_combined l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1
       AND f.importloadid = importLoad_ID;
	END IF;	
  SET importProcessID = apache_logs.importProcessID('access_import', in_processName);
	START TRANSACTION;
  -- open the cursor
	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
		OPEN csv2mysqlStatus;
	ELSEIF in_processName = 'csv2mysql' THEN
		OPEN csv2mysqlLoadID;
	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
		OPEN vhostStatus;
	ELSEIF in_processName = 'vhost' THEN
		OPEN vhostLoadID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
		OPEN combinedStatus;
	ELSE
		OPEN combinedLoadID;
	END IF;	
  process_import: LOOP
  	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
	  	FETCH csv2mysqlStatus INTO 
		  	client, 
			  remoteUser, 
  			remoteLogName, 
	  		logTime, 
		  	bytesReceived, 
			  bytesSent, 
  			bytesTransferred, 
	  		reqTimeMilli, 
		  	reqTimeMicro, 
	  		reqDelayMilli, 
  			reqBytes, 
		  	reqStatus, 
			  reqProtocol, 
  			reqMethod, 
	  		reqUri, 
		  	reqQuery, 
			  referer, 
  			userAgent,
	  		logCookie,
		  	server, 
			  serverPort, 
      	requestLogID, 
  			importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
	  ELSEIF in_processName = 'csv2mysql' THEN
		  FETCH csv2mysqlLoadID INTO 
  			client, 
	  		remoteUser, 
		  	remoteLogName, 
			  logTime, 
  			bytesReceived, 
	  		bytesSent, 
		  	bytesTransferred, 
			  reqTimeMilli, 
  			reqTimeMicro, 
	  		reqDelayMilli, 
		  	reqBytes, 
			  reqStatus, 
  			reqProtocol, 
	  		reqMethod, 
		  	reqUri, 
			  reqQuery, 
  			referer, 
	  		userAgent,
		  	logCookie,
			  server, 
  			serverPort, 
      	requestLogID, 
	  		importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
  	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
	  	FETCH vhostStatus INTO 
		  	client, 
  			remoteUser, 
	  		remoteLogName, 
		  	logTime, 
			  reqBytes, 
  			reqStatus, 
	  		reqProtocol, 
		  	reqMethod, 
			  reqUri, 
  			reqQuery, 
	  		referer, 
		  	userAgent,
			  server, 
  			serverPort, 
	  		importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
  	ELSEIF in_processName = 'vhost' THEN
	  	FETCH vhostLoadID INTO 
		  	client, 
			  remoteUser, 
  			remoteLogName, 
	  		logTime, 
		  	reqBytes, 
			  reqStatus, 
  			reqProtocol, 
	  		reqMethod, 
		  	reqUri, 
  			reqQuery, 
	  		referer, 
		  	userAgent,
			  server, 
  			serverPort, 
	  		importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
	  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
		  FETCH combinedStatus INTO 
  			client, 
	  		remoteUser, 
		  	remoteLogName, 
			  logTime, 
  			reqBytes, 
	  		reqStatus, 
		  	reqProtocol, 
			  reqMethod, 
  			reqUri, 
	  		reqQuery, 
		  	referer, 
			  userAgent,
			  server, 
  			serverPort, 
  			importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
	  ELSE
		  FETCH combinedLoadID INTO 
  			client, 
	  		remoteUser, 
		  	remoteLogName, 
			  logTime, 
  			reqBytes, 
	  		reqStatus, 
		  	reqProtocol, 
			  reqMethod, 
  			reqUri, 
	  		reqQuery, 
		  	referer, 
  			userAgent,
			  server, 
  			serverPort, 
	  		importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
  	END IF;	
		IF done = true THEN 
			LEAVE process_import;
		END IF;
		IF apache_logs.importFileCheck(importFile_ID, importProcessID, 'import') = 0 THEN
			ROLLBACK;
			LEAVE process_import;
    END IF;
		SET recordsProcessed = recordsProcessed + 1;
	  SET remoteLogName_Id = null, 
		    remoteUser_Id = null, 
		    reqStatus_Id = null, 
    		reqProtocol_Id = null, 
    		reqMethod_Id = null, 
		    reqUri_Id = null, 
		    reqQuery_Id = null, 
		    referer_Id = null, 
		    userAgent_Id = null, 
		    logCookie_Id = null, 
		    client_Id = null, 
		    server_Id = null, 
        serverPort_Id = null,
        requestLog_Id = null;
    -- any customizing for business needs should be done here before normalization functions called.
    -- convert import staging columns - reqQuery, referer, log_time and log_cookie in import for audit purposes
		IF LOCATE("?", reqQuery)>0 THEN
			SET reqQueryConverted = SUBSTR(reqQuery, LOCATE("?", reqQuery)+1);
		ELSE
			SET reqQueryConverted = reqQuery;
		END IF;
		IF LOCATE("?", referer)>0 THEN
			SET refererConverted = SUBSTR(referer,1,LOCATE("?", referer)-1);
		ELSE
			SET refererConverted = referer;
		END IF;
		IF LOCATE("[", logTime)>0 THEN
			SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime, 2, 20), '%d/%b/%Y:%H:%i:%s');
		ELSE
			SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime, 1, 20), '%d/%b/%Y:%H:%i:%s');
		END IF;
		IF logCookie IS NULL OR logCookie = '-' THEN
			SET logCookieConverted = NULL;
		ELSEIF LOCATE('.', logCookie) > 0 THEN
			SET logCookieConverted = SUBSTR(logCookie, 3, LOCATE('.', logCookie)-3);
    ELSE
			SET logCookieConverted = logCookie;
		END IF;
-- normalize import staging table 
		IF reqProtocol IS NOT NULL THEN
			SET reqProtocol_Id = apache_logs.access_reqProtocolID(reqProtocol);
    END IF;
		IF reqMethod IS NOT NULL THEN
			SET reqMethod_Id = apache_logs.access_reqMethodID(reqMethod);
    END IF;
		IF reqStatus IS NOT NULL THEN
			SET reqStatus_Id = apache_logs.access_reqStatusID(reqStatus);
    END IF;
		IF reqUri IS NOT NULL THEN
			SET reqUri_Id = apache_logs.access_reqUriID(reqUri);
    END IF;
		IF reqQueryConverted IS NOT NULL THEN
			SET reqQuery_Id = apache_logs.access_reqQueryID(reqQueryConverted);
    END IF;
		IF remoteLogName IS NOT NULL AND remoteLogName != '-' THEN
			SET remoteLogName_Id = apache_logs.access_remoteLogNameID(remoteLogName);
    END IF;
		IF remoteUser IS NOT NULL AND remoteUser != '-' THEN
			SET remoteUser_Id = apache_logs.access_remoteUserID(remoteUser);
    END IF;
		IF userAgent IS NOT NULL THEN
			SET userAgent_Id = apache_logs.access_userAgentID(userAgent);
    END IF;
		IF logCookieConverted IS NOT NULL THEN
			SET logCookie_Id = apache_logs.access_cookieID(logCookieConverted);
    END IF;
		IF refererConverted IS NOT NULL AND refererConverted != '-' THEN
			SET referer_Id = apache_logs.log_refererID(refererConverted);
    END IF;
		IF client IS NOT NULL THEN
			SET client_Id = apache_logs.log_clientID(client);
    END IF;
		IF server IS NOT NULL THEN
			SET server_Id = apache_logs.log_serverID(server);
		ELSEIF serverFile IS NOT NULL THEN
			SET server_Id = apache_logs.log_serverID(serverFile);
    END IF;
		IF serverPort IS NOT NULL THEN
			SET serverPort_Id = apache_logs.log_serverPortID(serverPort);
		ELSEIF serverPortFile IS NOT NULL THEN
			SET serverPort_Id = apache_logs.log_serverPortID(serverPortFile);
    END IF;
		IF requestLogID IS NOT NULL AND requestLogID != '-' THEN
  		IF server_Id IS NOT NULL THEN
        SET requestLogID = CONCAT(requestLogID, '_', CONVERT(server_Id, CHAR));
      END IF;
			SET requestLog_Id = apache_logs.log_requestLogID(requestLogID);
		END IF;
		INSERT INTO apache_logs.access_log 
      (logged, 
		  bytes_received,
		  bytes_sent,
		  bytes_transferred,
		  reqtime_milli,
		  reqtime_micro,
		  reqdelay_milli,
		  reqbytes,
  		reqstatusid, 
	  	reqprotocolid, 
		  reqmethodid, 
			requriid, 
  		reqqueryid, 
		  remotelognameid,
			remoteuserid, 
	  	useragentid,
		  cookieid,
  		refererid, 
	  	clientid,
			serverid, 
  		serverportid, 
      requestlogid, 
	  	importfileid) 
		VALUES
			(logTimeConverted,
			bytesReceived,
			bytesSent,
			bytesTransferred,
			reqTimeMilli,
			reqTimeMicro,
			reqDelayMilli,
			reqBytes,
			reqStatus_Id,
			reqProtocol_Id,
			reqMethod_Id,
			reqUri_Id,
			reqQuery_Id,
			remoteLogName_Id,
			remoteUser_Id,
			userAgent_Id,
			logCookie_Id,
			referer_Id,
			client_Id,
			server_Id, 
			serverPort_Id, 
			requestLog_Id, 
			importFile_ID);
		IF in_processName = 'csv2mysql' THEN
			UPDATE apache_logs.load_access_csv2mysql SET process_status=2 WHERE id=importRecordID;
		ELSEIF in_processName = 'vhost' THEN
			UPDATE apache_logs.load_access_vhost SET process_status=2 WHERE id=importRecordID;
		ELSE
			UPDATE apache_logs.load_access_combined SET process_status=2 WHERE id=importRecordID;
		END IF;	
	END LOOP;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed, 
         importloadid = importLoad_ID, 
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
	COMMIT;
  -- close the cursor
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
		CLOSE csv2mysqlStatus;
	ELSEIF in_processName = 'csv2mysql' THEN
		CLOSE csv2mysqlLoadID;
	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
		CLOSE vhostStatus;
	ELSEIF in_processName = 'vhost' THEN
		CLOSE vhostLoadID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
		CLOSE combinedStatus;
	ELSE
		CLOSE combinedLoadID;
	END IF;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_access_parse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_access_parse`(
    IN in_processName VARCHAR(100),
    IN in_importLoadID VARCHAR(20)
)
BEGIN
  -- standard variables for processes
	DECLARE e1 INT UNSIGNED;
	DECLARE e2, e3 VARCHAR(128);
	DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFile_ID INTEGER DEFAULT NULL;
  DECLARE importFile_common_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- declare cursor for csv2mysql format - All importloadIDs not processed
	DECLARE csv2mysqlStatus CURSOR FOR 
      SELECT l.id,
             l.importfileid
        FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  -- declare cursor for csv2mysql format - single importLoadID
	DECLARE csv2mysqlLoadID CURSOR FOR 
      SELECT l.id,
             l.importfileid
  	    FROM apache_logs.load_access_csv2mysql l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0;
  -- declare cursor for combined format - All importloadIDs not processed
	DECLARE vhostStatus CURSOR FOR 
      SELECT l.id,
             l.importfileid
  	    FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  -- declare cursor for combined format - single importLoadID
	DECLARE vhostLoadID CURSOR FOR 
      SELECT l.id,
             l.importfileid
	      FROM apache_logs.load_access_vhost l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0;
  -- declare cursor for combined format - All importloadIDs not processed
	DECLARE combinedStatus CURSOR FOR 
      SELECT l.id,
             l.importfileid
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  -- declare cursor for importformatid SET=2 in Python check if common format
	DECLARE commonStatus CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0
         AND l.log_useragent IS NULL;
  -- declare cursor for combined format - single importLoadID
	DECLARE combinedLoadID CURSOR FOR 
      SELECT l.id,
             l.importfileid
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status=0;
  -- declare cursor for importformatid SET=2 in Python check if common format
	DECLARE commonLoadID CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_access_combined l
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = importLoad_ID
         AND l.process_status = 0
         AND l.log_useragent IS NULL;
  -- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
			GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
 			CALL apache_logs.errorProcess('process_access_parse', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
 			ROLLBACK;
		END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "csv2mysql,vhost,combined") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be csv2mysql, vhost OR combined';
  END IF;
	IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
		SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
	END IF;
	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_csv2mysql l
INNER JOIN apache_logs.import_file f
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_access_csv2mysql l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
	ELSEIF in_processName = 'csv2mysql' THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_csv2mysql l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE f.importloadid = importLoad_ID
       AND l.process_status = 0;
	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_vhost l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_access_vhost l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
	ELSEIF in_processName = 'vhost' THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_vhost l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE f.importloadid = importLoad_ID
       AND l.process_status = 0;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_combined l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_access_combined l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
	ELSE
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_access_combined l
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE f.importloadid = importLoad_ID
       AND l.process_status = 0;
	END IF;	
  SET importProcessID = apache_logs.importProcessID('access_parse', in_processName);
	START TRANSACTION;
	IF in_processName = 'combined' THEN 
    -- importformatid SET=2 in Python check if common format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    IF importLoad_ID IS NULL THEN
      OPEN commonStatus;
    ELSE
      OPEN commonLoadID;
	  END IF;	
    set_commonformat: LOOP
      IF importLoad_ID IS NULL THEN
        FETCH commonStatus INTO importFile_common_ID;
      ELSE
        FETCH commonLoadID INTO importFile_common_ID;
      END IF;
      IF done = true THEN 
        LEAVE set_commonformat;
      END IF;
      UPDATE apache_logs.import_file 
         SET importformatid=1 
       WHERE id = importFile_common_ID;
    END LOOP;
    IF importLoad_ID IS NULL THEN
      CLOSE commonStatus;
    ELSE
      CLOSE commonLoadID;
	  END IF;
    SET done = false;
	END IF;	
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
    OPEN csv2mysqlStatus;
  ELSEIF in_processName = 'csv2mysql' THEN
    OPEN csv2mysqlLoadID;
  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
    OPEN vhostStatus;
	ELSEIF in_processName = 'vhost' THEN
    OPEN vhostLoadID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
    OPEN combinedStatus;
	ELSE
    OPEN combinedLoadID;
  END IF;	
  process_parse: LOOP
  	IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
	  	FETCH csv2mysqlStatus INTO importRecordID, importFile_ID;
	  ELSEIF in_processName = 'csv2mysql' THEN
		  FETCH csv2mysqlLoadID INTO importRecordID, importFile_ID;
	  ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
		  FETCH vhostStatus INTO importRecordID, importFile_ID;
  	ELSEIF in_processName = 'vhost' THEN
	  	FETCH vhostLoadID INTO importRecordID, importFile_ID;
	  ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
  		FETCH combinedStatus INTO importRecordID, importFile_ID;
	  ELSE
		  FETCH combinedLoadID INTO importRecordID, importFile_ID;
  END IF;	
	IF done = true THEN 
			LEAVE process_parse;
		END IF;
		IF apache_logs.importFileCheck(importFile_ID, importProcessID, 'parse') = 0 THEN
			ROLLBACK;
			LEAVE process_parse;
    END IF;
		SET recordsProcessed = recordsProcessed + 1;
    -- IF in_processName = 'csv2mysql' THEN
    -- by default, no parsing required for csv2mysql format 
    IF in_processName = 'vhost' THEN
      UPDATE apache_logs.load_access_vhost 
      SET server_name = SUBSTR(log_server, 1, LOCATE(':', log_server)-1) 
      WHERE id=importRecordID AND LOCATE(':', log_server)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET server_port = SUBSTR(log_server, LOCATE(':', log_server)+1) 
      WHERE id=importRecordID AND LOCATE(':', log_server)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET req_method = SUBSTR(first_line_request, 1, LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_uri = SUBSTR(first_line_request,LOCATE(' ', first_line_request)+1,LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)-LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = SUBSTR(first_line_request, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_query = SUBSTR(req_uri, LOCATE('?', req_uri)) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET req_uri = SUBSTR(req_uri, 1, LOCATE('?', req_uri)-1) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) NOT RLIKE '^[A-Z]|-';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^-';
      
      UPDATE apache_logs.load_access_vhost 
      SET req_protocol = TRIM(req_protocol)
      WHERE id=importRecordID;
      
      UPDATE apache_logs.load_access_vhost 
      SET log_time = CONCAT(log_time_a, ' ', log_time_b)
      WHERE id=importRecordID;

    ELSEIF in_processName = 'combined' THEN
      UPDATE apache_logs.load_access_combined 
      SET req_method = SUBSTR(first_line_request, 1, LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_combined 
      SET req_uri = SUBSTR(first_line_request, LOCATE(' ', first_line_request)+1, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)-LOCATE(' ', first_line_request)-1) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = SUBSTR(first_line_request, LOCATE(' ', first_line_request, LOCATE(' ', first_line_request)+1)) 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^[A-Z]';
      
      UPDATE apache_logs.load_access_combined 
      SET req_query = SUBSTR(req_uri,LOCATE('?', req_uri)) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_combined 
      SET req_uri = SUBSTR(req_uri, 1, LOCATE('?', req_uri)-1) 
      WHERE id=importRecordID AND LOCATE('?', req_uri)>0;
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = 'Invalid Request', req_method = 'Invalid Request', req_uri = 'Invalid Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) NOT RLIKE '^[A-Z]|-';
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = 'Empty Request', req_method = 'Empty Request', req_uri = 'Empty Request' 
      WHERE id=importRecordID AND LEFT(first_line_request, 1) RLIKE '^-';
      
      UPDATE apache_logs.load_access_combined 
      SET req_protocol = TRIM(req_protocol) 
      WHERE id=importRecordID;
      
      UPDATE apache_logs.load_access_combined 
      SET log_time = CONCAT(log_time_a, ' ', log_time_b) 
      WHERE id=importRecordID;
    END IF;
		IF in_processName = 'csv2mysql' THEN
			UPDATE apache_logs.load_access_csv2mysql SET process_status=1 WHERE id=importRecordID;
		ELSEIF in_processName = 'vhost' THEN
			UPDATE apache_logs.load_access_vhost SET process_status=1 WHERE id=importRecordID;
		ELSE
			UPDATE apache_logs.load_access_combined SET process_status=1 WHERE id=importRecordID;
		END IF;	
	END LOOP;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
 	UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed, 
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  -- close the cursor
  IF in_processName = 'csv2mysql' AND importLoad_ID IS NULL THEN
		CLOSE csv2mysqlStatus;
	ELSEIF in_processName = 'csv2mysql' THEN
		CLOSE csv2mysqlLoadID;
	ELSEIF in_processName = 'vhost' AND importLoad_ID IS NULL THEN
		CLOSE vhostStatus;
	ELSEIF in_processName = 'vhost' THEN
		CLOSE vhostLoadID;
	ELSEIF in_processName = 'combined' AND importLoad_ID IS NULL THEN
		CLOSE combinedStatus;
	ELSE
		CLOSE combinedLoadID;
	END IF;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_error_import` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_error_import`(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
	-- standard variables for processes
	DECLARE e1 INT UNSIGNED;
	DECLARE e2, e3 VARCHAR(128);
	DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFile_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
  -- LOAD DATA staging table column variables
	DECLARE log_time DATETIME DEFAULT now();
	DECLARE log_level VARCHAR(100) DEFAULT NULL;
	DECLARE log_module VARCHAR(100) DEFAULT NULL;
	DECLARE log_processid VARCHAR(100) DEFAULT NULL;
	DECLARE log_threadid VARCHAR(100) DEFAULT NULL;
	DECLARE log_apacheCode VARCHAR(400) DEFAULT NULL;
	DECLARE log_apacheMessage VARCHAR(400) DEFAULT NULL;
	DECLARE log_systemCode VARCHAR(400) DEFAULT NULL;
	DECLARE log_systemMessage VARCHAR(400) DEFAULT NULL;
	DECLARE log_message VARCHAR(500) DEFAULT NULL;
	DECLARE log_referer VARCHAR(1000) DEFAULT NULL;
	DECLARE refererConverted VARCHAR(1000) DEFAULT NULL;
	DECLARE client VARCHAR(253) DEFAULT NULL;
	DECLARE clientPort VARCHAR(100) DEFAULT NULL;
	DECLARE server VARCHAR(253) DEFAULT NULL;
	DECLARE serverPort INTEGER DEFAULT NULL;
	DECLARE requestLogID VARCHAR(50) DEFAULT NULL;
	DECLARE serverFile VARCHAR(253) DEFAULT NULL;
	DECLARE serverPortFile INTEGER DEFAULT NULL;
	DECLARE importFile VARCHAR(300) DEFAULT NULL;
	-- Primary IDs for the normalized Attribute tables
	DECLARE logLevel_Id,
		module_Id,
		process_Id, 
		thread_Id, 
		apacheCode_Id, 
		apacheMessage_Id, 
		systemCode_Id, 
		systemMessage_Id, 
		logMessage_Id, 
		referer_Id,
		client_Id, 
		clientPort_Id, 
 		server_Id, 
		serverPort_Id, 
		requestLog_Id 
		INTEGER DEFAULT NULL;
	-- declare cursor for default format - single importLoadID
  DECLARE defaultByLoadID CURSOR FOR 
      SELECT l.logtime, 
             l.loglevel, 
             l.module, 
             l.processid, 
             l.threadid, 
             l.apachecode, 
             l.apachemessage, 
             l.systemcode, 
             l.systemmessage, 
             l.logmessage, 
             l.referer,
             l.client_name, 
             l.client_port, 
             l.server_name, 
             l.server_port, 
             l.request_log_id, 
             l.importfileid,
             f.server_name server_name_file, 
             f.server_port server_port_file, 
             l.id
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE l.process_status = 1
         AND f.importloadid = CONVERT(in_importLoadID, UNSIGNED);
DECLARE defaultByStatus CURSOR FOR 
     SELECT l.logtime, 
            l.loglevel, 
            l.module, 
            l.processid, 
            l.threadid, 
            l.apachecode, 
            l.apachemessage, 
            l.systemcode, 
            l.systemmessage, 
            l.logmessage, 
            l.referer,
            l.client_name, 
            l.client_port, 
            l.server_name, 
            l.server_port, 
            l.request_log_id, 
            l.importfileid,
            f.server_name server_name_file, 
            f.server_port server_port_file, 
            l.id
       FROM apache_logs.load_error_default l 
 INNER JOIN apache_logs.import_file f 
         ON l.importfileid = f.id
      WHERE l.process_status = 1;
  -- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
 			CALL apache_logs.errorProcess('process_error_import', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
 			ROLLBACK;
		END;
  -- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "default") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be default';
  END IF;
	IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
		SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
	END IF;
  IF importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_error_default l 
     WHERE l.process_status = 1;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1;
  ELSE
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE l.process_status = 1
       AND f.importloadid = importLoad_ID;
  END IF;
  SET importProcessID = apache_logs.importProcessID('error_import', in_processName);
	START TRANSACTION;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatus;
  ELSE
  	OPEN defaultByLoadID;
  END IF;
  process_import: LOOP
    IF importLoad_ID IS NULL THEN
		  FETCH defaultByStatus INTO 
  			log_time, 
	  		log_level,
		  	log_module,
			  log_processid, 
  			log_threadid, 
	  		log_apacheCode, 
		  	log_apacheMessage, 
			  log_systemCode, 
  			log_systemMessage, 
	  		log_message, 
			  log_referer, 
		  	client, 
		  	clientPort, 
		  	server, 
			  serverPort, 
			  requestLogID, 
			  importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
    ELSE
		  FETCH defaultByLoadID INTO 
  			log_time, 
	  		log_level,
		  	log_module,
			  log_processid, 
			  log_threadid, 
			  log_apacheCode, 
			  log_apacheMessage, 
  			log_systemCode, 
	  		log_systemMessage, 
		  	log_message, 
			  log_referer, 
		  	client, 
		  	clientPort, 
		  	server, 
			  serverPort, 
			  requestLogID, 
		  	importFile_ID,
		  	serverFile, 
			  serverPortFile, 
        importRecordID; 
    END IF;
    IF done = true THEN 
		  LEAVE process_import;
    END IF;
    IF apache_logs.importFileCheck(importFile_ID, importProcessID, 'import') = 0 THEN
  		ROLLBACK;
			LEAVE process_import;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
		SET logLevel_Id = null,
    		module_Id = null,
    		process_Id = null, 
    		thread_Id = null, 
    		apacheCode_Id = null, 
    		apacheMessage_Id = null, 
    		systemCode_Id = null, 
    		systemMessage_Id = null, 
    		logMessage_Id = null, 
    		referer_Id = null,
        client_Id = null, 
        clientPort_Id = null, 
        server_Id = null, 
        serverPort_Id = null,
        requestLog_Id = null;
		-- any customizing for business needs should be done here before normalization functions called.
    -- convert staging columns - log_referer in import for audit purposes
		IF LOCATE("?", log_referer)>0 THEN
			SET refererConverted = SUBSTR(log_referer, 1, LOCATE("?", log_referer)-1);
		ELSE
			SET refererConverted = log_referer;
		END IF;
    -- normalize import staging table 
		IF log_level IS NOT NULL THEN
			SET logLevel_Id = apache_logs.error_logLevelID(log_level);
		END IF;
		IF log_module IS NOT NULL THEN
			SET module_Id = apache_logs.error_moduleID(log_module);
		END IF;
		IF log_processid IS NOT NULL THEN
			SET process_Id = apache_logs.error_processID(log_processid);
		END IF;
		IF log_threadid IS NOT NULL THEN
			SET thread_Id = apache_logs.error_threadID(log_threadid);
		END IF;
		IF log_apacheCode IS NOT NULL THEN
			SET apacheCode_Id = apache_logs.error_apacheCodeID(log_apacheCode);
		END IF;
		IF log_apacheMessage IS NOT NULL THEN
			SET apacheMessage_Id = apache_logs.error_apacheMessageID(log_apacheMessage);
		END IF;
		IF log_systemCode IS NOT NULL THEN
			SET systemCode_Id = apache_logs.error_systemCodeID(log_systemCode);
		END IF;
		IF log_systemMessage IS NOT NULL THEN
			SET systemMessage_Id = apache_logs.error_systemMessageID(log_systemMessage);
		END IF;
		IF log_message IS NOT NULL THEN
			SET logMessage_id = apache_logs.error_logMessageID(log_message);
		END IF;
		IF refererConverted IS NOT NULL AND refererConverted != '-' THEN
			SET referer_Id = apache_logs.log_refererID(refererConverted);
		END IF;
		IF client IS NOT NULL THEN
			SET client_id = apache_logs.log_clientID(client);
		END IF;
		IF clientPort IS NOT NULL THEN
			SET clientPort_id = apache_logs.log_clientPortID(clientPort);
		END IF;
		IF server IS NOT NULL THEN
			SET server_Id = apache_logs.log_serverID(server);
		ELSEIF serverFile IS NOT NULL THEN
			SET server_Id = apache_logs.log_serverID(serverFile);
    END IF;
		IF serverPort IS NOT NULL THEN
			SET serverPort_Id = apache_logs.log_serverPortID(serverPort);
		ELSEIF serverPortFile IS NOT NULL THEN
			SET serverPort_Id = apache_logs.log_serverPortID(serverPortFile);
    END IF;
		IF requestLogID IS NOT NULL AND requestLogID != '-' THEN
  		IF server_Id IS NOT NULL THEN
        SET requestLogID = CONCAT(requestLogID, '_', CONVERT(server_Id, CHAR));
      END IF;
			SET requestLog_Id = apache_logs.log_requestLogID(requestLogID);
		END IF;
		INSERT INTO apache_logs.error_log 
			(logged, 
			loglevelid,
			moduleid,
			processid, 
			threadid, 
			apachecodeid, 
			apachemessageid, 
			systemcodeid, 
			systemmessageid, 
			logmessageid, 
			refererid,
			clientid, 
			clientportid, 
			serverid, 
  		serverportid,
      requestlogid, 
      importfileid) 
		VALUES
			(log_time,
			logLevel_Id,
			module_Id,
			process_Id, 
			thread_Id, 
			apacheCode_Id, 
			apacheMessage_Id, 
			systemCode_Id, 
			systemMessage_Id, 
			logMessage_Id, 
			referer_Id,
			client_Id, 
			clientPort_Id, 
			server_Id, 
			serverPort_Id, 
			requestLog_Id, 
      importFile_ID);
    UPDATE apache_logs.load_error_default SET process_status=2 WHERE id=importRecordID;
  END LOOP;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed,
         importloadid = importLoad_ID, 
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  -- close the cursor
  IF importLoad_ID IS NULL THEN
    CLOSE defaultByStatus;
  ELSE
    CLOSE defaultByLoadID;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_error_parse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_error_parse`(
  IN in_processName VARCHAR(100),
  IN in_importLoadID VARCHAR(20)
)
BEGIN
	-- standard variables for processes
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE e4, e5 VARCHAR(64);
  DECLARE done BOOL DEFAULT false;
  DECLARE importProcessID INTEGER DEFAULT NULL;
  DECLARE importLoad_ID INTEGER DEFAULT NULL;
  DECLARE importRecordID INTEGER DEFAULT NULL;
  DECLARE importFile_ID INTEGER DEFAULT NULL;
  DECLARE importFile_vhost_ID INTEGER DEFAULT NULL;
  DECLARE recordsProcessed INTEGER DEFAULT 0;
  DECLARE filesProcessed INTEGER DEFAULT 0;
  DECLARE loadsProcessed INTEGER DEFAULT 1;
  DECLARE processError INTEGER DEFAULT 0;
	-- declare cursor for default format - single importLoadID
  DECLARE defaultByLoadID CURSOR FOR 
      SELECT l.id,
             l.importfileid
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status = 0;
  DECLARE defaultByStatus CURSOR FOR 
      SELECT l.id,
             l.importfileid
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0;
  DECLARE vhostByLoadID CURSOR FOR 
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
       WHERE f.importloadid = CONVERT(in_importLoadID, UNSIGNED)
         AND l.process_status = 0
         AND LOCATE(' ,', l.log_parse1)>0 OR LOCATE(' ,', l.log_parse2)>0;
  DECLARE vhostByStatus CURSOR FOR
      SELECT DISTINCT(l.importfileid)
        FROM apache_logs.load_error_default l 
  INNER JOIN apache_logs.import_file f 
          ON l.importfileid = f.id
  INNER JOIN apache_logs.import_load il 
          ON f.importloadid = il.id
       WHERE il.completed IS NOT NULL 
         AND l.process_status = 0
         AND LOCATE(' ,', l.log_parse1)>0 OR LOCATE(' ,', l.log_parse2)>0;
	-- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
      GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE, e4 = SCHEMA_NAME, e5 = CATALOG_NAME; 
      CALL apache_logs.errorProcess('process_error_parse', e1, e2, e3, e4, e5, importLoad_ID, importProcessID);
      SET processError = processError + 1;
      ROLLBACK;
    END;
	-- check parameters for valid values
  IF CONVERT(in_importLoadID, UNSIGNED) = 0 AND in_importLoadID != 'ALL' THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_importLoadID. Must be convert to number or be ALL';
  END IF;
  IF FIND_IN_SET(in_processName, "default") = 0 THEN
    SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid parameter value for in_processName. Must be default';
  END IF;
  IF NOT CONVERT(in_importLoadID, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importLoadID, UNSIGNED);
  END IF;
  IF importLoad_ID IS NULL THEN
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
    SELECT COUNT(DISTINCT(f.importloadid))
      INTO loadsProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
INNER JOIN apache_logs.import_load il 
        ON f.importloadid = il.id
     WHERE il.completed IS NOT NULL 
       AND l.process_status = 0;
  ELSE
    SELECT COUNT(DISTINCT(l.importfileid))
      INTO filesProcessed
      FROM apache_logs.load_error_default l 
INNER JOIN apache_logs.import_file f 
        ON l.importfileid = f.id
     WHERE f.importloadid = importLoad_ID
       AND l.process_status = 0;
  END IF;
  SET importProcessID = apache_logs.importProcessID('error_parse', in_processName);
  START TRANSACTION;
  IF importLoad_ID IS NULL THEN
    -- importformatid SET=5 in Python check if error_vhost format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    OPEN vhostByStatus;
  ELSE
    -- importformatid SET=5 in Python check if error_vhost format - 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost'
    OPEN vhostByLoadID;
  END IF;
  set_vhostformat: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH vhostByStatus INTO importFile_vhost_ID;
    ELSE
      FETCH vhostByLoadID INTO importFile_vhost_ID;
    END IF;
    IF done = true THEN 
      LEAVE set_vhostformat;
    END IF;
    UPDATE apache_logs.import_file 
       SET importformatid=6 
     WHERE id = importFile_vhost_ID;
  END LOOP;
  IF importLoad_ID IS NULL THEN
    CLOSE vhostByStatus;
  ELSE
    CLOSE vhostByLoadID;
  END IF;
  SET done = false;
  IF importLoad_ID IS NULL THEN
    OPEN defaultByStatus;
  ELSE
    OPEN defaultByLoadID;
  END IF;
  process_parse: LOOP
    IF importLoad_ID IS NULL THEN
      FETCH defaultByStatus INTO importRecordID, importFile_ID;
    ELSE
      FETCH defaultByLoadID INTO importRecordID, importFile_ID;
    END IF;
    IF done = true THEN 
      LEAVE process_parse;
    END IF;
    IF apache_logs.importFileCheck(importFile_ID, importProcessID, 'parse') = 0 THEN
      ROLLBACK;
      LEAVE process_parse;
    END IF;
    SET recordsProcessed = recordsProcessed + 1;
    UPDATE apache_logs.load_error_default 
       SET module = SUBSTR(log_mod_level,3, LOCATE(':', log_mod_level)-3),
           loglevel = SUBSTR(log_mod_level, LOCATE(':', log_mod_level)+1),
           processid = SUBSTR(log_processid_threadid, LOCATE('pid', log_processid_threadid)+4, LOCATE(':', log_processid_threadid)-LOCATE('pid', log_processid_threadid)-4),
           threadid = SUBSTR(log_processid_threadid, LOCATE('tid', log_processid_threadid)+4),
           logtime = STR_TO_DATE(SUBSTR(log_time, 2, 31),'%a %b %d %H:%i:%s.%f %Y')
     WHERE id = importRecordID;

    UPDATE apache_logs.load_error_default 
       SET apachecode = SUBSTR(log_parse1, 2, LOCATE(':', log_parse1)-2) 
     WHERE id = importRecordID AND LEFT(log_parse1, 2)=' A';
    UPDATE apache_logs.load_error_default 
       SET apachecode = SUBSTR(log_parse2, 2, LOCATE(':', log_parse2)-2) 
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A';
    UPDATE apache_logs.load_error_default 
       SET apachecode = SUBSTR(log_parse1, LOCATE(': AH', log_parse1)+2, LOCATE(':', log_parse1, (LOCATE(': AH', log_parse1)+2))-LOCATE(': AH', log_parse1)-2) 
     WHERE id = importRecordID AND LOCATE(': AH', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse1, LOCATE(':', log_parse1)+1) 
     WHERE id = importRecordID AND LEFT(log_parse1, 2)=' A';
    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse2, LOCATE(':', log_parse2)+1) 
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A' AND LOCATE('referer:', log_parse2)=0;
    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse2, LOCATE(':', log_parse2)+1, LOCATE(', referer:', log_parse2)-LOCATE(':', log_parse2)-1) 
     WHERE id = importRecordID AND LEFT(log_parse2, 2)=' A' AND LOCATE(', referer:', log_parse2)>0;
    UPDATE apache_logs.load_error_default 
       SET apachemessage = SUBSTR(log_parse1, LOCATE(':', log_parse1, LOCATE(': AH', log_parse1)+2)+2) 
     WHERE id = importRecordID AND LOCATE(': AH', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET client_name = SUBSTR(log_parse1, LOCATE('[client', log_parse1)+8) 
     WHERE id = importRecordID AND LOCATE('[client', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET client_port = SUBSTR(client_name, LOCATE(':', client_name)+1) 
     WHERE id = importRecordID AND LOCATE(':', client_name)>0;

    UPDATE apache_logs.load_error_default 
       SET client_name = SUBSTR(client_name, 1, LOCATE(':', client_name)-1) 
     WHERE id = importRecordID AND LOCATE(':', client_name)>0;

    UPDATE apache_logs.load_error_default 
       SET systemcode = SUBSTR(log_parse1, LOCATE('(', log_parse1), LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)) 
     WHERE id = importRecordID AND LOCATE('(', log_parse1)>0 AND LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)>0;

    UPDATE apache_logs.load_error_default 
       SET systemmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1) + 1) 
     WHERE id = importRecordID AND LOCATE('(', log_parse1)>0 AND LOCATE(':', log_parse1, LOCATE('(', log_parse1))-LOCATE('(', log_parse1)>0 AND apachecode IS NULL;

    UPDATE apache_logs.load_error_default 
       SET log_message_nocode = log_parse1 
     WHERE id = importRecordID AND systemcode IS NULL AND apachecode IS NULL;

    UPDATE apache_logs.load_error_default 
       SET module = SUBSTR(log_parse1, 2, LOCATE(':', log_parse1)-2) 
     WHERE id = importRecordID AND systemcode IS NULL AND apachecode IS NULL AND LENGTH(module)=0 AND LOCATE(':', log_parse1)>0 AND LOCATE(' ', log_parse1, 2)>LOCATE(':', log_parse1);

    UPDATE apache_logs.load_error_default 
       SET logmessage = SUBSTR(log_parse1, LOCATE(':', log_parse1)+1) 
     WHERE id = importRecordID AND systemcode IS NULL AND apachecode IS NULL AND LOCATE(':', log_parse1)>0 AND LOCATE(' ', log_parse1,2)>LOCATE(':', log_parse1);

    UPDATE apache_logs.load_error_default 
       SET logmessage = log_message_nocode 
     WHERE id = importRecordID AND logmessage IS NULL AND log_message_nocode IS NOT NULL;

    UPDATE apache_logs.load_error_default 
       SET referer = SUBSTR(log_parse2, LOCATE('referer:', log_parse2)+8) 
     WHERE id = importRecordID AND LOCATE('referer:', log_parse2)>0;

    -- 12/07/2024 @ 4:55AM - server_name and request_log_id parsing - if either exists
    -- referer
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(referer,LOCATE(' ,', referer, LOCATE(' ,', referer)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', referer, LOCATE(' ,', referer)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2, LOCATE(' ,',referer, LOCATE(' ,',referer)+2)-LOCATE(' ,', referer)-2) 
     WHERE id = importRecordID AND LOCATE(' ,', referer, LOCATE(' ,',referer)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', referer)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(referer, LOCATE(' ,',referer)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', referer)>0 AND LOCATE(' ,', referer, LOCATE(' ,',referer)+2)=0;

    UPDATE apache_logs.load_error_default 
       SET referer=SUBSTR(referer, 1, LOCATE(' ,', referer)) 
     WHERE id = importRecordID AND LOCATE(' ,', referer)>0;
    -- logmessage
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(logmessage, LOCATE(' ,', logmessage, LOCATE(' ,',logmessage)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,',logmessage)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(logmessage, LOCATE(' ,',logmessage)+2, LOCATE(' ,',logmessage,LOCATE(' ,',logmessage)+2)-LOCATE(' ,',logmessage)-2) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,', logmessage)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(logmessage, LOCATE(' ,', logmessage)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', logmessage)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(logmessage, LOCATE(' ,', logmessage)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage, LOCATE(' ,', logmessage)+2)=0 AND LOCATE(' ,', logmessage)>0;

    UPDATE apache_logs.load_error_default 
       SET logmessage=SUBSTR(logmessage, 1, LOCATE(' ,', logmessage)) 
     WHERE id = importRecordID AND LOCATE(' ,', logmessage)>0;
    -- systemmessage
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(systemmessage, LOCATE(' ,', systemmessage, LOCATE(' ,',systemmessage)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', systemmessage, LOCATE(' ,', systemmessage)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2, LOCATE(' ,',systemmessage,LOCATE(' ,',systemmessage)+2)-LOCATE(' ,',systemmessage)-2) 
     WHERE id = importRecordID AND LOCATE(' ,',systemmessage, LOCATE(' ,', systemmessage)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', systemmessage)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(systemmessage, LOCATE(' ,', systemmessage)+2) 
     WHERE id = importRecordID AND LOCATE(' ,',systemmessage, LOCATE(' ,', systemmessage)+2)=0 AND LOCATE(' ,', systemmessage)>0;

    UPDATE apache_logs.load_error_default 
       SET systemmessage=SUBSTR(systemmessage, 1, LOCATE(' ,', systemmessage)) 
     WHERE id = importRecordID AND LOCATE(' ,', systemmessage)>0;
    -- apachemessage
    UPDATE apache_logs.load_error_default 
       SET request_log_ID=SUBSTR(apachemessage, LOCATE(' ,', apachemessage, LOCATE(' ,',apachemessage)+2)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)>0;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(apachemessage, LOCATE(' ,', apachemessage)+2, LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)-LOCATE(' ,', apachemessage)-2) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)>0;

--    UPDATE apache_logs.load_error_default 
--       SET server_name=SUBSTR(apachemessage, LOCATE(' ,', apachemessage)+2) 
--     WHERE id = importRecordID AND LOCATE(' ,', apachemessage)>0 AND server_name IS NULL;

    UPDATE apache_logs.load_error_default 
       SET server_name=SUBSTR(apachemessage, LOCATE(' ,', apachemessage)+2) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage, LOCATE(' ,', apachemessage)+2)=0 AND LOCATE(' ,', apachemessage)>0;

    UPDATE apache_logs.load_error_default 
       SET apachemessage=SUBSTR(apachemessage, 1, LOCATE(' ,', apachemessage)) 
     WHERE id = importRecordID AND LOCATE(' ,', apachemessage)>0;

    UPDATE apache_logs.load_error_default 
       SET module=TRIM(module),
           loglevel=TRIM(loglevel),
           processid=TRIM(processid),
           threadid=TRIM(threadid),
           apachecode=TRIM(apachecode),
           apachemessage=TRIM(apachemessage),
           systemcode=TRIM(systemcode),
           systemmessage = TRIM(systemmessage),
           logmessage=TRIM(logmessage),
           client_name=TRIM(client_name),
           referer=TRIM(referer),
           server_name=TRIM(server_name),
           request_log_id=TRIM(request_log_id)
     WHERE id=importRecordID;
    UPDATE apache_logs.load_error_default SET process_status=1 WHERE id=importRecordID;
  END LOOP;
  -- to remove SQL calculating loadsProcessed when importLoad_ID is passed. Set=1 by default.
  IF importLoad_ID IS NOT NULL AND recordsProcessed=0 THEN
    SET loadsProcessed = 0;
  END IF;
  -- update import process table
  UPDATE apache_logs.import_process 
     SET records = recordsProcessed, 
         files = filesProcessed, 
         loads = loadsProcessed, 
         importloadid = importLoad_ID,
         completed = now(), 
         errorOccurred = processError,
         processSeconds = TIME_TO_SEC(TIMEDIFF(now(), started)) 
   WHERE id = importProcessID;
  COMMIT;
  -- close the cursor
  IF importLoad_ID IS NULL THEN
    CLOSE defaultByStatus;
  ELSE
    CLOSE defaultByLoadID;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `access_client_list`
--

/*!50001 DROP VIEW IF EXISTS `access_client_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_client_list` AS select `ln`.`name` AS `Access Log Client Name`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`log_client` `ln` join `access_log` `l` on((`l`.`clientid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_cookie_list`
--

/*!50001 DROP VIEW IF EXISTS `access_cookie_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_cookie_list` AS select `ln`.`name` AS `Access Log Cookie`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_cookie` `ln` join `access_log` `l` on((`l`.`cookieid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_importfile_list`
--

/*!50001 DROP VIEW IF EXISTS `access_importfile_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_importfile_list` AS select `ln`.`name` AS `Access Log Import File`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`import_file` `ln` join `access_log` `l` on((`l`.`importfileid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_period_day_list`
--

/*!50001 DROP VIEW IF EXISTS `access_period_day_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_period_day_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,dayofmonth(`l`.`logged`) AS `Day`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from `access_log` `l` group by year(`l`.`logged`),month(`l`.`logged`),dayofmonth(`l`.`logged`) order by 'Year','Month','Day' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_period_hour_list`
--

/*!50001 DROP VIEW IF EXISTS `access_period_hour_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_period_hour_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,dayofmonth(`l`.`logged`) AS `Day`,hour(`l`.`logged`) AS `Hour`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from `access_log` `l` group by year(`l`.`logged`),month(`l`.`logged`),dayofmonth(`l`.`logged`),hour(`l`.`logged`) order by 'Year','Month','Day','Hour' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_period_month_list`
--

/*!50001 DROP VIEW IF EXISTS `access_period_month_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_period_month_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from `access_log` `l` group by year(`l`.`logged`),month(`l`.`logged`) order by 'Year','Month' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_period_week_list`
--

/*!50001 DROP VIEW IF EXISTS `access_period_week_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_period_week_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,week(`l`.`logged`,0) AS `Week`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from `access_log` `l` group by year(`l`.`logged`),month(`l`.`logged`),week(`l`.`logged`,0) order by 'Year','Month','Week' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_period_year_list`
--

/*!50001 DROP VIEW IF EXISTS `access_period_year_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_period_year_list` AS select year(`l`.`logged`) AS `Year`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from `access_log` `l` group by year(`l`.`logged`) order by 'Year' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_referer_list`
--

/*!50001 DROP VIEW IF EXISTS `access_referer_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_referer_list` AS select `ln`.`name` AS `Access Log Referer`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`log_referer` `ln` join `access_log` `l` on((`l`.`refererid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_remotelogname_list`
--

/*!50001 DROP VIEW IF EXISTS `access_remotelogname_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_remotelogname_list` AS select `ln`.`name` AS `Access Log Remote Log Name`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_remotelogname` `ln` join `access_log` `l` on((`l`.`remotelognameid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_remoteuser_list`
--

/*!50001 DROP VIEW IF EXISTS `access_remoteuser_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_remoteuser_list` AS select `ln`.`name` AS `Access Log Remote User`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_remoteuser` `ln` join `access_log` `l` on((`l`.`remoteuserid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_reqmethod_list`
--

/*!50001 DROP VIEW IF EXISTS `access_reqmethod_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqmethod_list` AS select `ln`.`name` AS `Access Log Method`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_reqmethod` `ln` join `access_log` `l` on((`l`.`reqmethodid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_reqprotocol_list`
--

/*!50001 DROP VIEW IF EXISTS `access_reqprotocol_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqprotocol_list` AS select `ln`.`name` AS `Access Log Protocol`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_reqprotocol` `ln` join `access_log` `l` on((`l`.`reqstatusid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_reqquery_list`
--

/*!50001 DROP VIEW IF EXISTS `access_reqquery_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqquery_list` AS select `ln`.`name` AS `Access Log Query String`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_reqquery` `ln` join `access_log` `l` on((`l`.`reqqueryid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_reqstatus_list`
--

/*!50001 DROP VIEW IF EXISTS `access_reqstatus_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqstatus_list` AS select `ln`.`name` AS `Access Log Status`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_reqstatus` `ln` join `access_log` `l` on((`l`.`reqstatusid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_requri_list`
--

/*!50001 DROP VIEW IF EXISTS `access_requri_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_requri_list` AS select `ln`.`name` AS `Access Log URI`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_requri` `ln` join `access_log` `l` on((`l`.`requriid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_server_list`
--

/*!50001 DROP VIEW IF EXISTS `access_server_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_server_list` AS select `ln`.`name` AS `Access Log Server Name`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`log_server` `ln` join `access_log` `l` on((`l`.`serverid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_server_serverport_list`
--

/*!50001 DROP VIEW IF EXISTS `access_server_serverport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_server_serverport_list` AS select `sn`.`name` AS `Access Log Server Name`,`sp`.`name` AS `Server Port`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log` `l` join `log_server` `sn` on((`sn`.`id` = `l`.`serverid`))) join `log_serverport` `sp` on((`sp`.`id` = `l`.`serverportid`))) group by `l`.`serverid`,`l`.`serverportid` order by `sn`.`name`,`sp`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_serverport_list`
--

/*!50001 DROP VIEW IF EXISTS `access_serverport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_serverport_list` AS select `ln`.`name` AS `Access Log Server Port`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`log_serverport` `ln` join `access_log` `l` on((`l`.`serverportid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_browser_family_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_browser_family_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_browser_family_list` AS select `ln`.`name` AS `Browser Family`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_browser_family` `ln` join `access_log_useragent` `lua` on((`lua`.`uabrowserfamilyid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_browser_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_browser_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_browser_list` AS select `ln`.`name` AS `Browser`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_browser` `ln` join `access_log_useragent` `lua` on((`lua`.`uabrowserid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_browser_version_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_browser_version_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_browser_version_list` AS select `ln`.`name` AS `Browser Version`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_browser_version` `ln` join `access_log_useragent` `lua` on((`lua`.`uabrowserversionid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_device_brand_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_device_brand_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_device_brand_list` AS select `ln`.`name` AS `Device Brand`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_device_brand` `ln` join `access_log_useragent` `lua` on((`lua`.`uadevicebrandid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_device_family_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_device_family_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_device_family_list` AS select `ln`.`name` AS `Device Family`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_device_family` `ln` join `access_log_useragent` `lua` on((`lua`.`uadevicefamilyid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_device_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_device_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_device_list` AS select `ln`.`name` AS `Device`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_device` `ln` join `access_log_useragent` `lua` on((`lua`.`uadeviceid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_device_model_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_device_model_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_device_model_list` AS select `ln`.`name` AS `Device Model`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_device_model` `ln` join `access_log_useragent` `lua` on((`lua`.`uadevicefamilyid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_list` AS select `ln`.`name` AS `Access Log User Agent`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua` `ln` join `access_log_useragent` `lua` on((`lua`.`uaid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_os_family_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_os_family_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_os_family_list` AS select `ln`.`name` AS `Operating System Family`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_os_family` `ln` join `access_log_useragent` `lua` on((`lua`.`uaosfamilyid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_os_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_os_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_os_list` AS select `ln`.`name` AS `Operating System`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_os` `ln` join `access_log_useragent` `lua` on((`lua`.`uaosid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_ua_os_version_list`
--

/*!50001 DROP VIEW IF EXISTS `access_ua_os_version_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_ua_os_version_list` AS select `ln`.`name` AS `Operating System Version`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from ((`access_log_ua_os_version` `ln` join `access_log_useragent` `lua` on((`lua`.`uaosversionid` = `ln`.`id`))) join `access_log` `l` on((`l`.`useragentid` = `lua`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_browser_family_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_browser_family_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_browser_family_list` AS select `ln`.`ua_browser_family` AS `Browser Family`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_browser_family` order by `ln`.`ua_browser_family` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_browser_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_browser_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_browser_list` AS select `ln`.`ua_browser` AS `Browser`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_browser` order by `ln`.`ua_browser` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_browser_version_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_browser_version_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_browser_version_list` AS select `ln`.`ua_browser_version` AS `Browser Version`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_browser_version` order by `ln`.`ua_browser_version` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_device_brand_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_device_brand_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_brand_list` AS select `ln`.`ua_device_brand` AS `Device Brand`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device_brand` order by `ln`.`ua_device_brand` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_device_family_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_device_family_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_family_list` AS select `ln`.`ua_device_family` AS `Device Family`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device_family` order by `ln`.`ua_device_family` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_device_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_device_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_list` AS select `ln`.`ua_device` AS `Device`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device` order by `ln`.`ua_device` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_device_model_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_device_model_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_model_list` AS select `ln`.`ua_device_model` AS `Device Model`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device_model` order by `ln`.`ua_device_model` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_list` AS select `ln`.`name` AS `Access Log UserAgent`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_os_browser_device_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_os_browser_device_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_browser_device_list` AS select `ln`.`ua_os_family` AS `Operating System`,`ln`.`ua_browser_family` AS `Browser`,`ln`.`ua_device_family` AS `Device`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os_family`,`ln`.`ua_browser_family`,`ln`.`ua_device_family` order by `ln`.`ua_os_family`,`ln`.`ua_browser_family`,`ln`.`ua_device_family` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_os_family_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_os_family_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_family_list` AS select `ln`.`ua_os_family` AS `Operating System Family`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os_family` order by `ln`.`ua_os_family` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_os_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_os_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_list` AS select `ln`.`ua_os` AS `Operating System`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os` order by `ln`.`ua_os` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_os_version_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_os_version_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_version_list` AS select `ln`.`ua_os_version` AS `Operating System Version`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os_version` order by `ln`.`ua_os_version` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_useragent_pretty_list`
--

/*!50001 DROP VIEW IF EXISTS `access_useragent_pretty_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_pretty_list` AS select `ln`.`ua` AS `Access Log Pretty User Agent`,count(`l`.`id`) AS `Log Count`,sum(`l`.`reqbytes`) AS `HTTP Bytes`,sum(`l`.`bytes_sent`) AS `Bytes Sent`,sum(`l`.`bytes_received`) AS `Bytes Received`,sum(`l`.`bytes_transferred`) AS `Bytes Transferred`,max(`l`.`reqtime_milli`) AS `Max Request Time`,min(`l`.`reqtime_milli`) AS `Min Request Time`,max(`l`.`reqdelay_milli`) AS `Max Delay Time`,min(`l`.`reqdelay_milli`) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua` order by `ln`.`ua` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_apachecode_list`
--

/*!50001 DROP VIEW IF EXISTS `error_apachecode_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_apachecode_list` AS select `ln`.`name` AS `Error Log Apache Code`,count(`l`.`id`) AS `Log Count` from (`error_log_apachecode` `ln` join `error_log` `l` on((`l`.`apachecodeid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_apachemessage_list`
--

/*!50001 DROP VIEW IF EXISTS `error_apachemessage_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_apachemessage_list` AS select `ln`.`name` AS `Error Log Apache Message`,count(`l`.`id`) AS `Log Count` from (`error_log_apachemessage` `ln` join `error_log` `l` on((`l`.`apachemessageid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_client_clientport_list`
--

/*!50001 DROP VIEW IF EXISTS `error_client_clientport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_client_clientport_list` AS select `cn`.`name` AS `Error Log Server Name`,`cp`.`name` AS `Server Port`,count(`l`.`id`) AS `Log Count` from ((`error_log` `l` join `log_client` `cn` on((`cn`.`id` = `l`.`clientid`))) join `log_clientport` `cp` on((`cp`.`id` = `l`.`clientportid`))) group by `l`.`clientid`,`l`.`clientportid` order by `cn`.`name`,`cp`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_client_list`
--

/*!50001 DROP VIEW IF EXISTS `error_client_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_client_list` AS select `ln`.`name` AS `Error Log Client Name`,count(`l`.`id`) AS `Log Count` from (`log_client` `ln` join `error_log` `l` on((`l`.`clientid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_client_port_list`
--

/*!50001 DROP VIEW IF EXISTS `error_client_port_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_client_port_list` AS select `ln`.`name` AS `Error Log Client Port`,count(`l`.`id`) AS `Log Count` from (`log_clientport` `ln` join `error_log` `l` on((`l`.`clientportid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_importfile_list`
--

/*!50001 DROP VIEW IF EXISTS `error_importfile_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_importfile_list` AS select `ln`.`name` AS `Error Log Import File`,count(`l`.`id`) AS `Log Count` from (`import_file` `ln` join `error_log` `l` on((`l`.`importfileid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_level_list`
--

/*!50001 DROP VIEW IF EXISTS `error_level_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_level_list` AS select `ln`.`name` AS `Error Log Level`,count(`l`.`id`) AS `Log Count` from (`error_log_level` `ln` join `error_log` `l` on((`l`.`loglevelid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_message_list`
--

/*!50001 DROP VIEW IF EXISTS `error_message_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_message_list` AS select `ln`.`name` AS `Error Log Message`,count(`l`.`id`) AS `Log Count` from (`error_log_message` `ln` join `error_log` `l` on((`l`.`logmessageid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_module_list`
--

/*!50001 DROP VIEW IF EXISTS `error_module_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_module_list` AS select `ln`.`name` AS `Error Log Module`,count(`l`.`id`) AS `Log Count` from (`error_log_module` `ln` join `error_log` `l` on((`l`.`moduleid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_period_day_list`
--

/*!50001 DROP VIEW IF EXISTS `error_period_day_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_period_day_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,dayofmonth(`l`.`logged`) AS `Day`,count(`l`.`id`) AS `Log Count` from `error_log` `l` group by year(`l`.`logged`),month(`l`.`logged`),dayofmonth(`l`.`logged`) order by 'Year','Month','Day' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_period_hour_list`
--

/*!50001 DROP VIEW IF EXISTS `error_period_hour_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_period_hour_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,dayofmonth(`l`.`logged`) AS `Day`,hour(`l`.`logged`) AS `Hour`,count(`l`.`id`) AS `Log Count` from `error_log` `l` group by year(`l`.`logged`),month(`l`.`logged`),dayofmonth(`l`.`logged`),hour(`l`.`logged`) order by 'Year','Month','Day','Hour' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_period_month_list`
--

/*!50001 DROP VIEW IF EXISTS `error_period_month_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_period_month_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,count(`l`.`id`) AS `Log Count` from `error_log` `l` group by year(`l`.`logged`),month(`l`.`logged`) order by 'Year','Month' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_period_week_list`
--

/*!50001 DROP VIEW IF EXISTS `error_period_week_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_period_week_list` AS select year(`l`.`logged`) AS `Year`,month(`l`.`logged`) AS `Month`,week(`l`.`logged`,0) AS `Week`,count(`l`.`id`) AS `Log Count` from `error_log` `l` group by year(`l`.`logged`),month(`l`.`logged`),week(`l`.`logged`,0) order by 'Year','Month','Week' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_period_year_list`
--

/*!50001 DROP VIEW IF EXISTS `error_period_year_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_period_year_list` AS select year(`l`.`logged`) AS `Year`,count(`l`.`id`) AS `Log Count` from `error_log` `l` group by year(`l`.`logged`) order by 'Year' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_processid_list`
--

/*!50001 DROP VIEW IF EXISTS `error_processid_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_processid_list` AS select `ln`.`name` AS `Error Log ProcessID`,count(`l`.`id`) AS `Log Count` from (`error_log_processid` `ln` join `error_log` `l` on((`l`.`processid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_processid_threadid_list`
--

/*!50001 DROP VIEW IF EXISTS `error_processid_threadid_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_processid_threadid_list` AS select `pid`.`name` AS `ProcessID`,`tid`.`name` AS `ThreadID`,count(`l`.`id`) AS `Log Count` from ((`error_log` `l` join `error_log_processid` `pid` on((`l`.`processid` = `pid`.`id`))) join `error_log_threadid` `tid` on((`l`.`threadid` = `tid`.`id`))) group by `pid`.`id`,`tid`.`id` order by `pid`.`name`,`tid`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_referer_list`
--

/*!50001 DROP VIEW IF EXISTS `error_referer_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_referer_list` AS select `ln`.`name` AS `Error Log Referer`,count(`l`.`id`) AS `Log Count` from (`log_referer` `ln` join `error_log` `l` on((`l`.`refererid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_server_list`
--

/*!50001 DROP VIEW IF EXISTS `error_server_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_server_list` AS select `ln`.`name` AS `Error Log Server Name`,count(`l`.`id`) AS `Log Count` from (`log_server` `ln` join `error_log` `l` on((`l`.`serverid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_server_serverport_list`
--

/*!50001 DROP VIEW IF EXISTS `error_server_serverport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_server_serverport_list` AS select `sn`.`name` AS `Error Log Server Name`,`sp`.`name` AS `Server Port`,count(`l`.`id`) AS `Log Count` from ((`error_log` `l` join `log_server` `sn` on((`sn`.`id` = `l`.`serverid`))) join `log_serverport` `sp` on((`sp`.`id` = `l`.`serverportid`))) group by `l`.`serverid`,`l`.`serverportid` order by `sn`.`name`,`sp`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_serverport_list`
--

/*!50001 DROP VIEW IF EXISTS `error_serverport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_serverport_list` AS select `ln`.`name` AS `Error Log Server Port`,count(`l`.`id`) AS `Log Count` from (`log_serverport` `ln` join `error_log` `l` on((`l`.`serverportid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_systemcode_list`
--

/*!50001 DROP VIEW IF EXISTS `error_systemcode_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_systemcode_list` AS select `ln`.`name` AS `Error Log System Code`,count(`l`.`id`) AS `Log Count` from (`error_log_systemcode` `ln` join `error_log` `l` on((`l`.`systemcodeid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_systemmessage_list`
--

/*!50001 DROP VIEW IF EXISTS `error_systemmessage_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_systemmessage_list` AS select `ln`.`name` AS `Error Log System Message`,count(`l`.`id`) AS `Log Count` from (`error_log_systemmessage` `ln` join `error_log` `l` on((`l`.`systemmessageid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_threadid_list`
--

/*!50001 DROP VIEW IF EXISTS `error_threadid_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `error_threadid_list` AS select `ln`.`name` AS `Error Log ThreadID`,count(`l`.`id`) AS `Log Count` from (`error_log_threadid` `ln` join `error_log` `l` on((`l`.`threadid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `log_client_list`
--

/*!50001 DROP VIEW IF EXISTS `log_client_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `log_client_list` AS select `log_client`.`name` AS `Client Name`,`apache_logs`.`clientID_logs`(`log_client`.`id`,'A') AS `Access Log Count`,`apache_logs`.`clientID_logs`(`log_client`.`id`,'E') AS `Error Log Count` from `log_client` order by `log_client`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `log_clientport_list`
--

/*!50001 DROP VIEW IF EXISTS `log_clientport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `log_clientport_list` AS select `log_clientport`.`name` AS `Client Port`,`apache_logs`.`clientPortID_logs`(`log_clientport`.`id`,'A') AS `Access Log Count`,`apache_logs`.`clientPortID_logs`(`log_clientport`.`id`,'E') AS `Error Log Count` from `log_clientport` order by `log_clientport`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `log_referer_list`
--

/*!50001 DROP VIEW IF EXISTS `log_referer_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `log_referer_list` AS select `log_referer`.`name` AS `Referer`,`apache_logs`.`refererID_logs`(`log_referer`.`id`,'A') AS `Access Log Count`,`apache_logs`.`refererID_logs`(`log_referer`.`id`,'E') AS `Error Log Count` from `log_referer` order by `log_referer`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `log_requestlog_list`
--

/*!50001 DROP VIEW IF EXISTS `log_requestlog_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `log_requestlog_list` AS select `log_requestlogid`.`name` AS `Request Log`,`apache_logs`.`requestlogID_logs`(`log_requestlogid`.`id`,'A') AS `Access Log Count`,`apache_logs`.`requestlogID_logs`(`log_requestlogid`.`id`,'E') AS `Error Log Count` from `log_requestlogid` order by `log_requestlogid`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `log_server_list`
--

/*!50001 DROP VIEW IF EXISTS `log_server_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `log_server_list` AS select `log_server`.`name` AS `Server Name`,`apache_logs`.`serverID_logs`(`log_server`.`id`,'A') AS `Access Log Count`,`apache_logs`.`serverID_logs`(`log_server`.`id`,'E') AS `Error Log Count` from `log_server` order by `log_server`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `log_serverport_list`
--

/*!50001 DROP VIEW IF EXISTS `log_serverport_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `log_serverport_list` AS select `log_serverport`.`name` AS `Server Port`,`apache_logs`.`serverPortID_logs`(`log_serverport`.`id`,'A') AS `Access Log Count`,`apache_logs`.`serverPortID_logs`(`log_serverport`.`id`,'E') AS `Error Log Count` from `log_serverport` order by `log_serverport`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
