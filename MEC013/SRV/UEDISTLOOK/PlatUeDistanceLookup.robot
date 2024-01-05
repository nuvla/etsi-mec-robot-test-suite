*** Settings ***

Documentation
...    A test suite for validating UE Distance Lookup (UEDISTLOOK) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem   
Library     String  
Default Tags    TC_MEC_SRV_UEDISTLOOK


*** Variables ***
${response}


*** Test Cases ***

TC_MEC_MEC013_SRV_UEDISTLOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with the list of UE distance subscriptions to a UE 
    ...    when queried by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 7.14.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES   INCLUDE_UNDEFINED_SCHEMAS
    [Setup]    Create new subscription and get sub id   UserDistanceSubscription 
    Get all Subscriptions
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings    ${response['body']['subscription'][0]['subscriptionType']}    UserDistanceSubscription
    [TearDown]  Remove subscription    ${SUB_ID}    

TC_MEC_MEC013_SRV_UEDISTLOOK_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when a request with 
    ...    incorrect parameters is sent by a MEC Application - Invalid filter
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 7.14.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES   INCLUDE_UNDEFINED_SCHEMAS
    Get all Subscriptions with error
    Check HTTP Response Status Code Is    400
    
TC_MEC_MEC013_SRV_UEDISTLOOK_002_OK
    [Documentation]
    ...    Check that the IUT responds with the distance to a UE 
    ...    when queried by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.9
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.9
    ...    ETSI GS MEC 013 3.1.1 Clause 7.15.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]    Create new subscription and get sub id   UserDistanceSubscription 
    Get specific Subscription    ${SUB_ID} 
    Check HTTP Response Body Json Schema Is    UserDistanceSubscription
    Check HTTP Response Status Code Is    200
   [TearDown]  Remove subscription     ${SUB_ID}    



TC_MEC_MEC013_SRV_UEDISTLOOK_002_NF
    [Documentation]
    ...    Check that the IUT responds with the distance to a UE 
    ...    when queried by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.9
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.9
    ...    ETSI GS MEC 013 3.1.1 Clause 7.15.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]    Remove subscription     ${NON_EXISTING_SUBSCRIPTION_ID} 
    Get specific Subscription    ${NON_EXISTING_SUBSCRIPTION_ID} 
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
    
Get all Subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get specific Subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Get all Subscriptions with error
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance?event=123
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Remove subscription
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/distance/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}