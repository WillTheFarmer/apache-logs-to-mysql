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
-- Dumping data for table `ap_system_parameters_all`
--

LOCK TABLES `ap_system_parameters_all` WRITE;
/*!40000 ALTER TABLE `ap_system_parameters_all` DISABLE KEYS */;
/*!40000 ALTER TABLE `ap_system_parameters_all` ENABLE KEYS */;
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
