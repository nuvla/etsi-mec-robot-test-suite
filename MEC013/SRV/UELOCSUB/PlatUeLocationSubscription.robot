*** Settings ***

Documentation
...    A test suite for validating UE Location Subscription (UELOCSUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Library     libraries/Server.py
Default Tags    TC_MEC_SRV_UELOCSUB


*** Test Cases ***
TC_MEC_MEC013_SRV_UELOCSUB_001_OK_01
    [Documentation]
    ...    Check that the IUT acknowledges the subscription by a MEC Application to notifications user location event
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.5.3.4
    ...    
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a subscription    UserLocationEventSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    UserLocationEventSubscription
    Get value entry from JSON file  UserLocationEventSubscription   subscriptionType
    ${CLIENT_CORR}       Get value entry from JSON file  UserLocationEventSubscription   clientCorrelator
    ${CALLBACK_REF}      Get value entry from JSON file  UserLocationEventSubscription   callbackReference
    ${ADDRESS}           Get value entry from JSON file  UserLocationEventSubscription   address
    Should be Equal   ${response['body']['subscriptionType']}    UserLocationEventSubscription
    Should be Equal   ${response['body']['clientCorrelator']}    ${CLIENT_CORR} 
    Should be Equal   ${response['body']['callbackReference']}   ${CALLBACK_REF}  
    Should be Equal   ${response['body']['address']}             ${ADDRESS} 
    Spawn Notification Server     UserLocationEventNotification
    Validate Json   UserLocationEventNotification.schema.json    ${payload_notification}
    [TearDown]  Remove a subscription    ${SUB_ID}



TC_MEC_MEC013_SRV_UELOCSUB_001_OK_02
    [Documentation]
    ...    Check that the IUT acknowledges the subscription by a MEC Application to notifications user location periodic
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.5
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.5
    ...    ETSI GS MEC 013 3.1.1 Clause 7.5.3.4
    ...    
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a subscription    UserLocationPeriodicSubscription
    Check HTTP Response Status Code Is    201
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    Check HTTP Response Body Json Schema Is    UserLocationPeriodicSubscription
    Get value entry from JSON file  UserLocationPeriodicSubscription   subscriptionType
    ${CLIENT_CORR}       Get value entry from JSON file  UserLocationPeriodicSubscription   clientCorrelator
    ${CALLBACK_REF}      Get value entry from JSON file  UserLocationPeriodicSubscription   callbackReference
    ${ADDRESS}           Get value entry from JSON file  UserLocationPeriodicSubscription   address
    ${PER_EVENT_INFO}    Get value entry from JSON file  UserLocationPeriodicSubscription   periodicEventInfo
    Should be Equal   ${response['body']['subscriptionType']}    UserLocationPeriodicSubscription
    Should be Equal   ${response['body']['clientCorrelator']}        ${CLIENT_CORR} 
    Should be Equal   ${response['body']['callbackReference']}       ${CALLBACK_REF}  
    Should be Equal   ${response['body']['address']}                 ${ADDRESS} 
    Should be Equal   ${response['body']['periodicEventInfo']}       ${PER_EVENT_INFO} 
    Spawn Notification Server     UserLocationPeriodicNotification
    Validate Json   UserLocationPeriodicNotification.schema.json    ${payload_notification}
    [TearDown]  Remove a subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UELOCSUB_001_BR_01
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when a request with incorrect parameters is sent by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.5.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a subscription    UserLocationEventSubscriptionBR
    Check HTTP Response Status Code Is    400

TC_MEC_MEC013_SRV_UELOCSUB_001_BR_02
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when a request with incorrect parameters is sent by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.5
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.5
    ...    ETSI GS MEC 013 3.1.1 Clause 7.5.3.4
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a subscription    UserLocationPeriodicSubscriptionBR
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC013_SRV_UELOCSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE information change notifications 
    ...    when commanded by a MEC Application
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.5
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a subscription    UserLocationEventSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    Remove a subscription  ${SUB_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC013_SRV_UELOCSUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.5
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Remove a subscription  ${NON_EXISTENT_SUBSCRIPTION_ID}
    Remove a subscription  ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC013_SRV_UELOCSUB_003_OK_01
    [Documentation]
    ...    Check that the IUT acknowledges a request 
    ...    to modify an existing subscription by a MEC Application
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a subscription    UserLocationEventSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    Update a subscription    ${SUB_ID}  UserLocationEventSubscriptionUpdate
    ${CLIENT_CORR}       Get value entry from JSON file  UserLocationEventSubscriptionUpdate   clientCorrelator
    ${CALLBACK_REF}      Get value entry from JSON file  UserLocationEventSubscriptionUpdate   callbackReference
    ${ADDRESS}           Get value entry from JSON file  UserLocationEventSubscriptionUpdate   address
    Should be Equal   ${response['body']['subscriptionType']}    UserLocationEventSubscription
    Should be Equal   ${response['body']['clientCorrelator']}    ${CLIENT_CORR} 
    Should be Equal   ${response['body']['callbackReference']}   ${CALLBACK_REF}  
    Should be Equal   ${response['body']['address']}             ${ADDRESS} 
    Check HTTP Response Status Code Is    200
    [TearDown]  Remove a subscription  ${SUB_ID}
    

TC_MEC_MEC013_SRV_UELOCSUB_003_OK_02
    [Documentation]
    ...    Check that the IUT acknowledges a request to modify an existing subscription by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create a subscription    UserLocationPeriodicSubscription

    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    
    Update a subscription    ${SUB_ID}  UserLocationPeriodicSubscriptionUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserLocationPeriodicSubscription
    ${CLIENT_CORR}       Get value entry from JSON file  UserLocationPeriodicSubscriptionUpdate   clientCorrelator
    ${CALLBACK_REF}      Get value entry from JSON file  UserLocationPeriodicSubscriptionUpdate   callbackReference
    ${ADDRESS}           Get value entry from JSON file  UserLocationPeriodicSubscriptionUpdate   address
    ${PER_EVENT_INFO}    Get value entry from JSON file  UserLocationPeriodicSubscriptionUpdate   periodicEventInfo
    Should be Equal   ${response['body']['subscriptionType']}    UserLocationPeriodicSubscription
    Should be Equal   ${response['body']['clientCorrelator']}        ${CLIENT_CORR} 
    Should be Equal   ${response['body']['callbackReference']}       ${CALLBACK_REF}  
    Should be Equal   ${response['body']['address']}                 ${ADDRESS} 
    Should be Equal   ${response['body']['periodicEventInfo']}       ${PER_EVENT_INFO} 
    [TearDown]  Remove a subscription    ${SUB_ID}



TC_MEC_MEC013_SRV_UELOCSUB_003_BR_02
    [Documentation]
    ...    Check that the IUT responds with an error when received an inconsistent request
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a subscription    UserLocationPeriodicSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    Update a subscription    ${SUB_ID}  UserLocationEventSubscriptionUpdateBR
    Check HTTP Response Status Code Is    400
    [TearDown]  Remove a subscription  ${SUB_ID}
    

TC_MEC_MEC013_SRV_UELOCSUB_003_NF
    [Documentation]
    ...    Check that the IUT acknowledges a request to modify a not existing subscription by a MEC Application
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.2
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Remove a subscription  ${NON_EXISTENT_SUBSCRIPTION_ID}  
    Update a subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}   UserLocationEventSubscriptionUpdate
    Check HTTP Response Status Code Is    404
    
*** Keywords ***
Create a subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Update a subscription
    [Arguments]    ${subscription_id}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}    
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users/${subscription_id}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

    
Retrieve a subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Remove a subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    



Spawn Notification Server
    [Arguments]  ${payload_notification}
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    ${length} =  Get Length  ${output}
    Set Suite Variable    ${payload_notification}    ${output}
    Run Keyword If  ${length} == 0  Skip
    
    