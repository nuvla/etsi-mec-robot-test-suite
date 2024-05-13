*** Settings ***

Documentation
...    A test suite for validating UE Location Lookup (UELOCLOOK) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Default Tags    TC_MEC_SRV_UELOCLOOK

*** Test Cases ***
TC_MEC_MEC013_SRV_UELOCLOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list for the location of User Equipments 
    ...    when queried by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1, clause 5.3.2,
    ...    ETSI GS MEC 013 3.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a subscription and get sub id    UserLocationEventSubscription
    Get subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    [TearDown]   Remove subscription    ${SUB_ID}



TC_MEC_MEC013_SRV_UELOCLOOK_002_OK_01
    [Documentation]
    ...    Check that the IUT responds with the subscription 
    ...    when queried by a MEC Application - UE location Event
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1, clause 5.3.2,
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions and get sub ids    UserLocationEventSubscription    UserLocationPeriodicSubscription
    Get subscriptions with filter    subscription_type     event
    Check HTTP Response Status Code Is    200
    Should be Equal   ${response['body']['subscription'][0]['subscriptionType']}    UserLocationEventSubscription
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    [TearDown]   Remove subscriptions    ${SUB_ID_01}   ${SUB_ID_02}



TC_MEC_MEC013_SRV_UELOCLOOK_002_OK_02
    [Documentation]
    ...    Check that the IUT responds with the subscription 
    ...    when queried by a MEC Application - UE location Periodic
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1, clause 5.3.2,
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions and get sub ids    UserLocationEventSubscription    UserLocationPeriodicSubscription
    Get subscriptions with filter    subscription_type     periodic
    Check HTTP Response Status Code Is    200
    Should be Equal   ${response['body']['subscription'][0]['subscriptionType']}    UserLocationPeriodicSubscription
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    [TearDown]   Remove subscriptions    ${SUB_ID_01}   ${SUB_ID_02}
    



TC_MEC_MEC013_SRV_UELOCLOOK_002_OK_03
    [Documentation]
    ...    Check that the IUT responds with the subscription 
    ...    when queried by a MEC Application - UE location Event and address
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1, clause 5.3.2,
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions and get sub ids    UserLocationEventSubscription    UserLocationPeriodicSubscription
    Get subscriptions with filters    subscription_type     event     address     10.0.0.4
    Check HTTP Response Status Code Is    200
    Should be Equal   ${response['body']['subscription'][0]['subscriptionType']}    UserLocationEventSubscription
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    [TearDown]   Remove subscriptions    ${SUB_ID_01}   ${SUB_ID_02}


    
TC_MEC_MEC013_SRV_UELOCLOOK_002_BR
        [Documentation]
    ...  Check that the IUT responds with an error when 
    ...   inconsistent request was sent by a MEC Application - Invalid filter
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1, clause 5.3.2,
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions and get sub ids    UserLocationEventSubscription    UserLocationPeriodicSubscription
    Get subscriptions with filter    subscription_type     dummy
    Check HTTP Response Status Code Is    400
    [TearDown]   Remove subscriptions    ${SUB_ID_01}   ${SUB_ID_02}
    


TC_MEC_MEC013_SRV_UELOCLOOK_002_NF
        [Documentation]
    ...  Check that the IUT responds with an error 
    ...  when inconsistent request was sent by a MEC Application
    ...    Reference  ETSI GS MEC 013 3.1.1, clause 5.3.2,
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Remove subscriptions    ${SUB_ID_01}   ${SUB_ID_02}
    Get subscriptions
    Check HTTP Response Status Code Is    404
    [TearDown]   Remove subscriptions    ${SUB_ID_01}   ${SUB_ID_02}
    


TC_MEC_MEC013_SRV_UELOCLOOK_003_OK_01
    [Documentation]
    ...    Check that the IUT responds with the subscription 
    ...    when queried by a MEC Application - UE location Event
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a subscription and get sub id    UserLocationEventSubscription
    Get subscription by identifier   ${SUB_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserLocationEventSubscription
    [TearDown]   Remove subscription    ${SUB_ID}
    

TC_MEC_MEC013_SRV_UELOCLOOK_003_OK_02
    [Documentation]
    ...    Check that the IUT responds with the subscription when queried by a MEC Application - UE location Periodic
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a subscription and get sub id    UserLocationPeriodicSubscription
    Get subscription by identifier   ${SUB_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserLocationPeriodicSubscription
    [TearDown]   Remove subscription    ${SUB_ID}
    

    
TC_MEC_MEC013_SRV_UELOCLOOK_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when the non existing subscription is queried by a MEC Application
    ...
    ...    Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.4
    ...    ETSI GS MEC 013 3.1.1 Clause 6.4.4
    ...    ETSI GS MEC 013 3.1.1 Clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Remove subscription    ${NON_EXISTING_SUBSCRIPTION_ID}
    Get subscription by identifier   ${NON_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    


*** Keywords ***
Create a subscription and get sub id
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

Create multiple subscriptions and get sub ids
    [Arguments]    ${content}   ${content2}
    Create a subscription and get sub id  ${content}
    Set Suite Variable    ${SUB_ID_01}    ${SUB_ID}
    Create a subscription and get sub id  ${content2}
    Set Suite Variable    ${SUB_ID_02}    ${SUB_ID}


Remove subscriptions 
    [Arguments]    ${subscription_id01}   ${subscription_id02}
    Remove subscription  ${subscription_id01}
    Remove subscription  ${subscription_id02}
    

Remove subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
  

Get subscription by identifier
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
  
Get subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get subscriptions with filter
    [Arguments]    ${filter_name}    ${filter_value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users?${filter_name}=${filter_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Get subscriptions with filters
    [Arguments]    ${filter_name01}    ${filter_value01}    ${filter_name02}    ${filter_value02}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/users?${filter_name01}=${filter_value01}&${filter_name02}=${filter_value02}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
