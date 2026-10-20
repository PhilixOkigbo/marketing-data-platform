-- =====================================================================
-- Unity Catalog setup: catalogs per environment + least-privilege grants.
-- Run once in the Databricks SQL editor as the workspace admin.
-- Replace the two placeholders before running:
--   <SP_APPLICATION_ID>  -> Application ID of the service principal (a UUID)
--   <YOUR_EMAIL>         -> your Databricks login email
-- =====================================================================

-- 1. Catalogs: one per layer of the platform / environment
CREATE CATALOG IF NOT EXISTS bronze;          -- raw data, as uploaded
CREATE CATALOG IF NOT EXISTS development;     -- dev target (each developer gets own schema)
CREATE CATALOG IF NOT EXISTS ci_development;  -- ci target (one schema per pull request)
CREATE CATALOG IF NOT EXISTS production;      -- prod target (consumed by analysts, BI, AI)

-- 2. Service principal: READ raw data only
GRANT USE CATALOG ON CATALOG bronze TO `<SP_APPLICATION_ID>`;
GRANT USE SCHEMA  ON CATALOG bronze TO `<SP_APPLICATION_ID>`;
GRANT SELECT      ON CATALOG bronze TO `<SP_APPLICATION_ID>`;

-- 3. Service principal: BUILD in CI and production
GRANT USE CATALOG, USE SCHEMA, CREATE SCHEMA, CREATE TABLE, SELECT, MODIFY
    ON CATALOG ci_development TO `<SP_APPLICATION_ID>`;
GRANT USE CATALOG, USE SCHEMA, CREATE SCHEMA, CREATE TABLE, SELECT, MODIFY
    ON CATALOG production TO `<SP_APPLICATION_ID>`;
-- Note: the service principal has no access to the development catalog.

-- 4. Developer (you): READ what CI and production built, to inspect PR results.
--    You build only in development (you own it, so no grant needed there).
GRANT USE CATALOG, USE SCHEMA, SELECT ON CATALOG ci_development TO `<YOUR_EMAIL>`;
GRANT USE CATALOG, USE SCHEMA, SELECT ON CATALOG production     TO `<YOUR_EMAIL>`;

-- 5. Check
SHOW GRANTS ON CATALOG production;
SHOW GRANTS ON CATALOG ci_development;
SHOW GRANTS ON CATALOG bronze;
