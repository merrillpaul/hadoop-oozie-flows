create view qi_src.ASSESSMENTS_RECONCILATION_VIEW as
select a.* from
(select * from qi_src.ASSESSMENTS_BASE union all select * from qi_src.ASSESSMENTS_INCREMENTAL) a
join
(select assessment_subtest_id, max(unix_timestamp(last_updated, 'MM-dd-yyyy HH:mm:ss')) last_updated from
 (select * from qi_src.ASSESSMENTS_BASE union all select * from qi_src.ASSESSMENTS_INCREMENTAL) b
 group by assessment_subtest_id ) g
 on a.assessment_subtest_id = g.assessment_subtest_id and unix_timestamp(a.last_updated, 'MM-dd-yyyy HH:mm:ss') = g.last_updated;
