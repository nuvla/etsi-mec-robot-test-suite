*** Settings ***

Documentation
...    A test suite for validating UE Test Notification (UETESTNOT) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Library     libraries/Server.py
Default Tags    TC_MEC_SRV_UELOCSUB


*** Test Cases ***
TC_MEC_MEC013_SRV_UETESTNOT_001_OK
    [Documentation]
    ...    Check that the IUT provides a test notification when requested by a MEC Application
    ...
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.3
    ...    ETSI GS MEC 013 3.1.1 Clause 7.5.3.4  
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create an UserLocationEvent subscription and get sub id    UserLocationEventSubscription
    Spawn Notification Server    TestNotification
    Validate Json   TestNotification.schema.json    ${payload_notification}
    [TearDown]  Remove an UserLocationEvent subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UETESTNOT_002_OK
    [Documentation]
    ...    Check that the IUT terminates notifications after time expiration
    ...
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.16.3.4 
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create an UserArea subscription and get sub id   UserAreaSubscription
    Spawn Notification Server     UserAreaNotification
    Validate Json   UserAreaNotification.schema.json    ${payload_notification}
    [TearDown]  Remove an UserArea subscription    ${SUB_ID}

    
*** Keywords ***
Create an UserLocationEvent subscription and get sub id
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    
Create an UserArea subscription and get sub id
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
        
Remove an UserLocationEvent subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Remove an UserArea subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    

Spawn Notification Server
    [Arguments]  ${payload_notification}
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    ${length} =  Get Length  ${output}
    Set Suite Variable    ${payload_notification}    ${output}
    Run Keyword If  ${length} == 0  Skip
    
    