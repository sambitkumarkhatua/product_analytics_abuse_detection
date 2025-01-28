with Primary_event as
(SELECT 
SESSION_ID as sessionId,
EVENT_ID as PrimaryeventId,
PRODUCT_VIEW as PRODUCTVIEW,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'onlineSessionId') AS onlineSessionId,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'serviceType') AS serviceType,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'ZWNumber') AS ZWNumber,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'IndustryCode') AS IndustryCode,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'ZPNumber') AS ZPNumber,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'copyCount') AS copyCount,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'userguid') AS userguid,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'sessionSource') AS sessionSource,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'ZBNumber') AS ZBNumber,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'username') AS username,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'ContactNumber') AS ContactNumber
FROM "PROD"."SOURCE"."COBALT_CARSWELL_WESTLAW" 
where EVENT_NAME ='Cobalt.Website.Delivery.SessionStart'
and TO_DATE(LEFT(timestamp, 10), 'yyyy-mm-dd') >=(select dateadd(year, -1, current_date) from dual))
--and ONLINESESSIONID='6279143d4aa84a67b598c32aaf824e58')
,
Seconday_event as 
(SELECT 
EVENT_ID as SecondaryeventId,
--PRODUCT_VIEW as PRODUCTVIEW,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'onlineSessionId') AS onlineSessionId,
--JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'sessionSource') AS sessionSource ,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'title') AS title,
--JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'userguid') AS userguid,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'ReportingName') AS ReportingName,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'ContentType') AS ContentType,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'DocumentGuid') AS DocumentGuid,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'IsRedelivery') AS IsRedelivery,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'TOUsed') AS TOUsed,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'accessMethod') AS accessMethod,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'billingContext') AS billingContext,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'citation') AS citation,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'searchId') AS searchId,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'royaltyId') AS royaltyId,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'deliveryDestination') AS deliveryDestination,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'emailAddressCount') AS emailAddressCount,
JSON_EXTRACT_PATH_TEXT(EVENT_DATA, 'emailAddresses') AS emailAddresses
FROM "PROD"."SOURCE"."COBALT_CARSWELL_WESTLAW" 
where EVENT_NAME ='Cobalt.Website.DocumentDelivery.Complete' 
and TO_DATE(LEFT(timestamp, 10), 'yyyy-mm-dd') >=(select dateadd(year, -1, current_date) from dual))
--and ONLINESESSIONID='6279143d4aa84a67b598c32aaf824e58')

select distinct Primary_event.*,
Seconday_event.SecondaryeventId,
--Seconday_event.sessionSource ,
Seconday_event.title,
--Seconday_event.userguid,
Seconday_event.ReportingName,
Seconday_event.ContentType,
Seconday_event.DocumentGuid,
Seconday_event.IsRedelivery,
Seconday_event.TOUsed,
Seconday_event.accessMethod,
Seconday_event.billingContext,
Seconday_event.citation,
Seconday_event.searchId,
Seconday_event.royaltyId,
Seconday_event.deliveryDestination,
Seconday_event.emailAddressCount,
Seconday_event.emailAddresses
from 
Primary_event
inner join
Seconday_event
on Primary_event.onlineSessionId=Seconday_event.onlineSessionId