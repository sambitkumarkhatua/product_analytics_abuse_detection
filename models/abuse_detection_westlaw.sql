with abuse_detection_westlaw AS(
select 
APIGEE_LOG_REQUEST_ID,
APIGEE_LOG_API_PRODUCT,
APIGEE_LOG_APP_NAME,
APIGEE_LOG_COMPANY_NAME,
APIGEE_LOG_PROXY_NAME, 
APIGEE_LOG_REQUEST_PATH,
case 
when APIGEE_LOG_REQUEST_PATH like '%/v3/document/%'
then SUBSTRING(APIGEE_LOG_REQUEST_PATH,14, 10)
else APIGEE_LOG_REQUEST_PATH 
end as Document_number,
APIGEE_LOG_LOG_DATE_TIME,
APIGEE_LOG_SOURCE_IP,
APIGEE_LOG_RESPONSE_CODE,
APIGEE_LOG_TARGET_LATENCY,
'Practical Law' as Product_Name
--CDO_LOAD_TIMESTAMP,
--EDL_LOAD_TIMESTAMP
from PROD.SOURCE.ADN_APIGEE_LOG_DATA_A202210_APIGEE_LOGGING_DATA_VW 
where APIGEE_LOG_API_PRODUCT in ('PracticalLawLegacyRedirectTREXTERNAL',
                                 'PracticalLawEnterpriseSearchTREXTERNAL', 
                                 'PracticalLawFederatedSearchTREXTERNAL',
                                'PracticalLawTREXTERNAL',
                                'PracticalLaw API UAT') 
--and to_date(APIGEE_LOG_LOG_DATE_TIME) >= '2024-01-01' limit 100
and to_date(CDO_LOAD_TIMESTAMP) >='2024-01-01')
select * from abuse_detection_westlaw