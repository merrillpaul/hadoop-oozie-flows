create view qi_src.USER_RECONCILATION_VIEW as
select a.* from
(select * from qi_src.USER_BASE union all select * from qi_src.USER_INCREMENTAL) a
join
(select id, max(unix_timestamp(last_updated, 'MM-dd-yyyy HH:mm:ss')) last_updated from
 (select * from qi_src.USER_BASE union all select * from qi_src.USER_INCREMENTAL) b
 group by id ) g
 on a.id = g.id and unix_timestamp(a.last_updated, 'MM-dd-yyyy HH:mm:ss') = g.last_updated;