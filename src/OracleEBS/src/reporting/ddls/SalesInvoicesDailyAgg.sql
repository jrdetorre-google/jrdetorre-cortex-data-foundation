-- Copyright 2024 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      https://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- SalesInvoicesDailyAgg aggregate reporting table.

WITH
  CurrAgg AS (
    SELECT
      SalesInvoices.INVOICE_DATE,
      ANY_VALUE(SalesInvoices.INVOICE_MONTH_NUM) AS INVOICE_MONTH_NUM,
      ANY_VALUE(SalesInvoices.INVOICE_QUARTER_NUM) AS INVOICE_QUARTER_NUM,
      ANY_VALUE(SalesInvoices.INVOICE_YEAR_NUM) AS INVOICE_YEAR_NUM,
      COALESCE(SalesInvoices.BILL_TO_SITE_USE_ID, -1) AS BILL_TO_SITE_USE_ID,
      ANY_VALUE(SalesInvoices.BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
      ANY_VALUE(SalesInvoices.BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
      ANY_VALUE(SalesInvoices.BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
      COALESCE(SalesInvoices.BUSINESS_UNIT_ID, -1) AS BUSINESS_UNIT_ID,
      ANY_VALUE(SalesInvoices.BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
      COALESCE(SalesInvoices.INVOICE_TYPE_ID, -1) AS INVOICE_TYPE_ID,
      ANY_VALUE(SalesInvoices.INVOICE_TYPE) AS INVOICE_TYPE,
      ANY_VALUE(SalesInvoices.INVOICE_TYPE_NAME) AS INVOICE_TYPE_NAME,
      SalesInvoices.EXCHANGE_DATE,
      SalesInvoices.CURRENCY_CODE,
      COALESCE(Lines.ORDER_SOURCE_ID, -1) AS ORDER_SOURCE_ID,
      ANY_VALUE(Lines.ORDER_SOURCE_NAME) AS ORDER_SOURCE_NAME,
      COALESCE(Lines.ITEM_ORGANIZATION_ID, -1) AS ITEM_ORGANIZATION_ID,
      ANY_VALUE(Lines.ITEM_ORGANIZATION_NAME) AS ITEM_ORGANIZATION_NAME,
      COALESCE(ItemCategories.CATEGORY_SET_ID, -1) AS ITEM_CATEGORY_SET_ID,
      ANY_VALUE(ItemCategories.CATEGORY_SET_NAME) AS ITEM_CATEGORY_SET_NAME,
      COALESCE(ItemCategories.ID, -1) AS ITEM_CATEGORY_ID,
      ANY_VALUE(ItemCategories.CATEGORY_NAME) AS ITEM_CATEGORY_NAME,
      ANY_VALUE(ItemCategories.DESCRIPTION) AS ITEM_CATEGORY_DESCRIPTION,
      COUNT(Lines.LINE_ID) AS NUM_INVOICE_LINES,
      COUNTIF(Lines.IS_INTERCOMPANY) AS NUM_INTERCOMPANY_LINES,
      SUM(Lines.INVOICED_QUANTITY * Lines.UNIT_LIST_PRICE) AS TOTAL_LIST,
      SUM(Lines.INVOICED_QUANTITY * Lines.UNIT_SELLING_PRICE) AS TOTAL_SELLING,
      SUM(Lines.INVOICED_QUANTITY * IF(Lines.IS_INTERCOMPANY, Lines.UNIT_LIST_PRICE, 0))
        AS TOTAL_INTERCOMPANY_LIST,
      SUM(Lines.INVOICED_QUANTITY * IF(Lines.IS_INTERCOMPANY, Lines.UNIT_SELLING_PRICE, 0))
        AS TOTAL_INTERCOMPANY_SELLING,
      SUM(Lines.INVOICED_QUANTITY * Lines.UNIT_DISCOUNT_PRICE) AS TOTAL_DISCOUNT,
      SUM(Lines.TRANSACTION_AMOUNT) AS TOTAL_TRANSACTION,
      SUM(Lines.REVENUE_AMOUNT) AS TOTAL_REVENUE,
      SUM(Lines.TAX_AMOUNT) AS TOTAL_TAX
    FROM
      `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.SalesInvoices` AS SalesInvoices
    LEFT JOIN
      UNNEST(LINES) AS Lines
    LEFT JOIN
      UNNEST(Lines.ITEM_CATEGORIES) AS ItemCategories
    GROUP BY
      INVOICE_DATE, BILL_TO_SITE_USE_ID, BUSINESS_UNIT_ID, INVOICE_TYPE_ID,
      EXCHANGE_DATE, CURRENCY_CODE,
      ITEM_ORGANIZATION_ID, ORDER_SOURCE_ID, CATEGORY_SET_ID, ITEM_CATEGORY_ID
  ),
  ConvertedCurrAgg AS (
    SELECT
      CurrAgg.INVOICE_DATE,
      ANY_VALUE(CurrAgg.INVOICE_MONTH_NUM) AS INVOICE_MONTH_NUM,
      ANY_VALUE(CurrAgg.INVOICE_QUARTER_NUM) AS INVOICE_QUARTER_NUM,
      ANY_VALUE(CurrAgg.INVOICE_YEAR_NUM) AS INVOICE_YEAR_NUM,
      CurrAgg.BILL_TO_SITE_USE_ID,
      ANY_VALUE(CurrAgg.BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
      ANY_VALUE(CurrAgg.BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
      ANY_VALUE(CurrAgg.BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
      CurrAgg.BUSINESS_UNIT_ID,
      ANY_VALUE(CurrAgg.BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
      CurrAgg.INVOICE_TYPE_ID,
      ANY_VALUE(CurrAgg.INVOICE_TYPE) AS INVOICE_TYPE,
      ANY_VALUE(CurrAgg.INVOICE_TYPE_NAME) AS INVOICE_TYPE_NAME,
      CurrAgg.ORDER_SOURCE_ID,
      ANY_VALUE(CurrAgg.ORDER_SOURCE_NAME) AS ORDER_SOURCE_NAME,
      CurrAgg.ITEM_ORGANIZATION_ID,
      ANY_VALUE(CurrAgg.ITEM_ORGANIZATION_NAME) AS ITEM_ORGANIZATION_NAME,
      CurrAgg.ITEM_CATEGORY_SET_ID,
      ANY_VALUE(CurrAgg.ITEM_CATEGORY_SET_NAME) AS ITEM_CATEGORY_SET_NAME,
      CurrAgg.ITEM_CATEGORY_ID,
      ANY_VALUE(CurrAgg.ITEM_CATEGORY_NAME) AS ITEM_CATEGORY_NAME,
      ANY_VALUE(CurrAgg.ITEM_CATEGORY_DESCRIPTION) AS ITEM_CATEGORY_DESCRIPTION,
      SUM(CurrAgg.NUM_INVOICE_LINES) AS NUM_INVOICE_LINES,
      SUM(CurrAgg.NUM_INTERCOMPANY_LINES) AS NUM_INTERCOMPANY_LINES,
      TargetCurrs AS TARGET_CURRENCY_CODE,
      -- noqa: disable=LT02
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs, CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_LIST))
        AS TOTAL_LIST,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs, CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_SELLING))
        AS TOTAL_SELLING,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs,
          CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_INTERCOMPANY_LIST))
        AS TOTAL_IC_LIST,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs,
          CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_INTERCOMPANY_SELLING))
        AS TOTAL_IC_SELLING,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs, CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_DISCOUNT))
        AS TOTAL_DISCOUNT,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs, CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_TRANSACTION))
        AS TOTAL_TRANSACTION,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs, CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_REVENUE))
        AS TOTAL_REVENUE,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CurrAgg.CURRENCY_CODE, TargetCurrs, CurrRates.CONVERSION_RATE, CurrAgg.TOTAL_TAX))
        AS TOTAL_TAX,
      LOGICAL_OR(CurrAgg.CURRENCY_CODE != TargetCurrs AND CurrRates.CONVERSION_RATE IS NULL)
        AS IS_INCOMPLETE_CONVERSION
    -- noqa: enable=LT02
    FROM
      CurrAgg
    LEFT JOIN
      UNNEST({{ oracle_ebs_currency_conversion_targets }}) AS TargetCurrs
    LEFT JOIN
      `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.CurrencyRateMD` AS CurrRates
      ON
        COALESCE(CurrAgg.EXCHANGE_DATE, CurrAgg.INVOICE_DATE) = CurrRates.CONVERSION_DATE
        AND CurrAgg.CURRENCY_CODE = CurrRates.FROM_CURRENCY
        AND TargetCurrs = CurrRates.TO_CURRENCY
    GROUP BY
      -- noqa: disable=RF02
      INVOICE_DATE, BILL_TO_SITE_USE_ID, BUSINESS_UNIT_ID, INVOICE_TYPE_ID,
      ORDER_SOURCE_ID, ITEM_ORGANIZATION_ID, ITEM_CATEGORY_SET_ID, ITEM_CATEGORY_ID,
      TARGET_CURRENCY_CODE
      -- noqa: enable=RF02
  )
