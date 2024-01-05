*** Settings ***

Documentation
...    A test suite for validating UE Area Lookup (UEAREALOOK) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String

Default Tags    TC_MEC_SRV_UEAREASUB



*** Test Cases ***
TP_MEC_MEC013_SRV_UEAREALOOK_001_OK_01
    [Documentation]
    ...    Check that the IUT responds with a list of UE area subscriptions when queried by a MEC Application - No filter
    ...
    ...    Reference   ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 7.16.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id    UserAreaSubscription
    Get all Subscriptions
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings    ${response['body']['subscription'][0]['subscriptionType']}    UserAreaSubscription
    [TearDown]   Remove subscription    ${SUB_ID}


TP_MEC_MEC013_SRV_UEAREALOOK_001_OK_02
    [Documentation]
    ...    Check that the IUT responds with a list of UE area subscriptions when queried by a MEC Application - No filter
    ...
    ...    Reference   ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.16.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id    UserAreaSubscription
    Get all Subscriptions with filter  ${SUB_TYPE_FILTER}
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings    ${response['body']['subscription'][0]['subscriptionType']}    UserAreaSubscription
    [TearDown]   Remove subscription    ${SUB_ID}


TP_MEC_MEC013_SRV_UEAREALOOK_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the change of UE area subscription request 
    ...    when commanded by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.17.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription and get sub id    UserAreaSubscription
    Get specific Subscription  ${SUB_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserAreaNotification
    Should be Equal   ${response['body']['notificationType']}    UserAreaNotification  
    [TearDown]   Remove subscription    ${SUB_ID}


TP_MEC_MEC013_SRV_UEAREALOOK_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...     when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 6.3.8
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.8
    ...    ETSI GS MEC 013 3.1.1 Clause 7.17.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Remove subscription    ${NON_EXISTING_SUBSCRIPTION_ID}
    Get specific Subscription  ${NON_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404



*** Keywords ***
Create new subscription and get sub id
    [Arguments]    ${content}    
    Create new subscription     ${content}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]} 
         

Get all Subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get specific Subscription
    [Arguments]    ${subscriptionId}   
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Get all Subscriptions with filter
    [Arguments]    ${filter}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area?subscription_type=${filter}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

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
    
Remove subscription
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/area/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
