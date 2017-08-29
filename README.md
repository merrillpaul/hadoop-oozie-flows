# hadoop-oozie-flows

# Four step process for incremental
(Ingest, Reconcile, Compact and Purge)


## Step1 (Ingest ). Initial Load of Business Unit table into a "BASE" table

*
```terminal
sqoop --options-file ~/apps/sq-qi-qa.txt --delete-target-dir   --table BUSINESS_UNIT --as-textfile -split-by COUNTRY_CODE --map-column-hive 'VERSION=string,DOES_SUPPORT_PATIENT_DETAIL=string' --hive-import --hive-database default --hive-table BUSINESS_UNIT_BASE
```

## Step 2. Copy DDL to Create a 'INCREMENTAL' table
```sql
create table <schema>.BUSINESS_UNIT_INCREMENTAL as select * from BUSINESS_UNIT_BASE where 1 = 0;
```

## Step 3 (Reconcile )- Create 'Reconcilation' view for base and incremental
```sql
hive> use qi;
create view business_unit_reconcilation_view as
select a.* from  
(select * from business_unit_base union all select * from business_unit_incremental) a
join
(select id, max(last_updated) last_updated from
 (select * from business_unit_base union all select * from business_unit_incremental) b
 group by id ) g
 on a.id = g.id and a.last_updated = g.last_updated;


 create view assessment_usage_reconciliation_vw as
 select a.* from  
 (select * from assessment_usage_base union all select * from assessment_usage_incremental) a
 join
 (select assessment_subtest_id, max(unix_timestamp(sync_date)) sync_date from
  (select * from assessment_usage_base union all select * from assessment_usage_incremental) b
  group by assessment_subtest_id ) g
  on a.assessment_subtest_id = g.assessment_subtest_id and unix_timestamp(a.sync_date) = g.sync_date;

```
The above view would contain the latest/synced data

## Step4 (Compact )- Create the actual table reflecting the view
```sql
hive> DROP TABLE IF EXISTS BUSINESS_UNIT_REPORTING;
hive> CREATE TABLE BUSINESS_UNIT_REPORTING AS select * from business_unit_reconcilation_view;
```


## Step 5 (Purge and Refresh) - Preparation for incremental change

This step needs to be done everytime we need to pull in the changes

### Step 5.1 Purge phase
* Purge base table
`hive> DROP TABLE IF EXISTS BUSINESS_UNIT_BASE;`
* Copy Reporting table content into base table
`hive> CREATE TABLE  BUSINESS_UNIT_BASE as select * from BUSINESS_UNIT_REPORTING`

### Step 5.2 Refresh Incremental using sqoop

* Drop Incremental table
```sql
hive> DROP TABLE IF EXISTS BUSINESS_UNIT_INCREMENTAL

```
* Create incremental table with sqoop
```terminal
$ sqoop --options-file ~/apps/sq-qi-qa.txt  --table BUSINESS_UNIT --as-textfile -split-by COUNTRY_CODE --map-column-hive 'VERSION=string,DOES_SUPPORT_PATIENT_DETAIL=string'
	--hive-import --hive-database default --hive-table BUSINESS_UNIT_INCREMENTAL
	--check-column LAST_UPDATED --incremental lastmodified --last-value "2017-08-03 01:00:00.000"/or the last sqoop time
```

- Note: to test this, you need to change the last_update in Oracle so that it falls between the last time sqoop ran and the current timestamp
- TODO: Important to keep the last sqoop run in a file or DB

* Validate changes in the incremental as well as in the view
```sql
select * from BUSINESS_UNIT_INCREMENTAL where <your conditions to verify>;
select * from  business_unit_reconcilation_view where <the same above conditions>;
```

### Step 5.3 Update the reporting table from the view
* Perform Step4


# Tables

* BUSINESS_UNIT_REPORTING -  this is end user table or the table that needs to be sued for other tools
* BUSINESS_UNIT_BASE - the original source and the one that's kept synced before subsequent incrementals
* BUSINESS_UNIT_INCREMENTAL - contains incremental change rows
* BUSINESS_UNIT_RECONCILATION_VIEW - contains reconciled rows

