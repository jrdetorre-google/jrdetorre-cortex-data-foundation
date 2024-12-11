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

-- SalesOrdersDailyAgg aggregate reporting table.

WITH
  HeaderAgg AS (
    SELECT
      ORDERED_DATE,
      ANY_VALUE(ORDERED_MONTH_NUM) AS ORDERED_MONTH_NUM,
      ANY_VALUE(ORDERED_QUARTER_NUM) AS ORDERED_QUARTER_NUM,
      ANY_VALUE(ORDERED_YEAR_NUM) AS ORDERED_YEAR_NUM,
      COALESCE(BILL_TO_SITE_USE_ID, -1) AS BILL_TO_SITE_USE_ID,
      ANY_VALUE(BILL_TO_CUSTOMER_NUMBER) AS BILL_TO_CUSTOMER_NUMBER,
      ANY_VALUE(BILL_TO_CUSTOMER_NAME) AS BILL_TO_CUSTOMER_NAME,
      ANY_VALUE(BILL_TO_CUSTOMER_COUNTRY) AS BILL_TO_CUSTOMER_COUNTRY,
      COALESCE(SOLD_TO_SITE_USE_ID, -1) AS SOLD_TO_SITE_USE_ID,
      ANY_VALUE(SOLD_TO_CUSTOMER_NUMBER) AS SOLD_TO_CUSTOMER_NUMBER,
      ANY_VALUE(SOLD_TO_CUSTOMER_NAME) AS SOLD_TO_CUSTOMER_NAME,
      ANY_VALUE(SOLD_TO_CUSTOMER_COUNTRY) AS SOLD_TO_CUSTOMER_COUNTRY,
      COALESCE(SHIP_TO_SITE_USE_ID, -1) AS SHIP_TO_SITE_USE_ID,
      ANY_VALUE(SHIP_TO_CUSTOMER_NUMBER) AS SHIP_TO_CUSTOMER_NUMBER,
      ANY_VALUE(SHIP_TO_CUSTOMER_NAME) AS SHIP_TO_CUSTOMER_NAME,
      ANY_VALUE(SHIP_TO_CUSTOMER_COUNTRY) AS SHIP_TO_CUSTOMER_COUNTRY,
      COALESCE(BUSINESS_UNIT_ID, -1) AS BUSINESS_UNIT_ID,
      ANY_VALUE(BUSINESS_UNIT_NAME) AS BUSINESS_UNIT_NAME,
      COALESCE(ORDER_SOURCE_ID, -1) AS ORDER_SOURCE_ID,
      ANY_VALUE(ORDER_SOURCE_NAME) AS ORDER_SOURCE_NAME,
      ORDER_CATEGORY_CODE,
      COUNT(*) AS NUM_ORDERS,
      COUNTIF(NOT HAS_HOLD) AS NUM_ORDERS_WITH_NO_HOLDS,
      COUNTIF(IS_FULFILLED) AS NUM_FULFILLED_ORDERS,
      -- HAS_BACKORDER can be null, so we have a separate measure for the positive and negative bool
      -- values.
      COUNTIF(HAS_BACKORDER) AS NUM_BACKORDERED_ORDERS,
      COUNTIF(NOT HAS_BACKORDER) AS NUM_FILLABLE_ORDERS,
      COUNTIF(HAS_RETURN_LINE) AS NUM_ORDERS_WITH_RETURNS,
      COUNTIF(IS_CANCELLED) AS NUM_CANCELLED_ORDERS,
      COUNTIF(IS_OPEN) AS NUM_OPEN_ORDERS,
      COUNTIF(HAS_BACKORDER OR IS_HELD) AS NUM_BLOCKED_ORDERS,
      COUNTIF(NUM_LINES > 0 AND NUM_LINES = NUM_LINES_FULFILLED_BY_REQUEST_DATE)
        AS NUM_ORDERS_FULFILLED_BY_REQUEST_DATE,
      COUNTIF(NUM_LINES > 0 AND NUM_LINES = NUM_LINES_FULFILLED_BY_PROMISE_DATE)
        AS NUM_ORDERS_FULFILLED_BY_PROMISE_DATE
    FROM `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.SalesOrders`
    GROUP BY
      ORDERED_DATE, BILL_TO_SITE_USE_ID, SOLD_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID, ORDER_SOURCE_ID, ORDER_CATEGORY_CODE
  ),
  -- Aggregation at the Line and target currency granularity. Amounts do not include
  -- cancelled order lines.
  CurrencyAgg AS (
    SELECT
      H.ORDERED_DATE,
      COALESCE(H.BILL_TO_SITE_USE_ID, -1) AS BILL_TO_SITE_USE_ID,
      COALESCE(H.SOLD_TO_SITE_USE_ID, -1) AS SOLD_TO_SITE_USE_ID,
      COALESCE(H.SHIP_TO_SITE_USE_ID, -1) AS SHIP_TO_SITE_USE_ID,
      COALESCE(H.BUSINESS_UNIT_ID, -1) AS BUSINESS_UNIT_ID,
      COALESCE(H.ORDER_SOURCE_ID, -1) AS ORDER_SOURCE_ID,
      H.ORDER_CATEGORY_CODE,
      H.CURRENCY_CODE,
      L.LINE_CATEGORY_CODE,
      COALESCE(L.ITEM_ORGANIZATION_ID, -1) AS ITEM_ORGANIZATION_ID,
      ANY_VALUE(L.ITEM_ORGANIZATION_NAME) AS ITEM_ORGANIZATION_NAME,
      COALESCE(IC.CATEGORY_SET_ID, -1) AS ITEM_CATEGORY_SET_ID,
      ANY_VALUE(IC.CATEGORY_SET_NAME) AS ITEM_CATEGORY_SET_NAME,
      COALESCE(IC.ID, -1) AS ITEM_CATEGORY_ID,
      ANY_VALUE(IC.CATEGORY_NAME) AS ITEM_CATEGORY_NAME,
      ANY_VALUE(IC.DESCRIPTION) AS ITEM_CATEGORY_DESCRIPTION,
      COUNT(DISTINCT L.LINE_ID) AS NUM_ORDER_LINES,
      COUNT(DISTINCT IF(L.IS_FULFILLED, L.LINE_ID, NULL)) AS NUM_FULFILLED_ORDER_LINES,
      SUM(L.CYCLE_TIME_DAYS) AS TOTAL_CYCLE_TIME_DAYS,
      SUM(L.ORDERED_AMOUNT) AS TOTAL_ORDERED,
      SUM(L.SHIPPED_AMOUNT) AS TOTAL_SHIPPED,
      SUM(L.FULFILLED_AMOUNT) AS TOTAL_FULFILLED,
      SUM(L.INVOICED_AMOUNT) AS TOTAL_INVOICED,
      SUM(L.BOOKING_AMOUNT) AS TOTAL_BOOKING,
      SUM(L.BACKLOG_AMOUNT) AS TOTAL_BACKLOG
    FROM `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.SalesOrders` AS H
    LEFT JOIN UNNEST(LINES) AS L
    LEFT JOIN UNNEST(L.ITEM_CATEGORIES) AS IC
    WHERE NOT L.IS_CANCELLED
    GROUP BY
      ORDERED_DATE, BILL_TO_SITE_USE_ID, SOLD_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID, ORDER_SOURCE_ID, ORDER_CATEGORY_CODE, CURRENCY_CODE,
      LINE_CATEGORY_CODE, ITEM_ORGANIZATION_ID, ITEM_CATEGORY_SET_ID, ITEM_CATEGORY_ID
  ),
  -- Join to CurrencyRateMD to get target conversions.
  ConvertedCurrencyAgg AS (
    SELECT
      CA.ORDERED_DATE,
      CA.BILL_TO_SITE_USE_ID,
      CA.SOLD_TO_SITE_USE_ID,
      CA.SHIP_TO_SITE_USE_ID,
      CA.BUSINESS_UNIT_ID,
      CA.ORDER_SOURCE_ID,
      CA.ORDER_CATEGORY_CODE,
      CA.LINE_CATEGORY_CODE,
      CA.ITEM_ORGANIZATION_ID,
      ANY_VALUE(CA.ITEM_ORGANIZATION_NAME) AS ITEM_ORGANIZATION_NAME,
      CA.ITEM_CATEGORY_SET_ID,
      ANY_VALUE(CA.ITEM_CATEGORY_SET_NAME) AS ITEM_CATEGORY_SET_NAME,
      CA.ITEM_CATEGORY_ID,
      ANY_VALUE(CA.ITEM_CATEGORY_NAME) AS ITEM_CATEGORY_NAME,
      ANY_VALUE(CA.ITEM_CATEGORY_DESCRIPTION) AS ITEM_CATEGORY_DESCRIPTION,
      SUM(CA.NUM_ORDER_LINES) AS NUM_ORDER_LINES,
      SUM(CA.NUM_FULFILLED_ORDER_LINES) AS NUM_FULFILLED_ORDER_LINES,
      SUM(CA.TOTAL_CYCLE_TIME_DAYS) AS TOTAL_CYCLE_TIME_DAYS,
      T AS TARGET_CURRENCY_CODE,
      -- noqa: disable=LT02
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CA.CURRENCY_CODE, T, CR.CONVERSION_RATE, CA.TOTAL_ORDERED))
        AS TOTAL_ORDERED,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CA.CURRENCY_CODE, T, CR.CONVERSION_RATE, CA.TOTAL_SHIPPED))
        AS TOTAL_SHIPPED,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CA.CURRENCY_CODE, T, CR.CONVERSION_RATE, CA.TOTAL_FULFILLED))
        AS TOTAL_FULFILLED,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CA.CURRENCY_CODE, T, CR.CONVERSION_RATE, CA.TOTAL_INVOICED))
        AS TOTAL_INVOICED,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CA.CURRENCY_CODE, T, CR.CONVERSION_RATE, CA.TOTAL_BOOKING))
        AS TOTAL_BOOKING,
      SUM(
        `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.GetConvertedAmount`(
          CA.CURRENCY_CODE, T, CR.CONVERSION_RATE, CA.TOTAL_BACKLOG))
        AS TOTAL_BACKLOG,
      -- noqa: enable=LT02
      LOGICAL_OR(CA.CURRENCY_CODE != T AND CR.CONVERSION_RATE IS NULL) AS IS_INCOMPLETE_CONVERSION
    FROM CurrencyAgg AS CA
    -- LEFT JOIN is needed to create rows for each target currency, even when it's not available
    -- in the conversion dim or the source and target currency are the same. LEFT instead of CROSS
    -- ensures there will be a record even if there are no targets.
    LEFT JOIN UNNEST({{ oracle_ebs_currency_conversion_targets }}) AS T
    LEFT JOIN `{{ project_id_tgt }}.{{ oracle_ebs_datasets_reporting }}.CurrencyRateMD` AS CR
      ON
        CA.ORDERED_DATE = CR.CONVERSION_DATE
        AND CA.CURRENCY_CODE = CR.FROM_CURRENCY
        AND T = CR.TO_CURRENCY
    -- noqa: disable=RF02
    GROUP BY
      ORDERED_DATE, BILL_TO_SITE_USE_ID, SOLD_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID, ORDER_SOURCE_ID, ORDER_CATEGORY_CODE, LINE_CATEGORY_CODE,
      ITEM_ORGANIZATION_ID, ITEM_CATEGORY_SET_ID, ITEM_CATEGORY_ID,
      TARGET_CURRENCY_CODE
  -- noqa: enable=RF02
  ),
  -- Aggregation at the Line granularity. Target currency is aggregated into an array.
  CurrencyArray AS (
    SELECT
      ORDERED_DATE,
      BILL_TO_SITE_USE_ID,
      SOLD_TO_SITE_USE_ID,
      SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID,
      ORDER_SOURCE_ID,
      ORDER_CATEGORY_CODE,
      LINE_CATEGORY_CODE,
      ITEM_ORGANIZATION_ID,
      ANY_VALUE(ITEM_ORGANIZATION_NAME) AS ITEM_ORGANIZATION_NAME,
      ITEM_CATEGORY_SET_ID,
      ANY_VALUE(ITEM_CATEGORY_SET_NAME) AS ITEM_CATEGORY_SET_NAME,
      ITEM_CATEGORY_ID,
      ANY_VALUE(ITEM_CATEGORY_NAME) AS ITEM_CATEGORY_NAME,
      ANY_VALUE(ITEM_CATEGORY_DESCRIPTION) AS ITEM_CATEGORY_DESCRIPTION,
      -- These measures use ANY_VALUE because this block is only aggregating the currency amounts
      -- into an array, so non-amount measures should not be re-aggregated to avoid over counting.
      ANY_VALUE(NUM_ORDER_LINES) AS NUM_ORDER_LINES,
      ANY_VALUE(NUM_FULFILLED_ORDER_LINES) AS NUM_FULFILLED_ORDER_LINES,
      ANY_VALUE(TOTAL_CYCLE_TIME_DAYS) AS TOTAL_CYCLE_TIME_DAYS,
      ARRAY_AGG(
        STRUCT(
          TARGET_CURRENCY_CODE, TOTAL_ORDERED, TOTAL_SHIPPED, TOTAL_FULFILLED, TOTAL_INVOICED,
          TOTAL_BOOKING, TOTAL_BACKLOG, IS_INCOMPLETE_CONVERSION
        )
      ) AS AMOUNTS
    FROM ConvertedCurrencyAgg
    GROUP BY
      ORDERED_DATE, BILL_TO_SITE_USE_ID, SOLD_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID, ORDER_SOURCE_ID, ORDER_CATEGORY_CODE, LINE_CATEGORY_CODE,
      ITEM_ORGANIZATION_ID, ITEM_CATEGORY_SET_ID, ITEM_CATEGORY_ID
  ),
  -- Combine the line level fields into an array that can be joined back to header level keys.
  LineArray AS (
    SELECT
      ORDERED_DATE,
      BILL_TO_SITE_USE_ID,
      SOLD_TO_SITE_USE_ID,
      SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID,
      ORDER_SOURCE_ID,
      ORDER_CATEGORY_CODE,
      ARRAY_AGG(
        STRUCT(
          LINE_CATEGORY_CODE,
          ITEM_ORGANIZATION_ID,
          ITEM_ORGANIZATION_NAME,
          ITEM_CATEGORY_SET_ID,
          ITEM_CATEGORY_SET_NAME,
          ITEM_CATEGORY_ID,
          ITEM_CATEGORY_NAME,
          ITEM_CATEGORY_DESCRIPTION,
          NUM_ORDER_LINES,
          NUM_FULFILLED_ORDER_LINES,
          TOTAL_CYCLE_TIME_DAYS,
          AMOUNTS
        )
      ) AS LINES
    FROM CurrencyArray
    GROUP BY
      ORDERED_DATE, BILL_TO_SITE_USE_ID, SOLD_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID,
      BUSINESS_UNIT_ID, ORDER_SOURCE_ID, ORDER_CATEGORY_CODE
  )
-- Aggregate lines measures together into an array at header level.
SELECT
  H.*,
  L.LINES
FROM HeaderAgg AS H
LEFT JOIN LineArray AS L
  USING (
    ORDERED_DATE, BILL_TO_SITE_USE_ID, SOLD_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID,
    BUSINESS_UNIT_ID, ORDER_SOURCE_ID, ORDER_CATEGORY_CODE
  )
