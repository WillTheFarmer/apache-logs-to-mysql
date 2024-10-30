CREATE DATABASE  IF NOT EXISTS `ap` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ap`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: ap
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
-- Table structure for table `ap_expense_report_params_all`
--

DROP TABLE IF EXISTS `ap_expense_report_params_all`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ap_expense_report_params_all` (
  `parameter_id` double DEFAULT NULL,
  `expense_report_id` double DEFAULT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `last_updated_by` double DEFAULT NULL,
  `prompt` varchar(40) DEFAULT NULL,
  `line_type_lookup_code` varchar(25) DEFAULT NULL,
  `vat_code` varchar(30) DEFAULT NULL,
  `flex_ccid` double DEFAULT NULL,
  `flex_description` varchar(240) DEFAULT NULL,
  `flex_concactenated` varchar(240) DEFAULT NULL,
  `summary_flag` varchar(1) DEFAULT NULL,
  `last_update_login` bigint DEFAULT NULL,
  `creation_date` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `org_id` bigint DEFAULT NULL,
  `web_enabled_flag` varchar(1) DEFAULT NULL,
  `web_friendly_prompt` varchar(80) DEFAULT NULL,
  `web_image_filename` varchar(240) DEFAULT NULL,
  `justification_required_flag` varchar(1) DEFAULT NULL,
  `receipt_required_flag` varchar(1) DEFAULT NULL,
  `amount_includes_tax_flag` varchar(1) DEFAULT NULL,
  `web_sequence` double DEFAULT NULL,
  `calculate_amount_flag` varchar(1) DEFAULT NULL,
  `require_receipt_amount` double DEFAULT NULL,
  `pa_expenditure_type` varchar(30) DEFAULT NULL,
  `card_exp_type_lookup_code` varchar(30) DEFAULT NULL,
  `itemization_required_flag` varchar(1) DEFAULT NULL,
  `itemization_all_flag` varchar(1) DEFAULT NULL,
  `company_policy_id` bigint DEFAULT NULL,
  `category_code` varchar(30) DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `expense_type_code` varchar(30) DEFAULT NULL,
  `data_capture_rule_id` bigint DEFAULT NULL,
  `duplicates_allowed` double DEFAULT NULL,
  `card_require_receipt_amount` double DEFAULT NULL,
  `neg_receipt_required_flag` varchar(1) DEFAULT NULL,
  `zd_edition_name` varchar(30) DEFAULT 'ora$base',
  UNIQUE KEY `ap_expense_report_params_u1` (`parameter_id`,`zd_edition_name`),
  UNIQUE KEY `ap_expense_report_params_u2` (`expense_report_id`,`prompt`,`org_id`,`zd_edition_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_expense_report_params_all`
--

LOCK TABLES `ap_expense_report_params_all` WRITE;
/*!40000 ALTER TABLE `ap_expense_report_params_all` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_expense_report_params_all` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-26 23:08:25
