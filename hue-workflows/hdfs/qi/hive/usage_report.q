DROP TABLE IF EXISTS qi_reports.USAGE_REPORT;

CREATE TABLE qi_reports.USAGE_REPORT AS select
asmt.id id,
asmt.assessment_id,
asmt.subtest_id,
s.name subtest,
asmt.test_id,
t.name test,
asmt.started_date,
asmt.date_created,
be.name business_entity,
bu.name business_unit,
asmt.license_name,
asmt.license_type_name license_type,
asmt.license_prepay_usage,
asmt.license_current_usage,
asmt.license_start_billing_date,
asmt.license_expiration_date,
asmt.usage,
asmt.charge_amount,
asmt.unit_weight,
asmt.qty,
asmt.isbn,
asmt.is_clone,
asmt.paper_flag is_paper,
asmt.title,
concat(clin.first_name ,' ' ,clin.last_name) practitioner_name,
clin.email practitioner_email,
asmt.assessment_type,
asmt.client_identifier,
asmt.applied_payment_method,
be.SHIPMENT_ACCOUNT_ID AS SHIPMENT_ACCOUNT_ID,
be.SHIPMENT_LOCATOR_ID AS SHIPMENT_LOCATOR_ID,
be.BILLING_ACCOUNT_ID AS BILLING_ACCOUNT_ID,
be.BILLING_LOCATOR_ID AS BILLING_LOCATOR_ID


from
qi_reports.assessments asmt
inner join qi_reports.subtest s on s.id = asmt.subtest_id
inner join qi_reports.test t on t.id = s.test_id
inner join qi_reports.pearson_user clin on clin.id = asmt.creator_id
inner join qi_reports.business_entity be on be.id = clin.entity_id
inner join qi_reports.business_unit bu on bu.id = be.business_unit_id;