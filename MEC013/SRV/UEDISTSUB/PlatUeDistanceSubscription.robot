*** Settings ***

Documentation
...    A test suite for validating UE Distance Subscribe (UEDISTSUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem   
Library     libraries/Server.py
Library     String
Default Tags    TC_MEC_SRV_UEDISTSUB


*** Test Cases ***

TC_MEC_MEC013_SRV_UEDISTSUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the UE distance subscription request when commanded by a
    ...   MEC Application and notifies it when (all) the requested UE(s) is (are) within the specified distance
    ...
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.9
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.9
    ...    ETSI GS MEC 013 3.1.1 Clause 7.14.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    UserDistanceSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    UserDistanceSubscription
    ${CLIENT_CORRELATOR}   Get value entry from JSON file    UserDistanceSubscription    clientCorrelator
    ${CALLBACK_REF}   Get value entry from JSON file         UserDistanceSubscription    callbackReference
    ${MON_ADDRESSED}   Get value entry from JSON file        UserDistanceSubscription    monitoredAddress
    ${DISTANCE}   Get value entry from JSON file             UserDistanceSubscription    distance
    ${TRACK_ACCURACY}   Get value entry from JSON file       UserDistanceSubscription    trackingAccuracy
    ${CRITERIA}   Get value entry from JSON file             UserDistanceSubscription    criteria
    ${CHECK_IMMEDIATE}   Get value entry from JSON file      UserDistanceSubscription    checkImmediate
    
    Should be Equal    ${response['body']['userDistanceSubscription']['clientCorrelator']}    ${CLIENT_CORRELATOR}
    Should be Equal    ${response['body']['userDistanceSubscription']['callbackReference']}    ${CALLBACK_REF}
    Should be Equal    ${response['body']['userDistanceSubscription']['distance']}    ${DISTANCE}
    Should be Equal    ${response['body']['userDistanceSubscription']['trackingAccuracy']}    ${TRACK_ACCURACY}
    Should be Equal    ${response['body']['userDistanceSubscription']['criteria']}    ${CRITERIA}
    Should be Equal    ${response['body']['userDistanceSubscription']['checkImmediate']}    ${True}
    Spawn Notification Server     UserDistanceNotification
    Validate Json   UserDistanceNotification.schema.json    ${payload_notification}
    [TearDown]  Remove subscription  ${SUB_ID}

TC_MEC_MEC013_SRV_UEDISTSUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when a request with incorrect parameters is 
    ...    sent by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.9
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.9
    ...    ETSI GS MEC 013 3.1.1 Clause 7.14.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new subscription    UserDistanceSubscriptionError
    Check HTTP Response Status Code Is    400


TC_MEC_MEC013_SRV_UEDISTSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE distance 
    ...    notifications when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.15.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create new subscription and get sub id    UserDistanceSubscription
    Remove subscription   ${SUB_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC013_SRV_UEDISTSUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI
    ...    is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.15.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Remove subscription    ${NON_EXISTING_SUBSCRIPTION_ID}
    Remove subscription   ${NON_EXISTING_SUBSCRIPTION_ID}
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
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Remove subscription
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Spawn Notification Server
    [Arguments]  ${payload_notification}
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    Set Suite Variable    ${payload_notification}    ${output}