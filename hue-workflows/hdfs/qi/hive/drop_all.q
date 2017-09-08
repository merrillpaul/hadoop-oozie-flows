drop view if exists qi_src.${tableName}_RECONCILATION_VIEW;
drop table if exists qi_src.${tableName}_BASE;
drop table if exists qi_src.${tableName}_INCREMENTAL;
drop table if exists qi_reports.${tableName};

