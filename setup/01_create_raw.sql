-- setup/01_create_raw.sql
-- Creates the RAW schema, a stage for files, and the raw inventory table.
-- Run in a Snowsight worksheet, with the same role that dbt uses.

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE TRANSFORMING;
USE DATABASE PARAPHARMACY_DQ;

CREATE SCHEMA IF NOT EXISTS RAW;
USE SCHEMA RAW;

-- How to read the CSV: skip the header line; values may be wrapped in "quotes"
-- (needed if a product name contains a comma)
CREATE OR REPLACE FILE FORMAT CSV_WITH_HEADER
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- A place inside Snowflake to hold the uploaded file
CREATE STAGE IF NOT EXISTS RAW_FILES
  FILE_FORMAT = CSV_WITH_HEADER;

-- The raw table: every column is text, as delivered.
-- Column order must match the CSV header.
CREATE OR REPLACE TABLE INVENTORY_SNAPSHOTS (
  snapshot_dt    VARCHAR,
  branch_hash    VARCHAR,
  lot_id         VARCHAR,
  product_id     VARCHAR,
  product_name   VARCHAR,
  family_cd      VARCHAR,
  storage_zone   VARCHAR,
  date_type      VARCHAR,
  expiry_dt      VARCHAR,
  prc_list       VARCHAR,
  disc_rate      VARCHAR,
  prc_sale       VARCHAR,
  pack_size      VARCHAR,
  pack_unit      VARCHAR,
  ppu_100        VARCHAR,
  qty_recv       VARCHAR,
  qty_listed     VARCHAR,
  qty_sold       VARCHAR,
  qty_remaining  VARCHAR
);