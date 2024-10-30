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
-- Table structure for table `ap_suppliers`
--

DROP TABLE IF EXISTS `ap_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ap_suppliers` (
  `vendor_id` double DEFAULT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `last_updated_by` double DEFAULT NULL,
  `vendor_name` varchar(240) DEFAULT NULL,
  `vendor_name_alt` varchar(320) DEFAULT NULL,
  `segment1` varchar(30) DEFAULT NULL,
  `summary_flag` varchar(1) DEFAULT NULL,
  `enabled_flag` varchar(1) DEFAULT NULL,
  `segment2` varchar(30) DEFAULT NULL,
  `segment3` varchar(30) DEFAULT NULL,
  `segment4` varchar(30) DEFAULT NULL,
  `segment5` varchar(30) DEFAULT NULL,
  `last_update_login` double DEFAULT NULL,
  `creation_date` datetime DEFAULT NULL,
  `created_by` double DEFAULT NULL,
  `employee_id` double DEFAULT NULL,
  `vendor_type_lookup_code` varchar(30) DEFAULT NULL,
  `customer_num` varchar(25) DEFAULT NULL,
  `one_time_flag` varchar(1) DEFAULT NULL,
  `parent_vendor_id` double DEFAULT NULL,
  `min_order_amount` double DEFAULT NULL,
  `ship_to_location_id` double DEFAULT NULL,
  `bill_to_location_id` double DEFAULT NULL,
  `ship_via_lookup_code` varchar(25) DEFAULT NULL,
  `freight_terms_lookup_code` varchar(25) DEFAULT NULL,
  `fob_lookup_code` varchar(25) DEFAULT NULL,
  `terms_id` double DEFAULT NULL,
  `set_of_books_id` double DEFAULT NULL,
  `credit_status_lookup_code` varchar(25) DEFAULT NULL,
  `credit_limit` double DEFAULT NULL,
  `always_take_disc_flag` varchar(1) DEFAULT NULL,
  `pay_date_basis_lookup_code` varchar(25) DEFAULT NULL,
  `pay_group_lookup_code` varchar(25) DEFAULT NULL,
  `payment_priority` double DEFAULT NULL,
  `invoice_currency_code` varchar(15) DEFAULT NULL,
  `payment_currency_code` varchar(15) DEFAULT NULL,
  `invoice_amount_limit` double DEFAULT NULL,
  `exchange_date_lookup_code` varchar(25) DEFAULT NULL,
  `hold_all_payments_flag` varchar(1) DEFAULT NULL,
  `hold_future_payments_flag` varchar(1) DEFAULT NULL,
  `hold_reason` varchar(240) DEFAULT NULL,
  `distribution_set_id` double DEFAULT NULL,
  `accts_pay_code_combination_id` double DEFAULT NULL,
  `disc_lost_code_combination_id` double DEFAULT NULL,
  `disc_taken_code_combination_id` double DEFAULT NULL,
  `expense_code_combination_id` double DEFAULT NULL,
  `prepay_code_combination_id` double DEFAULT NULL,
  `num_1099` varchar(30) DEFAULT NULL,
  `type_1099` varchar(10) DEFAULT NULL,
  `withholding_status_lookup_code` varchar(25) DEFAULT NULL,
  `withholding_start_date` datetime DEFAULT NULL,
  `organization_type_lookup_code` varchar(25) DEFAULT NULL,
  `vat_code` varchar(30) DEFAULT NULL,
  `start_date_active` datetime DEFAULT NULL,
  `end_date_active` datetime DEFAULT NULL,
  `minority_group_lookup_code` varchar(30) DEFAULT NULL,
  `payment_method_lookup_code` varchar(25) DEFAULT NULL,
  `bank_account_name` varchar(80) DEFAULT NULL,
  `bank_account_num` varchar(30) DEFAULT NULL,
  `bank_num` varchar(25) DEFAULT NULL,
  `bank_account_type` varchar(25) DEFAULT NULL,
  `women_owned_flag` varchar(1) DEFAULT NULL,
  `small_business_flag` varchar(1) DEFAULT NULL,
  `standard_industry_class` varchar(25) DEFAULT NULL,
  `hold_flag` varchar(1) DEFAULT NULL,
  `purchasing_hold_reason` varchar(240) DEFAULT NULL,
  `hold_by` bigint DEFAULT NULL,
  `hold_date` datetime DEFAULT NULL,
  `terms_date_basis` varchar(25) DEFAULT NULL,
  `price_tolerance` double DEFAULT NULL,
  `inspection_required_flag` varchar(1) DEFAULT NULL,
  `receipt_required_flag` varchar(1) DEFAULT NULL,
  `qty_rcv_tolerance` double DEFAULT NULL,
  `qty_rcv_exception_code` varchar(25) DEFAULT NULL,
  `enforce_ship_to_location_code` varchar(25) DEFAULT NULL,
  `days_early_receipt_allowed` double DEFAULT NULL,
  `days_late_receipt_allowed` double DEFAULT NULL,
  `receipt_days_exception_code` varchar(25) DEFAULT NULL,
  `receiving_routing_id` double DEFAULT NULL,
  `allow_substitute_receipts_flag` varchar(1) DEFAULT NULL,
  `allow_unordered_receipts_flag` varchar(1) DEFAULT NULL,
  `hold_unmatched_invoices_flag` varchar(1) DEFAULT NULL,
  `exclusive_payment_flag` varchar(1) DEFAULT NULL,
  `ap_tax_rounding_rule` varchar(1) DEFAULT NULL,
  `auto_tax_calc_flag` varchar(1) DEFAULT NULL,
  `auto_tax_calc_override` varchar(1) DEFAULT NULL,
  `amount_includes_tax_flag` varchar(1) DEFAULT NULL,
  `tax_verification_date` datetime DEFAULT NULL,
  `name_control` varchar(4) DEFAULT NULL,
  `state_reportable_flag` varchar(1) DEFAULT NULL,
  `federal_reportable_flag` varchar(1) DEFAULT NULL,
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
  `offset_vat_code` varchar(20) DEFAULT NULL,
  `vat_registration_num` varchar(20) DEFAULT NULL,
  `auto_calculate_interest_flag` varchar(1) DEFAULT NULL,
  `validation_number` double DEFAULT NULL,
  `exclude_freight_from_discount` varchar(1) DEFAULT NULL,
  `tax_reporting_name` varchar(80) DEFAULT NULL,
  `check_digits` varchar(30) DEFAULT NULL,
  `bank_number` varchar(30) DEFAULT NULL,
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
  `edi_payment_method` varchar(25) DEFAULT NULL,
  `edi_payment_format` varchar(25) DEFAULT NULL,
  `edi_remittance_method` varchar(25) DEFAULT NULL,
  `edi_remittance_instruction` varchar(256) DEFAULT NULL,
  `bank_charge_bearer` varchar(1) DEFAULT NULL,
  `bank_branch_type` varchar(25) DEFAULT NULL,
  `match_option` varchar(25) DEFAULT NULL,
  `future_dated_payment_ccid` bigint DEFAULT NULL,
  `create_debit_memo_flag` varchar(25) DEFAULT NULL,
  `offset_tax_flag` varchar(1) DEFAULT NULL,
  `party_id` double DEFAULT NULL,
  `parent_party_id` double DEFAULT NULL,
  `ni_number` varchar(30) DEFAULT NULL,
  `tca_sync_num_1099` varchar(30) DEFAULT NULL,
  `tca_sync_vendor_name` varchar(360) DEFAULT NULL,
  `tca_sync_vat_reg_num` varchar(50) DEFAULT NULL,
  `unique_tax_reference_num` bigint DEFAULT NULL,
  `partnership_utr` bigint DEFAULT NULL,
  `partnership_name` varchar(240) DEFAULT NULL,
  `cis_enabled_flag` varchar(1) DEFAULT NULL,
  `first_name` varchar(240) DEFAULT NULL,
  `second_name` varchar(240) DEFAULT NULL,
  `last_name` varchar(240) DEFAULT NULL,
  `salutation` varchar(30) DEFAULT NULL,
  `trading_name` varchar(240) DEFAULT NULL,
  `work_reference` varchar(30) DEFAULT NULL,
  `company_registration_number` varchar(30) DEFAULT NULL,
  `national_insurance_number` varchar(30) DEFAULT NULL,
  `verification_number` varchar(30) DEFAULT NULL,
  `verification_request_id` bigint DEFAULT NULL,
  `match_status_flag` varchar(1) DEFAULT NULL,
  `cis_verification_date` datetime DEFAULT NULL,
  `individual_1099` varchar(30) DEFAULT NULL,
  `pay_awt_group_id` bigint DEFAULT NULL,
  `cis_parent_vendor_id` double DEFAULT NULL,
  `bus_class_last_certified_date` datetime DEFAULT NULL,
  `bus_class_last_certified_by` double DEFAULT NULL,
  UNIQUE KEY `ap_suppliers_u1` (`vendor_id`),
  UNIQUE KEY `ap_suppliers_u2` (`segment1`),
  KEY `ap_suppliers_n1` (`employee_id`),
  KEY `ap_suppliers_n2` (`num_1099`),
  KEY `ap_suppliers_n3` (`parent_vendor_id`),
  KEY `ap_suppliers_n4` (`party_id`),
  KEY `ap_suppliers_n5` (`parent_party_id`),
  KEY `ap_suppliers_n6` (`vendor_name`),
  KEY `ap_suppliers_n8` (`individual_1099`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ap_suppliers`
--

LOCK TABLES `ap_suppliers` WRITE;
/*!40000 ALTER TABLE `ap_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_suppliers` ENABLE KEYS */;
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
