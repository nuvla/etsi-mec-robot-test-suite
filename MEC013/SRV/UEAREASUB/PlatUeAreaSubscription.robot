*** Settings ***

Documentation
...    A test suite for validating UE Area Subscribe (UEAREASUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     libraries/Server.py
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Default Tags    TC_MEC_SRV_UEAREASUB



*** Test Cases ***
TC_MEC_MEC013_SRV_UEAREASUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the creation of UE area subscription request when commanded by a MEC Application
    ...    Reference ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.16.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Create new subscription    UserAreaNotification
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    UserAreaNotification
    Should Be Equal As Strings    ${response['body']['notificationType']}    UserAreaNotification
    Spawn Notification Server     UserAreaNotification
    Validate Json   UserAreaNotification.schema.json    ${payload_notification}


    
TC_MEC_MEC013_SRV_UEAREASUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application - 
    ...    Neither callbackReference nor websockNotifConfig provided
    ...    Reference ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.16.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    UserAreaNotificationError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC013_SRV_UEAREASUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the change of UE area subscription request when commanded by a MEC Application
    ...    Reference ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.17.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id   UserAreaNotification
    Update subscription    ${SUB_ID}     UserAreaNotificationUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserAreaNotification
    Should Be Equal As Strings    ${response['body']['notificationType']}    UserAreaNotification
    [TearDown]   Remove subscription    ${SUB_ID}
    


TC_MEC_MEC013_SRV_UEAREASUB_002_NF
    [Documentation]
    ...    Check that the IUT acknowledges the change of UE area subscription request when commanded by a MEC Application
    ...    Reference ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.17.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]    Remove subscription    ${NON_EXISTING_SUBSCRIPTION_ID}
    Update subscription    ${NON_EXISTING_SUBSCRIPTION_ID}     UserAreaNotificationUpdate
    Check HTTP Response Status Code Is    404


*** Keywords ***
Create new subscription and get sub id
    [Arguments]    ${content}    
    Create new subscription     ${content}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]} 

Create new subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Update subscription
    [Arguments]    ${subscription_id}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area/${subscription_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
        
Remove subscription
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Spawn Notification Server
    [Arguments]  ${payload_notification}
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    Set Suite Variable    ${payload_notification}    ${output}
