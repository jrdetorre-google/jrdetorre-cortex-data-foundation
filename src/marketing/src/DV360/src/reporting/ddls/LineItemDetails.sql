# -- Copyright 2024 Google LLC
# --
# -- Licensed under the Apache License, Version 2.0 (the "License");
# -- you may not use this file except in compliance with the License.
# -- You may obtain a copy of the License at
# --
# --      https://www.apache.org/licenses/LICENSE-2.0
# --
# -- Unless required by applicable law or agreed to in writing, software
# -- distributed under the License is distributed on an "AS IS" BASIS,
# -- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# -- See the License for the specific language governing permissions and
# -- limitations under the License.

/* Line Item dimension details. */

SELECT
  date,
  line_item_id,
  campaign_id,
  line_item,
  campaign,
  line_item_type,
  line_item_start_date,
  line_item_end_date
FROM `{{ project_id_src }}.{{ marketing_dv360_datasets_cdc }}.lineitem_details`