SELECT
  INVOICE_DATE,
  ANY_VALUE(INVOICE_MONTH_NUM) AS INVOICE_MONTH_NUM,
  ANY_VALUE(INVOICE_QUARTER_NUM) AS INVOICE_QUARTER_NUM,
  ANY_VALUE(INVOICE_YEAR_NUM) AS INVOICE_YEAR_NUM,
  BILL_TO_SITE_USE_ID,
  ANY_VALUE(BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
  ANY_VALUE(BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
  ANY_VALUE(BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
  BUSINESS_UNIT_ID,
  ANY_VALUE(BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
  INVOICE_TYPE_ID,
  ANY_VALUE(INVOICE_TYPE) AS INVOICE_TYPE,
  ANY_VALUE(INVOICE_TYPE_NAME) AS INVOICE_TYPE_NAME,
  ORDER_SOURCE_ID,
  ANY_VALUE(ORDER_SOURCE_NAME) AS ORDER_SOURCE_NAME,
  ITEM_ORGANIZATION_ID,
  ANY_VALUE(ITEM_ORGANIZATION_NAME) AS ITEM_ORGANIZATION_NAME,
  ITEM_CATEGORY_SET_ID,
  ANY_VALUE(ITEM_CATEGORY_SET_NAME) AS ITEM_CATEGORY_SET_NAME,
  ITEM_CATEGORY_ID,
  ANY_VALUE(ITEM_CATEGORY_NAME) AS ITEM_CATEGORY_NAME,
  ANY_VALUE(ITEM_CATEGORY_DESCRIPTION) AS ITEM_CATEGORY_DESCRIPTION,
  ANY_VALUE(NUM_INVOICE_LINES) AS NUM_INVOICE_LINES,
  ANY_VALUE(NUM_INTERCOMPANY_LINES) AS NUM_INTERCOMPANY_LINES,
  ARRAY_AGG(
    STRUCT(
      TARGET_CURRENCY_CODE,
      TOTAL_LIST,
      TOTAL_SELLING,
      TOTAL_IC_LIST AS TOTAL_INTERCOMPANY_LIST,
      TOTAL_IC_SELLING AS TOTAL_INTERCOMPANY_SELLING,
      TOTAL_DISCOUNT,
      TOTAL_TRANSACTION,
      TOTAL_REVENUE,
      TOTAL_TAX,
      IS_INCOMPLETE_CONVERSION
    )
  ) AS AMOUNTS
FROM
  ConvertedCurrAgg
GROUP BY
  INVOICE_DATE, BILL_TO_SITE_USE_ID, BUSINESS_UNIT_ID, INVOICE_TYPE_ID,
  ORDER_SOURCE_ID, ITEM_ORGANIZATION_ID, ITEM_CATEGORY_SET_ID, ITEM_CATEGORY_ID
