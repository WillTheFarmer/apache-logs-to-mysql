CREATE DATABASE  IF NOT EXISTS `ap` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ap`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
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
-- Table structure for table `ap_system_parameters_all`
--

DROP TABLE IF EXISTS `ap_system_parameters_all`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ap_system_parameters_all` (
  `last_update_date` datetime DEFAULT NULL,
  `last_updated_by` bigint DEFAULT NULL,
  `set_of_books_id` bigint DEFAULT NULL,
  `base_currency_code` varchar(15) DEFAULT NULL,
  `recalc_pay_schedule_flag` varchar(1) DEFAULT NULL,
  `auto_calculate_interest_flag` varchar(1) DEFAULT NULL,
  `invoice_currency_code` varchar(15) DEFAULT NULL,
  `payment_currency_code` varchar(15) DEFAULT NULL,
  `invoice_net_gross_flag` varchar(1) DEFAULT NULL,
  `bank_account_id` bigint DEFAULT NULL,
  `check_overflow_lookup_code` varchar(25) DEFAULT NULL,
  `batch_control_flag` varchar(1) DEFAULT NULL,
  `terms_id` bigint DEFAULT NULL,
  `always_take_disc_flag` varchar(1) DEFAULT NULL,
  `pay_date_basis_lookup_code` varchar(25) DEFAULT NULL,
  `accts_pay_code_combination_id` bigint DEFAULT NULL,
  `sales_tax_code_combination_id` bigint DEFAULT NULL,
  `disc_lost_code_combination_id` bigint DEFAULT NULL,
  `disc_taken_code_combination_id` bigint DEFAULT NULL,
  `hold_gain_code_combination_id` bigint DEFAULT NULL,
  `trans_gain_code_combination_id` bigint DEFAULT NULL,
  `apply_advances_default` varchar(4) DEFAULT NULL,
  `add_days_settlement_date` bigint DEFAULT NULL,
  `cost_of_money` double DEFAULT NULL,
  `days_between_check_cycles` bigint DEFAULT NULL,
  `federal_identification_num` varchar(20) DEFAULT NULL,
  `location_id` bigint DEFAULT NULL,
  `create_employee_vendor_flag` varchar(1) DEFAULT NULL,
  `employee_terms_id` bigint DEFAULT NULL,
  `employee_pay_group_lookup_code` varchar(25) DEFAULT NULL,
  `employee_payment_priority` tinyint DEFAULT NULL,
  `prepay_code_combination_id` bigint DEFAULT NULL,
  `confirm_date_as_inv_num_flag` varchar(1) DEFAULT NULL,
  `update_pay_site_flag` varchar(1) DEFAULT NULL,
  `default_exchange_rate_type` varchar(30) DEFAULT NULL,
  `gain_code_combination_id` bigint DEFAULT NULL,
  `loss_code_combination_id` bigint DEFAULT NULL,
  `make_rate_mandatory_flag` varchar(1) DEFAULT NULL,
  `multi_currency_flag` varchar(1) DEFAULT NULL,
  `gl_date_from_receipt_flag` varchar(25) DEFAULT NULL,
  `disc_is_inv_less_tax_flag` varchar(1) DEFAULT NULL,
  `match_on_tax_flag` varchar(1) DEFAULT NULL,
  `accounting_method_option` varchar(25) DEFAULT NULL,
  `expense_post_option` varchar(25) DEFAULT NULL,
  `discount_taken_post_option` varchar(25) DEFAULT NULL,
  `gain_loss_post_option` varchar(25) DEFAULT NULL,
  `cash_post_option` varchar(25) DEFAULT NULL,
  `future_pay_post_option` varchar(25) DEFAULT NULL,
  `date_format_lookup_code` varchar(25) DEFAULT NULL,
  `replace_check_flag` varchar(1) DEFAULT NULL,
  `online_print_flag` varchar(1) DEFAULT NULL,
  `eft_user_number` varchar(30) DEFAULT NULL,
  `max_outlay` double DEFAULT NULL,
  `vendor_pay_group_lookup_code` varchar(25) DEFAULT NULL,
  `require_tax_entry_flag` varchar(1) DEFAULT NULL,
  `approvals_option` varchar(25) DEFAULT NULL,
  `post_dated_payments_flag` varchar(1) DEFAULT NULL,
  `secondary_accounting_method` varchar(25) DEFAULT NULL,
  `secondary_set_of_books_id` bigint DEFAULT NULL,
  `take_vat_before_discount_flag` varchar(1) DEFAULT NULL,
  `interest_tolerance_amount` double DEFAULT NULL,
  `interest_code_combination_id` bigint DEFAULT NULL,
  `terms_date_basis` varchar(25) DEFAULT NULL,
  `allow_future_pay_flag` varchar(1) DEFAULT NULL,
  `auto_tax_calc_flag` varchar(1) DEFAULT NULL,
  `automatic_offsets_flag` varchar(1) DEFAULT NULL,
  `liability_post_lookup_code` varchar(25) DEFAULT NULL,
  `interest_accts_pay_ccid` bigint DEFAULT NULL,
  `liability_post_option` varchar(25) DEFAULT NULL,
  `discount_distribution_method` varchar(25) DEFAULT NULL,
  `rate_var_code_combination_id` bigint DEFAULT NULL,
  `combined_filing_flag` varchar(1) DEFAULT NULL,
  `income_tax_region` varchar(10) DEFAULT NULL,
  `income_tax_region_flag` varchar(1) DEFAULT NULL,
  `hold_unmatched_invoices_flag` varchar(1) DEFAULT NULL,
  `allow_dist_match_flag` varchar(1) DEFAULT NULL,
  `allow_final_match_flag` varchar(1) DEFAULT NULL,
  `allow_flex_override_flag` varchar(1) DEFAULT NULL,
  `allow_paid_invoice_adjust` varchar(1) DEFAULT NULL,
  `ussgl_transaction_code` varchar(30) DEFAULT NULL,
  `ussgl_trx_code_context` varchar(30) DEFAULT NULL,
  `inv_doc_category_override` varchar(1) DEFAULT NULL,
  `pay_doc_category_override` varchar(1) DEFAULT NULL,
  `vendor_auto_int_default` varchar(1) DEFAULT NULL,
  `summary_journals_default` varchar(1) DEFAULT NULL,
  `rate_var_gain_ccid` bigint DEFAULT NULL,
  `rate_var_loss_ccid` bigint DEFAULT NULL,
  `transfer_desc_flex_flag` varchar(1) DEFAULT NULL,
  `allow_awt_flag` varchar(1) DEFAULT NULL,
  `default_awt_group_id` bigint DEFAULT NULL,
  `allow_awt_override` varchar(1) DEFAULT NULL,
  `create_awt_dists_type` varchar(25) DEFAULT NULL,
  `create_awt_invoices_type` varchar(25) DEFAULT NULL,
  `awt_include_discount_amt` varchar(1) DEFAULT NULL,
  `awt_include_tax_amt` varchar(1) DEFAULT NULL,
  `org_id` bigint DEFAULT NULL,
  `recon_accounting_flag` varchar(1) DEFAULT NULL,
  `auto_create_freight_flag` varchar(1) DEFAULT NULL,
  `freight_code_combination_id` bigint DEFAULT NULL,
  `global_attribute_category` varchar(150) DEFAULT NULL,
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
  `allow_supplier_bank_override` varchar(1) DEFAULT NULL,
  `use_multiple_supplier_banks` varchar(1) DEFAULT NULL,
  `ap_tax_rounding_rule` varchar(1) DEFAULT NULL,
  `auto_tax_calc_override` varchar(1) DEFAULT NULL,
  `amount_includes_tax_flag` varchar(1) DEFAULT NULL,
  `amount_includes_tax_override` varchar(1) DEFAULT NULL,
  `vat_code` varchar(15) DEFAULT NULL,
  `precision` tinyint DEFAULT NULL,
  `minimum_accountable_unit` double DEFAULT NULL,
  `use_bank_charge_flag` varchar(1) DEFAULT NULL,
  `bank_charge_bearer` varchar(1) DEFAULT NULL,
  `rounding_error_ccid` bigint DEFAULT NULL,
  `rounding_error_post_option` varchar(25) DEFAULT NULL,
  `tax_from_po_flag` varchar(1) DEFAULT NULL,
  `tax_from_vendor_site_flag` varchar(1) DEFAULT NULL,
  `tax_from_vendor_flag` varchar(1) DEFAULT NULL,
  `tax_from_account_flag` varchar(1) DEFAULT NULL,
  `tax_from_system_flag` varchar(1) DEFAULT NULL,
  `tax_from_inv_header_flag` varchar(1) DEFAULT NULL,
  `tax_from_template_flag` varchar(1) DEFAULT NULL,
  `tax_hier_po_shipment` double DEFAULT NULL,
  `tax_hier_vendor` double DEFAULT NULL,
  `tax_hier_vendor_site` double DEFAULT NULL,
  `tax_hier_account` double DEFAULT NULL,
  `tax_hier_system` double DEFAULT NULL,
  `tax_hier_invoice` double DEFAULT NULL,
  `tax_hier_template` double DEFAULT NULL,
  `enforce_tax_from_account` varchar(1) DEFAULT NULL,
  `mrc_base_currency_code` varchar(2000) DEFAULT NULL,
  `mrc_secondary_set_of_books_id` varchar(2000) DEFAULT NULL,
  `match_option` varchar(25) DEFAULT NULL,
  `gain_loss_calc_level` varchar(30) DEFAULT NULL,
  `when_to_account_pmt` varchar(30) DEFAULT NULL,
  `when_to_account_gain_loss` varchar(30) DEFAULT NULL,
  `future_dated_pmt_acct_source` varchar(30) DEFAULT NULL,
  `future_dated_pmt_liab_relief` varchar(30) DEFAULT NULL,
  `gl_transfer_allow_override` varchar(1) DEFAULT NULL,
  `gl_transfer_process_days` bigint DEFAULT NULL,
  `gl_transfer_mode` varchar(1) DEFAULT NULL,
  `gl_transfer_submit_journal_imp` varchar(1) DEFAULT NULL,
  `include_reporting_sob` varchar(1) DEFAULT NULL,
  `expense_report_id` bigint DEFAULT NULL,
  `prepayment_terms_id` bigint DEFAULT NULL,
  `calc_user_xrate` varchar(1) DEFAULT NULL,
  `sort_by_alternate_field` varchar(1) DEFAULT NULL,
  `approval_workflow_flag` varchar(1) DEFAULT NULL,
  `allow_force_approval_flag` varchar(1) DEFAULT NULL,
  `validate_before_approval_flag` varchar(1) DEFAULT NULL,
  `xml_payments_auto_confirm_flag` varchar(1) DEFAULT NULL,
  `prorate_int_inv_across_dists` varchar(1) DEFAULT NULL,
  `build_prepayment_accounts_flag` varchar(1) DEFAULT NULL,
  `enable_1099_on_awt_flag` varchar(1) DEFAULT NULL,
  `stop_prepay_across_bal_flag` varchar(1) DEFAULT NULL,
  `automatic_offsets_change_flag` varchar(1) DEFAULT NULL,
  `tolerance_id` bigint DEFAULT NULL,
  `prepay_tax_diff_ccid` bigint DEFAULT NULL,
  `ce_bank_acct_use_id` bigint DEFAULT NULL,
  `approval_timing` varchar(30) DEFAULT NULL,
  `services_tolerance_id` bigint DEFAULT NULL,
  `receipt_acceptance_days` bigint DEFAULT NULL,
  `tax_tolerance` double DEFAULT NULL,
  `tax_tol_amt_range` double DEFAULT NULL,
  `allow_inv_third_party_ovrd` varchar(1) DEFAULT NULL,
  `allow_pymt_third_party_ovrd` varchar(1) DEFAULT NULL,
  `withholding_date_basis` varchar(20) DEFAULT NULL,
  `invrate_for_prepay_tax` varchar(1) DEFAULT NULL,
  UNIQUE KEY `ap_system_parameters_u1` (`set_of_books_id`,`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'ap'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-29  0:49:55
