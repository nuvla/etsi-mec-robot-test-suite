*** Settings ***

Documentation
...    A test suite for validating Application Service Availability Query (APPSAQ) operations.

Resource    ../../../GenericKeywords.robot
#Resource    environment/variables.txt
Resource    environment/variables_sandbox.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library      libraries/Server.py

Default Tags    TC_MEC_SRV_APPSAQ



*** Test Cases ***
TC_MEC_MEC011_SRV_APPSAQ_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available MEC services
    ...    for a given application instance when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.5,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.6.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create new service    ServiceInfo    ${APP_INSTANCE_ID}
    Set Suite Variable    ${SERVICE_ID}    ${response['body']['serInstanceId']}
    Get a list of mecService of an application instance    ${APP_INSTANCE_ID} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfoList
    [TearDown]  Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
   

TC_MEC_MEC011_SRV_APPSAQ_001_BR
    [Documentation]
    ...   Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI G3.3.1 011 clause 5.2.5,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.6.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    # Wrong query parameter name should trigger an error response.
    Get a list of mecService of an application instance with parameters    ${APP_INSTANCE_ID}    ${INSTANCE_ID}    ${FAKE_INSTANCE_ID_VALUE}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC011_SRV_APPSAQ_002_OK
    [Documentation]
    ...    Check that the IUT notifies the authorised relevant (subscribed) application
    ...    instances when a new service for a given application instance is registered
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.5,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.6.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup] 
    Create new service    ServiceInfo    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check HTTP Response Header Contains    Location
    Check Response Contains    ${response['body']}    serName    ${NEW_SERVICE_NAME}
    Spawn Notification Server     SerAvailabilityNotificationSubscription    
    Validate Json   SerAvailabilityNotificationSubscription.schema.json    ${payload_notification}
    [TearDown]  Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
    

TC_MEC_MEC011_SRV_APPSAQ_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.5,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.6.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new service    ServiceInfoError    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC011_SRV_APPSAQ_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.5,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.6.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Remove individual service    ${NON_EXISTENT_APP_INSTANCE_ID}    ${SERVICE_ID}
    Create new service    ServiceInfo    ${NON_EXISTENT_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_APPSAQ_003_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific service
    ...    for a given application instance when queried by a MEC Application
    ...
    ...    Reference ETSI GS MEC 011 clause 5.2.5,
    ...              ETSI GS MEC 011 clause 8.1.2.2,
    ...              ETSI GS MEC 011 clause 8.2.7.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create new service    ServiceInfo    ${APP_INSTANCE_ID} 
    Set Suite Variable    ${SERVICE_ID}    ${response['body']['serInstanceId']}
    Get individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Response Contains    ${response['body']}    serInstanceId    ${SERVICE_ID}
    [TearDown]  Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
   

TC_MEC_MEC011_SRV_APPSAQ_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference ETSI GS MEC 011 clause 5.2.5,
    ...              ETSI GS MEC 011 clause 8.1.2.2,
    ...              ETSI GS MEC 011 clause 8.2.7.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Remove individual service    ${NON_EXISTENT_APP_INSTANCE_ID}    ${SERVICE_ID}
    Get individual service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_APPSAQ_004_OK
    [Documentation]
    ...    Check that the IUT updates a service information for a given
    ...    application instance when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.4,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.7.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create new service    ServiceInfo    ${APP_INSTANCE_ID} 
    Set Suite Variable    ${SERVICE_ID}    ${response['body']['serInstanceId']}
    Update service    ${APP_INSTANCE_ID}    ${SERVICE_ID}    ServiceInfoUpdated
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Response Contains    ${response['body']}    version    ${SVC_NEW_VERSION}
    [TearDown]  Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}


TC_MEC_MEC011_SRV_APPSAQ_004_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.4,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.7.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create new service    ServiceInfo    ${APP_INSTANCE_ID}
    Set Suite Variable    ${SERVICE_ID}    ${response['body']['serInstanceId']}
    Update service    ${APP_INSTANCE_ID}    ${SERVICE_ID}    ServiceInfoUpdatedError
    Check HTTP Response Status Code Is    400
    [TearDown]  Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}


TC_MEC_MEC011_SRV_APPSAQ_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.4,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.7.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Remove individual service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}
    Update service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}    ServiceInfoUpdated
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_APPSAQ_004_PF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 011 clause 5.2.4,
    ...                 ETSI GS MEC 011 clause 8.1.2.2,
    ...                 ETSI GS MEC 011 clause 8.2.7.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create new service    ServiceInfo    ${APP_INSTANCE_ID} 
    Set Suite Variable    ${SERVICE_ID}    ${response['body']['serInstanceId']}
    Update service with etag    ${APP_INSTANCE_ID}    ${SERVICE_ID}    ServiceInfoUpdated  ${INVALID_ETAG}
    Check HTTP Response Status Code Is    412
    [TearDown]  Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}


TC_MEC_MEC011_SRV_APPSAQ_005_OK
    [Documentation]
    ...    Check that the IUT executes the deletion of a service 
    ...    for a given application instance when requested by a MEC Application
    ...
    ...    Reference ETSI GS MEC 011 clause 8.2.7.3.5
   [Tags]    PIC_MEC_PLAT    PIC_SERVICES
   [Setup]  Create new service    ServiceInfo    ${APP_INSTANCE_ID} 
   Set Suite Variable    ${SERVICE_ID}    ${response['body']['serInstanceId']}
   Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
   Check HTTP Response Status Code Is    204


TC_MEC_MEC011_SRV_APPSAQ_005_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for deletion of a unknown service is sent by a MEC Application
    ...
    ...    Reference ETSI GS MEC 011 clause 8.2.7.3.5
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Remove individual service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}   
    Remove individual service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404



*** Keywords ***
Get a list of mecService of an application instance with parameters
    [Arguments]    ${appInstanceId}    ${key}=None    ${value}=None
    Set Headers    {"Accept":"application/json"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get a list of mecService of an application instance
    [Arguments]    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Create new service
    [Arguments]    ${content}    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services    ${body}
    Log  ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get individual service
    [Arguments]    ${appInstanceId}    ${serviceName} 
    Set Headers    {"Accept":"application/json"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceName}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    
Update service    
    [Arguments]    ${appInstanceId}    ${serviceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    #Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Update service with etag 
    [Arguments]    ${appInstanceId}    ${serviceId}    ${content}   ${etag}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"If-Match":"${etag}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
        

Remove individual service
    [Arguments]    ${appInstanceId}    ${serviceName} 
    Set Headers    {"Accept":"application/json"}
    #Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceName}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
   

Create a new subscription   
    [Arguments]    ${appInstanceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Spawn Notification Server
    [Arguments]  ${payload_notification}
    
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    ${length} =  Get Length  ${output}  
    Set Suite Variable    ${payload_notification}    ${output}
    Run Keyword If  ${length} == 0  Skip