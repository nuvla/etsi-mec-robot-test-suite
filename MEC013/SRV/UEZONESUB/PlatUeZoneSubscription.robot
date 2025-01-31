*** Settings ***

Documentation
...    A test suite for validating UE Zone Lookup (UEZONELOOK) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Library     libraries/Server.py
Default Tags    TC_MEC_SRV_RLOCLOOK


*** Test Cases ***
TC_MEC_MEC013_SRV_UEZONESUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the creation of UE zone subscription request 
    ...    when commanded by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Create new subscription and get sub id   ZoneLocationEventSubscription  
    Check HTTP Response Body Json Schema Is    ZoneLocationEventSubscription
    Check HTTP Response Status Code Is    201
    Spawn Notification Server    ZoneLocationEventNotification
    Validate Json   ZoneLocationEventNotification.schema.json    ${payload_notification}
    [TearDown]  Remove subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UEZONESUB_001_OK_02_01
    [Documentation]
    ...    Check that the IUT acknowledges the creation of UE zone subscription request
    ...    when commanded by a MEC Application - OperationStatus constraint
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.7
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Create new subscription   ZoneStatusSubscriptionOperationStatus
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ZoneLocationEventSubscription
    Spawn Notification Server    ZoneStatusNotificationOperationStatus
    Validate Json   ZoneStatusNotification.schema.json    ${payload_notification}
    [TearDown]  Remove subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UEZONESUB_001_OK_02_02
    [Documentation]
    ...    Check that the IUT acknowledges the creation of UE zone subscription request
    ...    when commanded by a MEC Application - UserNumEvent constraint
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.7
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Create new subscription and get sub id   ZoneStatusSubscriptionUserConstraints
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ZoneLocationEventSubscription
    Spawn Notification Server    ZoneStatusNotificationUserConstraints
    Validate Json   ZoneStatusNotification.schema.json    ${payload_notification}
    [TearDown]  Remove subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UEZONESUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when a request with incorrect parameters is sent by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Create new subscription   ZoneLocationEventSubscriptionError  
    Check HTTP Response Status Code Is    400


TC_MEC_MEC013_SRV_UEZONESUB_002_OK_01
    [Documentation]
    ...    Check that the IUT acknowledges the change of UE area subscription request 
    ...    when commanded by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id   ZoneLocationEventSubscription  
    Update existing subscription   ${SUB_ID}  ZoneLocationEventSubscriptionUpdate
    Check HTTP Response Body Json Schema Is    ZoneLocationEventSubscription
    Check HTTP Response Status Code Is    200
    [TearDown]  Remove subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UEZONESUB_002_OK_02
    [Documentation]
    ...    Check that the IUT acknowledges the change of UE area subscription request 
    ...    when commanded by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.7
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id   ZoneStatusSubscriptionUserConstraints  
    Update existing subscription   ${SUB_ID}   ZoneStatusSubscriptionUpdate
    Check HTTP Response Body Json Schema Is    ZoneStatusSubscription
    Check HTTP Response Status Code Is    200
    [TearDown]  Remove subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UEZONESUB_002_NF
    [Documentation]
    ...   Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI
    ...   is sent by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Update existing subscription   ${NOT_EXISTING_SUB_ID}   ZoneStatusSubscriptionUpdate
    Check HTTP Response Status Code Is    404


TC_MEC_MEC013_SRV_UEZONESUB_003_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE area change notifications
    ...    when commanded by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id   ZoneStatusSubscriptionUserConstraints  
    Remove subscription    ${SUB_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC013_SRV_UEZONESUB_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI
    ...    is sent by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Remove subscription    ${NOT_EXISTING_SUB_ID}
    Check HTTP Response Status Code Is    404
    
*** Keywords ***
Create new subscription and get sub id
    [Arguments]    ${content}
    Create new subscription   ${content}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
        
Create new subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}

    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update existing subscription
    [Arguments]    ${sub_id}  ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones/${sub_id}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Remove subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}    
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Spawn Notification Server
    [Arguments]  ${payload_notification}
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    ${length} =  Get Length  ${output}
    Set Suite Variable    ${payload_notification}    ${output}
    Run Keyword If  ${length} == 0  Skip