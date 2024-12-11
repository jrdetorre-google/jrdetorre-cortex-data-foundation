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

-- OrderHeaders base fact view.

SELECT
  HEADER_ID,
  ORDER_NUMBER,
  ORDER_SOURCE_ID,
  ORDERED_DATE,
  REQUEST_DATE,
  BOOKED_DATE,
  INVOICE_TO_ORG_ID AS BILL_TO_SITE_USE_ID,
  SOLD_TO_SITE_USE_ID,
  SHIP_TO_ORG_ID AS SHIP_TO_SITE_USE_ID,
  ORG_ID AS BUSINESS_UNIT_ID,
  FLOW_STATUS_CODE,
  ORDER_CATEGORY_CODE,
  TRANSACTIONAL_CURR_CODE,
  OPEN_FLAG,
  BOOKED_FLAG,
  CANCELLED_FLAG,
  SALESREP_ID,
  RETURN_REASON_CODE,
  CREATION_DATE AS CREATION_TS,
  LAST_UPDATE_DATE AS LAST_UPDATE_TS
FROM
  `{{ project_id_src }}.{{ oracle_ebs_datasets_cdc }}.OE_ORDER_HEADERS_ALL`
