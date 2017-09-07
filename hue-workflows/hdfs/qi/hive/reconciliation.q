create view qi_src.${tableName}_RECONCILATION_VIEW as
select a.* from
(select * from qi_src.${tableName}_BASE union all select * from qi_src.${tableName}_INCREMENTAL) a
join
(select id, max(unix_timestamp(last_updated, 'MM-dd-yyyy HH:mm:ss')) last_updated from
 (select * from qi_src.${tableName}_BASE union all select * from qi_src.${tableName}_INCREMENTAL) b
 group by id ) g
 on a.id = g.id and unix_timestamp(a.last_updated, 'MM-dd-yyyy HH:mm:ss') = g.last_updated;