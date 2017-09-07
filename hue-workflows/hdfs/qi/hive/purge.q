drop table if exists qi_src.${tableName}_BASE;
create table qi_src.${tableName}_BASE as select * from qi_reports.${tableName};

drop table if exists qi_src.${tableName}_INCREMENTAL;