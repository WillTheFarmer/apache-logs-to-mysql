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
-- Table structure for table `ap_supplier_sites_all`
--

DROP TABLE IF EXISTS `ap_supplier_sites_all`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ap_supplier_sites_all` (
  `vendor_site_id` double DEFAULT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `last_updated_by` double DEFAULT NULL,
  `vendor_id` double DEFAULT NULL,
  `vendor_site_code` varchar(15) DEFAULT NULL,
  `vendor_site_code_alt` varchar(320) DEFAULT NULL,
  `last_update_login` double DEFAULT NULL,
  `creation_date` datetime DEFAULT NULL,
  `created_by` double DEFAULT NULL,
  `purchasing_site_flag` varchar(1) DEFAULT NULL,
  `rfq_only_site_flag` varchar(1) DEFAULT NULL,
  `pay_site_flag` varchar(1) DEFAULT NULL,
  `attention_ar_flag` varchar(1) DEFAULT NULL,
  `address_line1` varchar(240) DEFAULT NULL,
  `address_lines_alt` varchar(560) DEFAULT NULL,
  `address_line2` varchar(240) DEFAULT NULL,
  `address_line3` varchar(240) DEFAULT NULL,
  `city` varchar(60) DEFAULT NULL,
  `state` varchar(150) DEFAULT NULL,
  `zip` varchar(60) DEFAULT NULL,
  `province` varchar(150) DEFAULT NULL,
  `country` varchar(60) DEFAULT NULL,
  `area_code` varchar(10) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `customer_num` varchar(25) DEFAULT NULL,
  `ship_to_location_id` double DEFAULT NULL,
  `bill_to_location_id` double DEFAULT NULL,
  `ship_via_lookup_code` varchar(25) DEFAULT NULL,
  `freight_terms_lookup_code` varchar(25) DEFAULT NULL,
  `fob_lookup_code` varchar(25) DEFAULT NULL,
  `inactive_date` datetime DEFAULT NULL,
  `fax` varchar(15) DEFAULT NULL,
  `fax_area_code` varchar(10) DEFAULT NULL,
  `telex` varchar(15) DEFAULT NULL,
  `payment_method_lookup_code` varchar(25) DEFAULT NULL,
  `bank_account_name` varchar(80) DEFAULT NULL,
  `bank_account_num` varchar(30) DEFAULT NULL,
  `bank_num` varchar(25) DEFAULT NULL,
  `bank_account_type` varchar(25) DEFAULT NULL,
  `terms_date_basis` varchar(25) DEFAULT NULL,
  `current_catalog_num` varchar(20) DEFAULT NULL,
  `vat_code` varchar(30) DEFAULT NULL,
  `distribution_set_id` double DEFAULT NULL,
  `accts_pay_code_combination_id` double DEFAULT NULL,
  `prepay_code_combination_id` double DEFAULT NULL,
  `pay_group_lookup_code` varchar(25) DEFAULT NULL,
  `payment_priority` double DEFAULT NULL,
  `terms_id` double DEFAULT NULL,
  `invoice_amount_limit` double DEFAULT NULL,
  `pay_date_basis_lookup_code` varchar(25) DEFAULT NULL,
  `always_take_disc_flag` varchar(1) DEFAULT NULL,
  `invoice_currency_code` varchar(15) DEFAULT NULL,
  `payment_currency_code` varchar(15) DEFAULT NULL,
  `hold_all_payments_flag` varchar(1) DEFAULT NULL,
  `hold_future_payments_flag` varchar(1) DEFAULT NULL,
  `hold_reason` varchar(240) DEFAULT NULL,
  `hold_unmatched_invoices_flag` varchar(1) DEFAULT NULL,
  `ap_tax_rounding_rule` varchar(1) DEFAULT NULL,
  `auto_tax_calc_flag` varchar(1) DEFAULT NULL,
  `auto_tax_calc_override` varchar(1) DEFAULT NULL,
  `amount_includes_tax_flag` varchar(1) DEFAULT NULL,
  `exclusive_payment_flag` varchar(1) DEFAULT NULL,
  `tax_reporting_site_flag` varchar(1) DEFAULT NULL,
  `attribute_category` varchar(30) DEFAULT NULL,
  `attribute1` varchar(150) DEFAULT NULL,
  `attribute2` varchar(150) DEFAULT NULL,
  `attribute3` varchar(150) DEFAULT NULL,
  `attribute4` varchar(150) DEFAULT NULL,
  `attribute5` varchar(150) DEFAULT NULL,
  `attribute6` varchar(150) DEFAULT NULL,
  `attribute7` varchar(150) DEFAULT NULL,
  `attribute8` varchar(150) DEFAULT NULL,
  `attribute9` varchar(150) DEFAULT NULL,
  `attribute10` varchar(150) DEFAULT NULL,
  `attribute11` varchar(150) DEFAULT NULL,
  `attribute12` varchar(150) DEFAULT NULL,
  `attribute13` varchar(150) DEFAULT NULL,
  `attribute14` varchar(150) DEFAULT NULL,
  `attribute15` varchar(150) DEFAULT NULL,
  `request_id` double DEFAULT NULL,
  `program_application_id` double DEFAULT NULL,
  `program_id` double DEFAULT NULL,
  `program_update_date` datetime DEFAULT NULL,
  `validation_number` double DEFAULT NULL,
  `exclude_freight_from_discount` varchar(1) DEFAULT NULL,
  `vat_registration_num` varchar(20) DEFAULT NULL,
  `offset_vat_code` varchar(20) DEFAULT NULL,
  `org_id` double DEFAULT NULL,
  `check_digits` varchar(30) DEFAULT NULL,
  `bank_number` varchar(30) DEFAULT NULL,
  `address_line4` varchar(240) DEFAULT NULL,
  `county` varchar(150) DEFAULT NULL,
  `address_style` varchar(30) DEFAULT NULL,
  `language` varchar(30) DEFAULT NULL,
  `allow_awt_flag` varchar(1) DEFAULT NULL,
  `awt_group_id` bigint DEFAULT NULL,
  `global_attribute1` varchar(150) DEFAULT NULL,
  `global_attribute2` varchar(150) DEFAULT NULL,
  `global_attribute3` varchar(150) DEFAULT NULL,
  `global_attribute4` varchar(150) DEFAULT NULL,
  `global_attribute5` varchar(150) DEFAULT NULL,
  `global_attribute6` varchar(150) DEFAULT NULL,
  `global_attribute7` varchar(150) DEFAULT NULL,
  `global_attribute8` varchar(150) DEFAULT NULL,
  `global_attribute9` varchar(150) DEFAULT NULL,
  `global_attribute10` varchar(150) DEFAULT NULL,
  `global_attribute11` varchar(150) DEFAULT NULL,
  `global_attribute12` varchar(150) DEFAULT NULL,
  `global_attribute13` varchar(150) DEFAULT NULL,
  `global_attribute14` varchar(150) DEFAULT NULL,
  `global_attribute15` varchar(150) DEFAULT NULL,
  `global_attribute16` varchar(150) DEFAULT NULL,
  `global_attribute17` varchar(150) DEFAULT NULL,
  `global_attribute18` varchar(150) DEFAULT NULL,
  `global_attribute19` varchar(150) DEFAULT NULL,
  `global_attribute20` varchar(150) DEFAULT NULL,
  `global_attribute_category` varchar(30) DEFAULT NULL,
  `edi_transaction_handling` varchar(25) DEFAULT NULL,
  `edi_id_number` varchar(30) DEFAULT NULL,
  `edi_payment_method` varchar(25) DEFAULT NULL,
  `edi_payment_format` varchar(25) DEFAULT NULL,
  `edi_remittance_method` varchar(25) DEFAULT NULL,
  `bank_charge_bearer` varchar(1) DEFAULT NULL,
  `edi_remittance_instruction` varchar(256) DEFAULT NULL,
  `bank_branch_type` varchar(25) DEFAULT NULL,
  `pay_on_code` varchar(25) DEFAULT NULL,
  `default_pay_site_id` bigint DEFAULT NULL,
  `pay_on_receipt_summary_code` varchar(25) DEFAULT NULL,
  `tp_header_id` double DEFAULT NULL,
  `ece_tp_location_code` varchar(60) DEFAULT NULL,
  `pcard_site_flag` varchar(1) DEFAULT NULL,
  `match_option` varchar(25) DEFAULT NULL,
  `country_of_origin_code` varchar(2) DEFAULT NULL,
  `future_dated_payment_ccid` bigint DEFAULT NULL,
  `create_debit_memo_flag` varchar(25) DEFAULT NULL,
  `offset_tax_flag` varchar(1) DEFAULT NULL,
  `supplier_notif_method` varchar(25) DEFAULT NULL,
  `email_address` varchar(2000) DEFAULT NULL,
  `remittance_email` varchar(2000) DEFAULT NULL,
  `primary_pay_site_flag` varchar(1) DEFAULT NULL,
  `shipping_control` varchar(30) DEFAULT NULL,
  `selling_company_identifier` varchar(10) DEFAULT NULL,
  `gapless_inv_num_flag` varchar(1) DEFAULT NULL,
  `duns_number` varchar(30) DEFAULT NULL,
  `tolerance_id` bigint DEFAULT NULL,
  `location_id` bigint DEFAULT NULL,
  `party_site_id` bigint DEFAULT NULL,
  `services_tolerance_id` bigint DEFAULT NULL,
  `retainage_rate` double DEFAULT NULL,
  `tca_sync_state` varchar(150) DEFAULT NULL,
  `tca_sync_province` varchar(150) DEFAULT NULL,
  `tca_sync_county` varchar(150) DEFAULT NULL,
  `tca_sync_city` varchar(60) DEFAULT NULL,
  `tca_sync_zip` varchar(60) DEFAULT NULL,
  `tca_sync_country` varchar(60) DEFAULT NULL,
  `pay_awt_group_id` bigint DEFAULT NULL,
  `cage_code` varchar(5) DEFAULT NULL,
  `legal_business_name` varchar(240) DEFAULT NULL,
  `doing_bus_as_name` varchar(240) DEFAULT NULL,
  `division_name` varchar(60) DEFAULT NULL,
  `small_business_code` varchar(10) DEFAULT NULL,
  `ccr_comments` varchar(240) DEFAULT NULL,
  `debarment_start_date` datetime DEFAULT NULL,
  `debarment_end_date` datetime DEFAULT NULL,
  UNIQUE KEY `ap_supplier_sites_u1` (`vendor_site_id`),
  UNIQUE KEY `ap_supplier_sites_u2` (`vendor_id`,`vendor_site_code`,`org_id`),
  KEY `ap_supplier_sites_n1` (`vendor_site_code`),
  KEY `ap_supplier_sites_n2` (`tp_header_id`,`ece_tp_location_code`),
  KEY `ap_supplier_sites_n3` (`ece_tp_location_code`),
  KEY `ap_supplier_sites_n4` (`selling_company_identifier`),
  KEY `ap_supplier_sites_n5` (`location_id`),
  KEY `ap_supplier_sites_n6` (`party_site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_supplier_sites_all`
--

LOCK TABLES `ap_supplier_sites_all` WRITE;
/*!40000 ALTER TABLE `ap_supplier_sites_all` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_supplier_sites_all` ENABLE KEYS */;
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
