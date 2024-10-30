/*!# coding: utf-8
# version 1.0.0 - 10/31/2024 - http://farmfreshsoftware.com
#
# Copyright 2024 Will Raymond <farmfreshsoftware@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

:MySQL database Data Definition Language (DDL) for apachelogs2MySQL application
:schema: apache_logs
:synopsis: file creates schema, tables, views, indexes, stored procedures and stored functions.
:author: farmfreshsoftware@gmail.com (Will Raymond)
*/

CREATE DATABASE  IF NOT EXISTS `apache_logs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `apache_logs`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: apache_logs
-- ------------------------------------------------------
-- Server version	9.0.0

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
-- Temporary view structure for view `access_host_list`
--

DROP TABLE IF EXISTS `access_host_list`;
/*!50001 DROP VIEW IF EXISTS `access_host_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_host_list` AS SELECT 
 1 AS `Access Log Host`,
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
  `timeStamp` datetime DEFAULT NULL,
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
  `remotehostid` int DEFAULT NULL,
  `remotelognameid` int DEFAULT NULL,
  `remoteuserid` int DEFAULT NULL,
  `refererid` int DEFAULT NULL,
  `useragentid` int DEFAULT NULL,
  `sessionid` int DEFAULT NULL,
  `hostid` int DEFAULT NULL,
  `importfileid` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_access_reqstatus` (`reqstatusid`),
  KEY `FK_access_reqprotocol` (`reqprotocolid`),
  KEY `FK_access_reqmethod` (`reqmethodid`),
  KEY `FK_access_requri` (`requriid`),
  KEY `FK_access_remotehost` (`remotehostid`),
  KEY `FK_access_remotelogname` (`remotelognameid`),
  KEY `FK_access_remoteuser` (`remoteuserid`),
  KEY `FK_access_referer` (`refererid`),
  KEY `FK_access_useragent` (`useragentid`),
  KEY `FK_access_session` (`sessionid`),
  KEY `FK_access_host` (`hostid`),
  KEY `FK_access_importfile` (`importfileid`),
  CONSTRAINT `FK_access_host` FOREIGN KEY (`hostid`) REFERENCES `access_log_host` (`id`),
  CONSTRAINT `FK_access_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`),
  CONSTRAINT `FK_access_referer` FOREIGN KEY (`refererid`) REFERENCES `access_log_referer` (`id`),
  CONSTRAINT `FK_access_remotehost` FOREIGN KEY (`remotehostid`) REFERENCES `access_log_remotehost` (`id`),
  CONSTRAINT `FK_access_remotelogname` FOREIGN KEY (`remotelognameid`) REFERENCES `access_log_remotelogname` (`id`),
  CONSTRAINT `FK_access_remoteuser` FOREIGN KEY (`remoteuserid`) REFERENCES `access_log_remoteuser` (`id`),
  CONSTRAINT `FK_access_reqmethod` FOREIGN KEY (`reqmethodid`) REFERENCES `access_log_reqmethod` (`id`),
  CONSTRAINT `FK_access_reqprotocol` FOREIGN KEY (`reqprotocolid`) REFERENCES `access_log_reqprotocol` (`id`),
  CONSTRAINT `FK_access_reqstatus` FOREIGN KEY (`reqstatusid`) REFERENCES `access_log_reqstatus` (`id`),
  CONSTRAINT `FK_access_requri` FOREIGN KEY (`requriid`) REFERENCES `access_log_requri` (`id`),
  CONSTRAINT `FK_access_session` FOREIGN KEY (`sessionid`) REFERENCES `access_log_session` (`id`),
  CONSTRAINT `FK_access_useragent` FOREIGN KEY (`useragentid`) REFERENCES `access_log_useragent` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66915 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_combined`
--

DROP TABLE IF EXISTS `access_log_combined`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_combined` (
  `remote_host` varchar(50) DEFAULT NULL,
  `remote_logname` varchar(50) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
  `remote_user` varchar(50) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
  `log_time` varchar(50) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
  `log_time_offset` varchar(50) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
  `first_line_request` varchar(500) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_protocol',
  `req_status` int DEFAULT NULL,
  `req_bytes` int DEFAULT NULL,
  `log_referer` varchar(2000) DEFAULT NULL,
  `log_useragent` varchar(4000) DEFAULT NULL,
  `req_protocol` varchar(100) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_method` varchar(100) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_uri` varchar(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `import_status` int NOT NULL DEFAULT '0' COMMENT 'used in import process to indicate record processed',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54011 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_extended`
--

DROP TABLE IF EXISTS `access_log_extended`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_extended` (
  `remote_host` varchar(50) DEFAULT NULL,
  `log_time` varchar(50) DEFAULT NULL,
  `bytes_received` int DEFAULT NULL,
  `bytes_sent` int DEFAULT NULL,
  `bytes_transferred` int DEFAULT NULL,
  `reqtime_milli` int DEFAULT NULL,
  `reqtime_micro` int DEFAULT NULL,
  `reqdelay_milli` int DEFAULT NULL,
  `req_bytes` int DEFAULT NULL,
  `req_status` int DEFAULT NULL,
  `req_protocol` varchar(100) DEFAULT NULL,
  `req_method` varchar(100) DEFAULT NULL,
  `req_uri` varchar(2000) DEFAULT NULL,
  `log_referer` varchar(2000) DEFAULT NULL,
  `log_useragent` varchar(4000) DEFAULT NULL,
  `log_session` varchar(300) DEFAULT NULL COMMENT 'Storing Session ID in application cookie to relate with login tables on server.',
  `log_host` varchar(100) DEFAULT NULL,
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `import_status` int NOT NULL DEFAULT '0' COMMENT 'used in import process to indicate record processed',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28730 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_host`
--

DROP TABLE IF EXISTS `access_log_host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_host` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_referer`
--

DROP TABLE IF EXISTS `access_log_referer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_referer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(2000) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_remotehost`
--

DROP TABLE IF EXISTS `access_log_remotehost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_remotehost` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=731 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_remotelogname`
--

DROP TABLE IF EXISTS `access_log_remotelogname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_remotelogname` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_remoteuser`
--

DROP TABLE IF EXISTS `access_log_remoteuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_remoteuser` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_reqmethod`
--

DROP TABLE IF EXISTS `access_log_reqmethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_reqmethod` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_reqprotocol`
--

DROP TABLE IF EXISTS `access_log_reqprotocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_reqprotocol` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=765 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_session`
--

DROP TABLE IF EXISTS `access_log_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_useragent`
--

DROP TABLE IF EXISTS `access_log_useragent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_useragent` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(4000) NOT NULL,
  `ua` varchar(200) DEFAULT NULL,
  `ua_browser` varchar(200) DEFAULT NULL,
  `ua_browser_family` varchar(200) DEFAULT NULL,
  `ua_browser_version` varchar(200) DEFAULT NULL,
  `ua_os` varchar(200) DEFAULT NULL,
  `ua_os_family` varchar(200) DEFAULT NULL,
  `ua_os_version` varchar(200) DEFAULT NULL,
  `ua_device` varchar(200) DEFAULT NULL,
  `ua_device_family` varchar(200) DEFAULT NULL,
  `ua_device_brand` varchar(200) DEFAULT NULL,
  `ua_device_model` varchar(200) DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=395 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `access_log_vhost`
--

DROP TABLE IF EXISTS `access_log_vhost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_log_vhost` (
  `server_name` varchar(75) DEFAULT NULL,
  `remote_host` varchar(50) DEFAULT NULL,
  `remote_logname` varchar(50) DEFAULT NULL COMMENT 'This will return a dash unless mod_ident is present and IdentityCheck is set On.',
  `remote_user` varchar(50) DEFAULT NULL COMMENT 'Remote user if the request was authenticated. May be bogus if return status (%s) is 401 (unauthorized).',
  `log_time` varchar(50) DEFAULT NULL COMMENT 'due to MySQL LOAD DATA LOCAL INFILE limitations can not have 2 OPTIONALLY ENCLOSED BY "" and []. It is easier with 2 columns for this data',
  `log_time_offset` varchar(50) DEFAULT NULL COMMENT 'to simplify import and use MySQL LOAD DATA LOCAL INFILE. I have python script to import standard combined but this keeps it all in MySQL',
  `first_line_request` varchar(500) DEFAULT NULL COMMENT 'contains req_method, req_uri, req_protocol',
  `req_status` int DEFAULT NULL,
  `req_bytes` int DEFAULT NULL,
  `log_referer` varchar(2000) DEFAULT NULL,
  `log_useragent` varchar(4000) DEFAULT NULL,
  `req_protocol` varchar(100) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_method` varchar(100) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `req_uri` varchar(2000) DEFAULT NULL COMMENT 'parsed from first_line_request in import',
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `import_status` int NOT NULL DEFAULT '0' COMMENT 'used in import process to indicate record processed',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4690 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Temporary view structure for view `access_remotehost_list`
--

DROP TABLE IF EXISTS `access_remotehost_list`;
/*!50001 DROP VIEW IF EXISTS `access_remotehost_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_remotehost_list` AS SELECT 
 1 AS `Access Log Remote Host`,
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
-- Temporary view structure for view `access_session_list`
--

DROP TABLE IF EXISTS `access_session_list`;
/*!50001 DROP VIEW IF EXISTS `access_session_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `access_session_list` AS SELECT 
 1 AS `Access Log Session`,
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
  `timeStamp` datetime NOT NULL,
  `loglevelid` int DEFAULT NULL,
  `moduleid` int DEFAULT NULL,
  `processid` int DEFAULT NULL,
  `threadid` int DEFAULT NULL,
  `apachecodeid` int DEFAULT NULL,
  `apachemessageid` int DEFAULT NULL,
  `systemcodeid` int DEFAULT NULL,
  `systemmessageid` int DEFAULT NULL,
  `logmessageid` int DEFAULT NULL COMMENT 'comment',
  `reqclientid` int DEFAULT NULL COMMENT 'comment',
  `refererid` int DEFAULT NULL COMMENT 'comment',
  `importfileid` int NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_error_level` (`loglevelid`),
  KEY `FK_error_module` (`moduleid`),
  KEY `FK_error_processid` (`processid`),
  KEY `FK_error_threadid` (`threadid`),
  KEY `FK_error_apachecode` (`apachecodeid`),
  KEY `FK_error_apachemessage` (`apachemessageid`),
  KEY `FK_error_systemcode` (`systemcodeid`),
  KEY `FK_error_systemmessage` (`systemmessageid`),
  KEY `FK_error_message` (`logmessageid`),
  KEY `FK_error_reqclient` (`reqclientid`),
  KEY `FK_error_referer` (`refererid`),
  KEY `FK_error_importfile` (`importfileid`),
  CONSTRAINT `FK_error_apachecode` FOREIGN KEY (`apachecodeid`) REFERENCES `error_log_apachecode` (`id`),
  CONSTRAINT `FK_error_apachemessage` FOREIGN KEY (`apachemessageid`) REFERENCES `error_log_apachemessage` (`id`),
  CONSTRAINT `FK_error_importfile` FOREIGN KEY (`importfileid`) REFERENCES `import_file` (`id`),
  CONSTRAINT `FK_error_level` FOREIGN KEY (`loglevelid`) REFERENCES `error_log_level` (`id`),
  CONSTRAINT `FK_error_message` FOREIGN KEY (`logmessageid`) REFERENCES `error_log_message` (`id`),
  CONSTRAINT `FK_error_module` FOREIGN KEY (`moduleid`) REFERENCES `error_log_module` (`id`),
  CONSTRAINT `FK_error_processid` FOREIGN KEY (`processid`) REFERENCES `error_log_processid` (`id`),
  CONSTRAINT `FK_error_referer` FOREIGN KEY (`refererid`) REFERENCES `error_log_referer` (`id`),
  CONSTRAINT `FK_error_reqclient` FOREIGN KEY (`reqclientid`) REFERENCES `error_log_reqclient` (`id`),
  CONSTRAINT `FK_error_systemcode` FOREIGN KEY (`systemcodeid`) REFERENCES `error_log_systemcode` (`id`),
  CONSTRAINT `FK_error_systemmessage` FOREIGN KEY (`systemmessageid`) REFERENCES `error_log_systemmessage` (`id`),
  CONSTRAINT `FK_error_threadid` FOREIGN KEY (`threadid`) REFERENCES `error_log_threadid` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7281 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_apachecode`
--

DROP TABLE IF EXISTS `error_log_apachecode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_apachecode` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(400) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_apachemessage`
--

DROP TABLE IF EXISTS `error_log_apachemessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_apachemessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(400) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_default`
--

DROP TABLE IF EXISTS `error_log_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_default` (
  `log_time` varchar(50) DEFAULT NULL,
  `log_mod_level` varchar(1000) DEFAULT NULL,
  `log_processid_threadid` varchar(1000) DEFAULT NULL,
  `log_parse1` varchar(2000) DEFAULT NULL,
  `log_parse2` varchar(2000) DEFAULT NULL,
  `log_message_nocode` varchar(500) DEFAULT NULL,
  `logtime` datetime DEFAULT NULL,
  `loglevel` varchar(100) DEFAULT NULL,
  `module` varchar(100) DEFAULT NULL,
  `processid` varchar(100) DEFAULT NULL,
  `threadid` varchar(100) DEFAULT NULL,
  `apachecode` varchar(400) DEFAULT NULL,
  `apachemessage` varchar(400) DEFAULT NULL,
  `systemcode` varchar(400) DEFAULT NULL,
  `systemmessage` varchar(400) DEFAULT NULL,
  `logmessage` varchar(500) DEFAULT NULL,
  `reqclient` varchar(200) DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `importfileid` int DEFAULT NULL COMMENT 'used in import process to indicate file record extractedd from',
  `import_status` int NOT NULL DEFAULT '0' COMMENT 'used in import process to indicate record processed',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13074 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_module`
--

DROP TABLE IF EXISTS `error_log_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_module` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_referer`
--

DROP TABLE IF EXISTS `error_log_referer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_referer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_reqclient`
--

DROP TABLE IF EXISTS `error_log_reqclient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_reqclient` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_systemcode`
--

DROP TABLE IF EXISTS `error_log_systemcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_systemcode` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(400) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1706 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_log_systemmessage`
--

DROP TABLE IF EXISTS `error_log_systemmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_log_systemmessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(400) NOT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Temporary view structure for view `error_reqclient_list`
--

DROP TABLE IF EXISTS `error_reqclient_list`;
/*!50001 DROP VIEW IF EXISTS `error_reqclient_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `error_reqclient_list` AS SELECT 
 1 AS `Error Log Client`,
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
-- Table structure for table `import_file`
--

DROP TABLE IF EXISTS `import_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_file` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `importprocessid` int DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_import_importprocess` (`importprocessid`),
  CONSTRAINT `FK_import_importprocess` FOREIGN KEY (`importprocessid`) REFERENCES `import_process` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=563 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `import_log`
--

DROP TABLE IF EXISTS `import_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dbuser` varchar(250) DEFAULT NULL,
  `dbhost` varchar(250) DEFAULT NULL,
  `dbversion` varchar(50) DEFAULT NULL,
  `dbsystem` varchar(50) DEFAULT NULL,
  `dbmachine` varchar(50) DEFAULT NULL,
  `serveruuid` varchar(250) DEFAULT NULL,
  `process` varchar(250) DEFAULT NULL,
  `details` varchar(250) DEFAULT NULL,
  `err_sqlstate` varchar(250) DEFAULT NULL,
  `err_message` varchar(250) DEFAULT NULL,
  `err_mysqlno` varchar(250) DEFAULT NULL,
  `importfileid` int DEFAULT NULL,
  `importprocessid` int DEFAULT NULL,
  `added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `import_process`
--

DROP TABLE IF EXISTS `import_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_process` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `dbuser` varchar(250) DEFAULT NULL,
  `dbhost` varchar(250) DEFAULT NULL,
  `dbversion` varchar(50) DEFAULT NULL,
  `dbsystem` varchar(50) DEFAULT NULL,
  `dbmachine` varchar(50) DEFAULT NULL,
  `serveruuid` varchar(250) DEFAULT NULL,
  `records` int DEFAULT '0',
  `files` int DEFAULT '0',
  `started` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'apache_logs'
--
/*!50003 DROP FUNCTION IF EXISTS `access_hostID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_hostID`(tcHost varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE host_ID INTEGER DEFAULT null;
  SELECT id
    INTO host_ID
    FROM apache_logs.access_log_host
    WHERE name = tcHost;

  IF host_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_host (name) VALUES (tcHost);
      SET host_ID = LAST_INSERT_ID();
  END IF;

  RETURN host_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_refererID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_refererID`(tcReferer varchar(2000)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE referer_ID INTEGER DEFAULT null;
  SELECT id
    INTO referer_ID
    FROM apache_logs.access_log_referer
    WHERE name = tcReferer;

  IF referer_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_referer (name) VALUES (tcReferer);
      SET referer_ID = LAST_INSERT_ID();
  END IF;

  RETURN referer_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_remoteHostID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_remoteHostID`(tcRemoteHost varchar(50)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE remoteHost_ID INTEGER DEFAULT null;
  SELECT id
    INTO remoteHost_ID
    FROM apache_logs.access_log_remotehost
    WHERE name = tcRemoteHost;

  IF remoteHost_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_remotehost (name) VALUES (tcRemoteHost);
      SET remoteHost_ID = LAST_INSERT_ID();
  END IF;

  RETURN remoteHost_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_remoteLogNameID`(tcRemoteLogName varchar(50)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE remoteLogName_ID INTEGER DEFAULT null;
  SELECT id
    INTO remoteLogName_ID
    FROM apache_logs.access_log_remotelogname
    WHERE name = tcRemoteLogName;

  IF remoteLogName_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_remotelogname (name) VALUES (tcRemoteLogName);
      SET remoteLogName_ID = LAST_INSERT_ID();
  END IF;

  RETURN remoteLogName_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_remoteUserID`(tcRemoteUser varchar(50)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE remoteUser_ID INTEGER DEFAULT null;
  SELECT id
    INTO remoteUser_ID
    FROM apache_logs.access_log_remoteuser
    WHERE name = tcRemoteUser;

  IF remoteUser_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_remoteuser (name) VALUES (tcRemoteUser);
      SET remoteUser_ID = LAST_INSERT_ID();
  END IF;

  RETURN remoteUser_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_reqMethodID`(tcReqMethod varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE reqMethod_ID INTEGER DEFAULT null;
  SELECT id
    INTO reqMethod_ID
    FROM apache_logs.access_log_reqmethod
    WHERE name = tcReqMethod;

  IF reqMethod_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_reqmethod (name) VALUES (tcReqMethod);
      SET reqMethod_ID = LAST_INSERT_ID();
  END IF;

  RETURN reqMethod_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_reqProtocolID`(tcReqProtocol varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE reqProtocol_ID INTEGER DEFAULT null;
  SELECT id
    INTO reqProtocol_ID
    FROM apache_logs.access_log_reqprotocol
    WHERE name = tcReqProtocol;

  IF reqProtocol_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_reqprotocol (name) VALUES (tcReqProtocol);
      SET reqProtocol_ID = LAST_INSERT_ID();
  END IF;

  RETURN reqProtocol_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_reqStatusID`(tnReqStatus INTEGER) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE reqStatus_ID INTEGER DEFAULT null;
  SELECT id
    INTO reqStatus_ID
    FROM apache_logs.access_log_reqstatus
    WHERE name = tnReqStatus;

  IF reqStatus_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_reqstatus (name) VALUES (tnReqStatus);
      SET reqStatus_ID = LAST_INSERT_ID();
  END IF;

  RETURN reqStatus_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_reqUriID`(tcReqUri varchar(4000)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE reqUri_ID INTEGER DEFAULT null;
  SELECT id
    INTO reqUri_ID
    FROM apache_logs.access_log_requri
    WHERE name = tcReqUri;

  IF reqUri_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_requri (name) VALUES (tcReqUri);
      SET reqUri_ID = LAST_INSERT_ID();
  END IF;

  RETURN reqUri_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `access_sessionID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_sessionID`(tcSession varchar(300)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE session_ID INTEGER DEFAULT null;
  SELECT id
    INTO session_ID
    FROM apache_logs.access_log_session
    WHERE name = tcSession;

  IF session_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_session (name) VALUES (tcSession);
      SET session_ID = LAST_INSERT_ID();
  END IF;

  RETURN session_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `access_userAgentID`(tcUserAgent varchar(4000)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE userAgent_ID INTEGER DEFAULT null;
  SELECT id
    INTO userAgent_ID
    FROM apache_logs.access_log_useragent
    WHERE name = tcUserAgent;

  IF userAgent_ID IS NULL THEN
      INSERT INTO apache_logs.access_log_useragent (name) VALUES (tcUserAgent);
      SET userAgent_ID = LAST_INSERT_ID();
  END IF;

  RETURN userAgent_ID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_apacheCodeID`(logapacheCode varchar(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logapacheCodeID INTEGER DEFAULT null;
  SELECT id
    INTO logapacheCodeID
    FROM apache_logs.error_log_apachecode
    WHERE name = logapacheCode;

  IF logapacheCodeID IS NULL THEN
      INSERT INTO apache_logs.error_log_apachecode (name) VALUES (logapacheCode);
      SET logapacheCodeID = LAST_INSERT_ID();
  END IF;

  RETURN logapacheCodeID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_apacheMessageID`(logapacheMessage varchar(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logapacheMessageID INTEGER DEFAULT null;
  SELECT id
    INTO logapacheMessageID
    FROM apache_logs.error_log_apachemessage
    WHERE name = logapacheMessage;

  IF logapacheMessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_apachemessage (name) VALUES (logapacheMessage);
      SET logapacheMessageID = LAST_INSERT_ID();
  END IF;

  RETURN logapacheMessageID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_logLevelID`(loglevel varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logLevelID INTEGER DEFAULT null;
  SELECT id
    INTO logLevelID
    FROM apache_logs.error_log_level
    WHERE name = loglevel;

  IF logLevelID IS NULL THEN
      INSERT INTO apache_logs.error_log_level (name) VALUES (loglevel);
      SET logLevelID = LAST_INSERT_ID();
  END IF;

  RETURN logLevelID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_logMessageID`(logmessage varchar(500)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logmessageID INTEGER DEFAULT null;
  SELECT id
    INTO logmessageID
    FROM apache_logs.error_log_message
    WHERE name = logmessage;

  IF logmessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_message (name) VALUES (logmessage);
      SET logmessageID = LAST_INSERT_ID();
  END IF;

  RETURN logmessageID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_moduleID`(logmodule varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logmoduleID INTEGER DEFAULT null;
  SELECT id
    INTO logmoduleID
    FROM apache_logs.error_log_module
    WHERE name = logmodule;

  IF logmoduleID IS NULL THEN
      INSERT INTO apache_logs.error_log_module (name) VALUES (logmodule);
      SET logmoduleID = LAST_INSERT_ID();
  END IF;

  RETURN logmoduleID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_processID`(logprocessid varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logprocessidID INTEGER DEFAULT null;
  SELECT id
    INTO logprocessidID
    FROM apache_logs.error_log_processid
    WHERE name = logprocessid;

  IF logprocessidID IS NULL THEN
      INSERT INTO apache_logs.error_log_processid (name) VALUES (logprocessid);
      SET logprocessidID = LAST_INSERT_ID();
  END IF;

  RETURN logprocessidID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_refererID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_refererID`(logreferer varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logrefererID INTEGER DEFAULT null;
  SELECT id
    INTO logrefererID
    FROM apache_logs.error_log_referer
    WHERE name = logreferer;

  IF logrefererID IS NULL THEN
      INSERT INTO apache_logs.error_log_referer (name) VALUES (logreferer);
      SET logrefererID = LAST_INSERT_ID();
  END IF;

  RETURN logrefererID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `error_reqClientID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_reqClientID`(logreqClient varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logreqClientID INTEGER DEFAULT null;
  SELECT id
    INTO logreqClientID
    FROM apache_logs.error_log_reqclient
    WHERE name = logreqClient;

  IF logreqClientID IS NULL THEN
      INSERT INTO apache_logs.error_log_reqclient (name) VALUES (logreqClient);
      SET logreqClientID = LAST_INSERT_ID();
  END IF;

  RETURN logreqClientID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_systemCodeID`(logsystemCode varchar(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logsystemCodeID INTEGER DEFAULT null;
  SELECT id
    INTO logsystemCode
    FROM apache_logs.error_log_systemcode
    WHERE name = logsystemCode;

  IF logsystemCodeID IS NULL THEN
      INSERT INTO apache_logs.error_log_systemcode (name) VALUES (logsystemCode);
      SET logsystemCodeID = LAST_INSERT_ID();
  END IF;

  RETURN logsystemCodeID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_systemMessageID`(logsystemMessage varchar(400)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logsystemMessageID INTEGER DEFAULT null;
  SELECT id
    INTO logsystemMessageID
    FROM apache_logs.error_log_systemmessage
    WHERE name = logsystemMessage;

  IF logsystemMessageID IS NULL THEN
      INSERT INTO apache_logs.error_log_systemmessage (name) VALUES (logsystemMessage);
      SET logsystemMessageID = LAST_INSERT_ID();
  END IF;

  RETURN logsystemMessageID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `error_threadID`(logthreadid varchar(100)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE logthreadidID INTEGER DEFAULT null;
  SELECT id
    INTO logthreadidID
    FROM apache_logs.error_log_threadid
    WHERE name = logthreadid;

  IF logthreadidID IS NULL THEN
      INSERT INTO apache_logs.error_log_threadid (name) VALUES (logthreadid);
      SET logthreadidID = LAST_INSERT_ID();
  END IF;

  RETURN logthreadidID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `importFileExists`(importFile varchar(300)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importFileID INTEGER DEFAULT null;
  SELECT id
    INTO importFileID
    FROM apache_logs.import_file
    WHERE name = importFile;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `importFileID`(importFile varchar(300)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importFileID INTEGER DEFAULT null;
  SELECT id
    INTO importFileID
    FROM apache_logs.import_file
    WHERE name = importFile;
  IF importFileID IS NULL THEN
      INSERT INTO apache_logs.import_file (name) VALUES (importFile);
      SET importFileID = LAST_INSERT_ID();
  END IF;
  RETURN importFileID;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `importProcessID`(importProcess varchar(300)) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importProcessID INTEGER DEFAULT null;
  SELECT id
    INTO importProcessID
    FROM apache_logs.import_process
    WHERE name = importProcess;

  IF importProcessID IS NULL THEN
    INSERT INTO apache_logs.import_process
      (name,
      dbuser,
      dbhost,
      dbversion,
      dbsystem,
      dbmachine,
      serveruuid)
    VALUES
      (importProcess,
      user(),
		  @@hostname,
		  @@version,
      @@version_compile_os,
      @@version_compile_machine,
   		@@server_uuid);

    SET importProcessID = LAST_INSERT_ID();
  END IF;

  RETURN importProcessID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `processImportFile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `processImportFile`(importfileid INTEGER, processid INTEGER) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE importFileName VARCHAR(300) DEFAULT null;
  DECLARE checkProcessID INTEGER DEFAULT null;
  DECLARE processFile INTEGER DEFAULT 1;
  SELECT name,
         importprocessid 
    INTO importFileName,
         checkProcessID
    FROM apache_logs.import_file
    WHERE id = importfileid;

  -- IF none of these things happen all is well. processing records from same file.
  IF importFileName IS NULL THEN
  -- This is an error. Import File must be in table when import processing.
    SET processFile = 0;
    SIGNAL SQLSTATE
      'ERR0R'
    SET
      MESSAGE_TEXT = `Import File is not found in import_file table. An error has happened.`,
      MYSQL_ERRNO = `410`;

  ELSEIF processid IS NULL THEN
  -- This is an error. This function is only called when import processing. ProcessID must be valid.
    SET processFile = 0;
    SIGNAL SQLSTATE
      'ERR0R'
    SET
      MESSAGE_TEXT = `ProcessID required when import processing. An error has happpened.`,
      MYSQL_ERRNO = `411`;

  ELSEIF checkProcessID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE apache_logs.import_file SET importprocessid = processid WHERE id = importFileID;

  ELSEIF processid != checkProcessID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      'ERR0R'
    SET
      MESSAGE_TEXT = `File has already been processed in previous import process.  An error has happpened.`,
      MYSQL_ERRNO = `412`;

  END IF;
  RETURN processFile;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `importLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `importLog`(
  IN in_process VARCHAR(100),
  IN in_details VARCHAR(4000),
  IN in_err_sqlstate VARCHAR(250),
  IN in_err_message VARCHAR(250),
  IN in_err_mysqlno VARCHAR(250),
  IN in_importfileid INTEGER,
  IN in_importprocessid INTEGER
)
BEGIN
  INSERT INTO apache_logs.import_log
    (dbuser,
    dbhost,
    dbversion,
    dbsystem,
    dbmachine,
    serveruuid,
    process,
    details,
    err_sqlstate,
    err_message,
    err_mysqlno,
    importfileid,
    importprocessid)
  VALUES
    (user(),
    @@hostname,
	  @@version,
    @@version_compile_os,
    @@version_compile_machine,
  	@@server_uuid,
    in_process,
    in_details,
    in_err_sqlstate,
    in_err_message,
    in_err_mysqlno,
    in_importfileid,
    in_importprocessid);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `import_access_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `import_access_log`(
    IN importTable VARCHAR(100)
)
BEGIN
	DECLARE done BOOL DEFAULT false;

	DECLARE processID INTEGER DEFAULT 0;
	DECLARE recordsAdded INTEGER DEFAULT 0;
	DECLARE filesAdded INTEGER DEFAULT 0;
	DECLARE processFile INTEGER DEFAULT NULL;

	DECLARE db_User VARCHAR(250) DEFAULT NULL;
	DECLARE db_Host VARCHAR(250) DEFAULT NULL;
  	DECLARE db_Version VARCHAR(50) DEFAULT NULL;
   	DECLARE db_System VARCHAR(50) DEFAULT NULL;
   	DECLARE db_Machine VARCHAR(50) DEFAULT NULL;
	DECLARE db_Server VARCHAR(250) DEFAULT NULL;

	DECLARE logTime VARCHAR(50) DEFAULT NULL;
	DECLARE logTimeConverted DATETIME DEFAULT now();
	DECLARE remoteHost VARCHAR(50) DEFAULT NULL;
	DECLARE remoteLogName VARCHAR(50) DEFAULT NULL;
	DECLARE remoteUser VARCHAR(50) DEFAULT NULL;
	DECLARE bytesReceived INTEGER DEFAULT 0;
	DECLARE bytesSent INTEGER DEFAULT 0;
	DECLARE bytesTransferred INTEGER DEFAULT 0;
	DECLARE reqTimeMilli INTEGER DEFAULT 0;
	DECLARE reqTimeMicro INTEGER DEFAULT 0;
	DECLARE reqDelayMilli INTEGER DEFAULT 0;
	DECLARE reqBytes INTEGER DEFAULT 0;
	DECLARE reqStatus INTEGER DEFAULT 0;
	DECLARE reqProtocol VARCHAR(100) DEFAULT NULL;
	DECLARE reqMethod VARCHAR(100) DEFAULT NULL;
	DECLARE reqUri VARCHAR(2000) DEFAULT NULL;
	DECLARE referer VARCHAR(2000) DEFAULT NULL;
	DECLARE refererConverted VARCHAR(2000) DEFAULT NULL;
	DECLARE userAgent VARCHAR(4000) DEFAULT NULL;
	DECLARE logSession VARCHAR(300) DEFAULT NULL;
	DECLARE logSessionConverted VARCHAR(300) DEFAULT NULL;
	DECLARE logHost VARCHAR(100) DEFAULT NULL;
	DECLARE importFile VARCHAR(300) DEFAULT NULL;
	DECLARE importid INTEGER DEFAULT NULL;
    
	DECLARE errno INT;
	DECLARE errmsg TEXT;

	DECLARE remoteHost_Id, 
		remoteLogName_Id, 
		remoteUser_Id, 
		reqStatus_Id, 
		reqProtocol_Id, 
		reqMethod_Id, 
		reqUri_Id, 
		referer_Id, 
		userAgent_Id, 
		logsession_Id, 
		loghost_Id, 
		importFile_Id 
		INTEGER DEFAULT NULL;

	-- declare cursor for extended format
	DECLARE importExtended CURSOR FOR SELECT 
		remote_host, 
		log_time, 
		bytes_received, 
		bytes_sent, 
		bytes_transferred, 
		reqtime_milli, 
		reqtime_micro, 
		reqdelay_milli, 
		req_bytes, 
		req_status, 
		req_protocol, 
		req_method, 
		req_uri, 
		log_referer, 
		log_useragent,
		log_session,
		log_host, 
		importfileid,
		id 
	FROM apache_logs.access_log_extended
   WHERE import_status=0;

	-- declare cursor for combined format
	DECLARE importVhost CURSOR FOR SELECT 
		server_name, 
		remote_host, 
		remote_logname, 
		remote_user, 
		log_time, 
		req_bytes, 
		req_status, 
		req_protocol, 
		req_method, 
		req_uri, 
		log_referer, 
		log_useragent,
		importfileid,
		id 
	FROM apache_logs.access_log_vhost
   WHERE import_status=0;

	-- declare cursor for combined format
	DECLARE importCombined CURSOR FOR SELECT 
		remote_host, 
		remote_logname, 
		remote_user, 
		log_time, 
		req_bytes, 
		req_status, 
		req_protocol, 
		req_method, 
		req_uri, 
		log_referer, 
		log_useragent,
		importfileid,
		id 
	FROM apache_logs.access_log_combined
   WHERE import_status=0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, errmsg = MESSAGE_TEXT;
			SELECT errno AS MYSQL_ERROR, errmsg AS MYSQL_MESSAGE;
			ROLLBACK;
		END;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET done = true;

	START TRANSACTION;	
    SET processID = apache_logs.getImportProcessID(CONCAT('access log', ' - ', importTable));
        
    -- open the cursor
	IF importTable = 'extended' THEN
		OPEN importExtended;
	ELSEIF importTable = 'vhost' THEN
		OPEN importVhost;
	ELSE
		OPEN importCombined;
	END IF;	

    process_import: LOOP
		IF importTable = 'extended' THEN
			FETCH importExtended INTO 
			remoteHost, 
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
			referer, 
			userAgent,
			logSession,
			logHost, 
			importFile_Id,
            importid; 
		ELSEIF importTable = 'vhost' THEN
			FETCH importVhost INTO 
			logHost, 
			remoteHost, 
			remoteUser, 
			remoteLogName, 
			logTime, 
			reqBytes, 
			reqStatus, 
			reqProtocol, 
			reqMethod, 
			reqUri, 
			referer, 
			userAgent,
			importFile_Id,
            importid; 
		ELSE
			FETCH importCombined INTO 
			remoteHost, 
			remoteUser, 
			remoteLogName, 
			logTime, 
			reqBytes, 
			reqStatus, 
			reqProtocol, 
			reqMethod, 
			reqUri, 
			referer, 
			userAgent,
			importFile_Id,
            importid; 
		END IF;

		IF done = true THEN 
			LEAVE process_import;
		END IF;

		SET processFile = apache_logs.processImportFile(importFile_Id, processID);
		IF processFile = 0 THEN
			ROLLBACK;
			LEAVE process_import;
        END IF;

		SET recordsAdded = recordsAdded + 1;
        -- convert import staging columns - log_time, referer and log_session
		IF POSITION("?" IN referer)>0 THEN
			SET refererConverted = SUBSTR(referer,1,(POSITION("?" IN referer)-1));
		ELSE
			SET refererConverted = referer;
		END IF;
		IF POSITION("[" IN logTime)>0 THEN
			SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime,2,20),'%d/%b/%Y:%H:%i:%s');
		ELSE
			SET logTimeConverted = STR_TO_DATE(SUBSTR(logTime,1,20),'%d/%b/%Y:%H:%i:%s');
		END IF;
		IF logSession IS NULL THEN
			SET logSessionConverted = NULL;
		ELSEIF logSession != '-' THEN
			SET logSessionConverted = SUBSTR(logSession,3,POSITION('.' IN logSession)-3);
		ELSE
			SET logSessionConverted = 'Empty Session';
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
		IF remoteHost IS NOT NULL THEN
			SET remoteHost_Id = apache_logs.access_remoteHostID(remoteHost);
        END IF;
		IF remoteLogName IS NOT NULL THEN
			SET remoteLogName_Id = apache_logs.access_remoteLogNameID(remoteLogName);
        END IF;
		IF remoteUser IS NOT NULL THEN
			SET remoteUser_Id = apache_logs.access_remoteUserID(remoteUser);
        END IF;
		IF refererConverted IS NOT NULL THEN
			SET referer_Id = apache_logs.access_refererID(refererConverted);
        END IF;
		IF userAgent IS NOT NULL THEN
			SET userAgent_Id = apache_logs.access_userAgentID(userAgent);
        END IF;
		IF logHost IS NOT NULL THEN
			SET loghost_Id = apache_logs.access_hostID(logHost);
        END IF;
		IF logSessionConverted IS NOT NULL THEN
			SET logsession_Id = apache_logs.access_sessionID(logSessionConverted);
        END IF;
		INSERT INTO apache_logs.access_log (timeStamp, 
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
			remotehostid, 
			refererid, 
			useragentid,
			sessionid,
			hostid, 
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
			remoteHost_Id,
			referer_Id,
			userAgent_Id,
			logsession_Id,
			loghost_Id, 
			importfile_Id);

		IF importTable = 'extended' THEN
			UPDATE apache_logs.access_log_extended SET import_status=1 WHERE id=importid;
		ELSEIF importTable = 'vhost' THEN
			UPDATE apache_logs.access_log_vhost SET import_status=1 WHERE id=importid;
		ELSE
			UPDATE apache_logs.access_log_combined SET import_status=1 WHERE id=importid;
		END IF;	
	END LOOP;
    -- update import process table
	SELECT user(),
		@@hostname,
		@@version,
        @@version_compile_os,
        @@version_compile_machine,
   		@@server_uuid
	INTO 
		db_User,
		db_Host,
        db_Version,
        db_System,
        db_Machine,
		db_Server;

	SELECT COUNT(DISTINCT(importfileid))
	INTO filesAdded
	FROM access_log
	INNER JOIN import_file
	ON access_log.importfileid = import_file.id
	WHERE import_file.importprocessid=processid;

	UPDATE apache_logs.import_process 
       SET dbuser = db_User, 
           dbhost = db_Host, 
           dbversion = db_Version, 
           dbsystem = db_System, 
           dbmachine = db_Machine, 
           serveruuid = db_Server, 
           records = recordsAdded, 
           files = filesAdded, 
           completed = now() 
     WHERE id = processID;

	COMMIT;
    -- close the cursor
	IF importTable = 'extended' THEN
		CLOSE importExtended;
	ELSEIF importTable = 'vhost' THEN
		CLOSE importVhost;
	ELSE
		CLOSE importCombined;
	END IF;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `import_error_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `import_error_log`(
    IN importTable VARCHAR(100)
)
BEGIN
	DECLARE done BOOL DEFAULT false;

	DECLARE processID INTEGER DEFAULT 0;
	DECLARE recordsAdded INTEGER DEFAULT 0;
	DECLARE filesAdded INTEGER DEFAULT 0;
	DECLARE processFile INTEGER DEFAULT NULL;

	DECLARE db_User VARCHAR(250) DEFAULT NULL;
	DECLARE db_Host VARCHAR(250) DEFAULT NULL;
  	DECLARE db_Version VARCHAR(50) DEFAULT NULL;
   	DECLARE db_System VARCHAR(50) DEFAULT NULL;
   	DECLARE db_Machine VARCHAR(50) DEFAULT NULL;
	DECLARE db_Server VARCHAR(250) DEFAULT NULL;

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
	DECLARE log_reqClient VARCHAR(200) DEFAULT NULL;
	DECLARE log_referer VARCHAR(500) DEFAULT NULL;
	DECLARE importFile VARCHAR(300) DEFAULT NULL;
	DECLARE importid INTEGER DEFAULT NULL;

	DECLARE errno INT;
	DECLARE errmsg TEXT;

	DECLARE logLevel_Id,
		module_Id,
		process_Id, 
		thread_Id, 
		apacheCode_Id, 
		apacheMessage_Id, 
		systemCode_Id, 
		systemMessage_Id, 
		logMessage_Id, 
		reqClient_Id, 
		referer_Id, 
		importFile_Id 
		INTEGER DEFAULT NULL;

	DECLARE importDefault CURSOR FOR SELECT 
		logtime, 
		loglevel, 
		module, 
		processid, 
		threadid, 
		apachecode, 
		apachemessage, 
		systemcode, 
		systemmessage, 
		logmessage, 
		reqclient, 
		referer,
        importfileid,
        id
	FROM apache_logs.error_log_default
    WHERE import_status = 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO, errmsg = MESSAGE_TEXT;
			SELECT errno AS MYSQL_ERROR, errmsg AS MYSQL_MESSAGE;
			ROLLBACK;
		END;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET done = true;

	START TRANSACTION;	
    SET processID = apache_logs.getImportProcessID(CONCAT('error log', ' - ', importTable));

	OPEN importDefault;

    process_import: LOOP
		FETCH importDefault INTO 
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
			log_reqClient, 
			log_referer, 
			importFile_Id,
            importid; 
        
		IF done = true THEN 
			LEAVE process_import;
		END IF;

		SET processFile = apache_logs.processImportFile(importFile_Id, processID);
		IF processFile = 0 THEN
			ROLLBACK;
			LEAVE process_import;
        END IF;

		SET recordsAdded = recordsAdded + 1;

		SET logLevel_Id = null,
		module_Id = null,
		process_Id = null, 
		thread_Id = null, 
		apacheCode_Id = null, 
		apacheMessage_Id = null, 
		systemCode_Id = null, 
		systemMessage_Id = null, 
		logMessage_Id = null, 
		reqClient_Id = null, 
		referer_Id = null;

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
		IF log_reqClient IS NOT NULL THEN
			SET reqClient_id = apache_logs.error_reqClientID(log_reqClient);
		END IF;
		IF log_referer IS NOT NULL THEN
			SET referer_Id = apache_logs.error_refererID(log_referer);
		END IF;
		INSERT INTO apache_logs.error_log (timeStamp, 
			loglevelid,
			moduleid,
			processid, 
			threadid, 
			apachecodeid, 
			apachemessageid, 
			systemcodeid, 
			systemmessageid, 
			logmessageid, 
			reqclientid, 
			refererid,
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
			reqClient_Id, 
			referer_Id,
            importFile_Id);
	
		UPDATE apache_logs.error_log_default SET import_status=1 WHERE id=importid;
    END LOOP;
    -- update import process table
	SELECT user(),
		@@hostname,
		@@version,
        @@version_compile_os,
        @@version_compile_machine,
   		@@server_uuid
	INTO 
		db_User,
		db_Host,
        db_Version,
        db_System,
        db_Machine,
		db_Server;

	SELECT COUNT(DISTINCT(importfileid))
	INTO filesAdded
	FROM error_log
	INNER JOIN import_file
	ON error_log.importfileid = import_file.id
	WHERE import_file.importprocessid=processid;

	UPDATE apache_logs.import_process 
       SET dbuser = db_User, 
           dbhost = db_Host, 
           dbversion = db_Version, 
           dbsystem = db_System, 
           dbmachine = db_Machine, 
           serveruuid = db_Server, 
           records = recordsAdded, 
           files = filesAdded, 
           completed = now() 
     WHERE id = processID;

	COMMIT;
    -- close the cursor
	CLOSE importDefault;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `access_host_list`
--

/*!50001 DROP VIEW IF EXISTS `access_host_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_host_list` AS select `ln`.`name` AS `Access Log Host`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_host` `ln` join `access_log` `l` on((`l`.`hostid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_importfile_list` AS select `ln`.`name` AS `Access Log Import File`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`import_file` `ln` join `access_log` `l` on((`l`.`importfileid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_referer_list` AS select `ln`.`name` AS `Access Log Referer`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_referer` `ln` join `access_log` `l` on((`l`.`refererid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_remotehost_list`
--

/*!50001 DROP VIEW IF EXISTS `access_remotehost_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_remotehost_list` AS select `ln`.`name` AS `Access Log Remote Host`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_remotehost` `ln` join `access_log` `l` on((`l`.`remotehostid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_remotelogname_list` AS select `ln`.`name` AS `Access Log Remote Log Name`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_remotelogname` `ln` join `access_log` `l` on((`l`.`remotelognameid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_remoteuser_list` AS select `ln`.`name` AS `Access Log Remote User`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_remoteuser` `ln` join `access_log` `l` on((`l`.`remoteuserid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqmethod_list` AS select `ln`.`name` AS `Access Log Method`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_reqmethod` `ln` join `access_log` `l` on((`l`.`reqmethodid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqprotocol_list` AS select `ln`.`name` AS `Access Log Protocol`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_reqprotocol` `ln` join `access_log` `l` on((`l`.`reqstatusid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_reqstatus_list` AS select `ln`.`name` AS `Access Log Status`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_reqstatus` `ln` join `access_log` `l` on((`l`.`reqstatusid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_requri_list` AS select `ln`.`name` AS `Access Log URI`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_requri` `ln` join `access_log` `l` on((`l`.`requriid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `access_session_list`
--

/*!50001 DROP VIEW IF EXISTS `access_session_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_session_list` AS select `ln`.`name` AS `Access Log Session`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_session` `ln` join `access_log` `l` on((`l`.`sessionid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_browser_family_list` AS select `ln`.`ua_browser_family` AS `Browser Family`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_browser_family` order by `ln`.`ua_browser_family` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_browser_list` AS select `ln`.`ua_browser` AS `Browser`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_browser` order by `ln`.`ua_browser` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_browser_version_list` AS select `ln`.`ua_browser_version` AS `Browser Version`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_browser_version` order by `ln`.`ua_browser_version` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_brand_list` AS select `ln`.`ua_device_brand` AS `Device Brand`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device_brand` order by `ln`.`ua_device_brand` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_family_list` AS select `ln`.`ua_device_family` AS `Device Family`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device_family` order by `ln`.`ua_device_family` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_list` AS select `ln`.`ua_device` AS `Device`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device` order by `ln`.`ua_device` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_device_model_list` AS select `ln`.`ua_device_model` AS `Device Model`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_device_model` order by `ln`.`ua_device_model` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_list` AS select `ln`.`name` AS `Access Log UserAgent`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_browser_device_list` AS select `ln`.`ua_os_family` AS `Operating System`,`ln`.`ua_browser_family` AS `Browser`,`ln`.`ua_device_family` AS `Device`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os_family`,`ln`.`ua_browser_family`,`ln`.`ua_device_family` order by `ln`.`ua_os_family`,`ln`.`ua_browser_family`,`ln`.`ua_device_family` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_family_list` AS select `ln`.`ua_os_family` AS `Operating System Family`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os_family` order by `ln`.`ua_os_family` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_list` AS select `ln`.`ua_os` AS `Operating System`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os` order by `ln`.`ua_os` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_os_version_list` AS select `ln`.`ua_os_version` AS `Operating System Version`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua_os_version` order by `ln`.`ua_os_version` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `access_useragent_pretty_list` AS select `ln`.`ua` AS `Access Log Pretty User Agent`,count(`l`.`id`) AS `Log Count`,format(sum(`l`.`reqbytes`),0) AS `HTTP Bytes`,format(sum(`l`.`bytes_sent`),0) AS `Bytes Sent`,format(sum(`l`.`bytes_received`),0) AS `Bytes Received`,format(sum(`l`.`bytes_transferred`),0) AS `Bytes Transferred`,format(max(`l`.`reqtime_milli`),0) AS `Max Request Time`,format(min(`l`.`reqtime_milli`),0) AS `Min Request Time`,format(max(`l`.`reqdelay_milli`),0) AS `Max Delay Time`,format(min(`l`.`reqdelay_milli`),0) AS `Min Delay Time` from (`access_log_useragent` `ln` join `access_log` `l` on((`l`.`useragentid` = `ln`.`id`))) group by `ln`.`ua` order by `ln`.`ua` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `error_apachemessage_list` AS select `ln`.`name` AS `Error Log Apache Message`,count(`l`.`id`) AS `Log Count` from (`error_log_apachemessage` `ln` join `error_log` `l` on((`l`.`apachemessageid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `error_module_list` AS select `ln`.`name` AS `Error Log Module`,count(`l`.`id`) AS `Log Count` from (`error_log_module` `ln` join `error_log` `l` on((`l`.`moduleid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `error_referer_list` AS select `ln`.`name` AS `Error Log Referer`,count(`l`.`id`) AS `Log Count` from (`error_log_referer` `ln` join `error_log` `l` on((`l`.`refererid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `error_reqclient_list`
--

/*!50001 DROP VIEW IF EXISTS `error_reqclient_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `error_reqclient_list` AS select `ln`.`name` AS `Error Log Client`,count(`l`.`id`) AS `Log Count` from (`error_log_reqclient` `ln` join `error_log` `l` on((`l`.`reqclientid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
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
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `error_threadid_list` AS select `ln`.`name` AS `Error Log ThreadID`,count(`l`.`id`) AS `Log Count` from (`error_log_threadid` `ln` join `error_log` `l` on((`l`.`threadid` = `ln`.`id`))) group by `ln`.`id` order by `ln`.`name` */;
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

-- Dump completed on 2024-10-29  0:11:31
