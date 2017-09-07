DROP TABLE IF EXISTS qi_reports.${tableName};

CREATE TABLE qi_reports.${tableName} AS select * from qi_src.${tableName}_RECONCILATION_VIEW;