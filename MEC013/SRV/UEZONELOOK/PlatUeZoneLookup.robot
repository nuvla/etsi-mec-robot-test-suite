*** Settings ***

Documentation
...    A test suite for validating UE Zone Lookup (UEZONELOOK) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Default Tags    TC_MEC_SRV_RLOCLOOK


*** Test Cases ***
TC_MEC_MEC013_SRV_UEZONELOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list zones
    ...    when queried by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription   ZoneLocationEventSubscription  
    Get subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    [TearDown]  Remove subscription    ${SUB_ID}

TC_MEC_MEC013_SRV_UEZONELOOK_002_OK_01
    [Documentation]
    ...    Check that the IUT responds with the subscription when 
    ...    queried by a MEC Application - Zone location Event
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions   ZoneLocationEventSubscription     ZoneStatusSubscription
    Get sub info with filters    subscription_type    event
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    Should Be Equal As Strings    ${response['body']['subscription'][0]['subscriptionType']}    ZoneLocationEventSubscription
    [TearDown]  Remove multiple subscriptions    ${FIRST_SUB_ID}    ${SECOND_SUB_ID} 

TC_MEC_MEC013_SRV_UEZONELOOK_002_OK_02
    [Documentation]
    ...    Check that the IUT responds with the subscription when 
    ...    queried by a MEC Application - Zone Status
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions   ZoneLocationEventSubscription     ZoneStatusSubscription
    Get sub info with filters    subscription_type    status
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    Should Be Equal As Strings    ${response['body']['subscription'][0]['subscriptionType']}    ZoneStatusSubscription
        [TearDown]  Remove multiple subscriptions    ${FIRST_SUB_ID}    ${SECOND_SUB_ID} 

TC_MEC_MEC013_SRV_UEZONELOOK_002_OK_03
    [Documentation]
    ...    Check that the IUT responds with the subscription 
    ...    when queried by a MEC Application - UE location Event and address
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create multiple subscriptions   ZoneLocationEventSubscription     ZoneStatusSubscription
    Get sub info with multiple filters   subscription_type    status
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscriptionList
    Should Be Equal As Strings    ${response['body']['subscription'][0]['subscriptionType']}    ZoneStatusSubscription
    [TearDown]  Remove multiple subscriptions    ${FIRST_SUB_ID}    ${SECOND_SUB_ID} 



TC_MEC_MEC013_SRV_UEZONELOOK_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when inconsistent request was sent by a MEC Application - Invalid filter
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create new subscription   ZoneLocationEventSubscription    
    Get sub info with filters    subscription_type    dummy
    Check HTTP Response Status Code Is    400
    [TearDown]  Remove subscription    ${SUB_ID}


TC_MEC_MEC013_SRV_UEZONELOOK_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error
    ...     when inconsistent request was sent by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.3
    ...    ETSI GS MEC 013 3.1.1 Clause 7.11.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    Get the zone info location  ${NOT_EXISTING_SUB_ID}  
    Check HTTP Response Status Code Is    404



TC_MEC_MEC013_SRV_UEZONELOOK_003_OK_01
    [Documentation]
    ...    Check that the IUT responds with the subscription
    ...    when queried by a MEC Application - Zone location Event
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.11
    ...    ETSI GS MEC 013 3.1.1 Clause 6.3.6
    ...    ETSI GS MEC 013 3.1.1 Clause 7.12.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create multiple subscriptions   ZoneLocationEventSubscription     ZoneStatusSubscription
    Get single subscription with filter    ${FIRST_SUB_ID}    subscription_type    event
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ZoneLocationEventSubscription
    [TearDown]  Remove multiple subscriptions    ${FIRST_SUB_ID}    ${SECOND_SUB_ID} 


TC_MEC_MEC013_SRV_UEZONELOOK_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when the non existing subscription is queried by a MEC Application
    ...    ETSI GS MEC 013 3.1.1 Clause 7.12.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES  
    [Setup]   Create new subscription   ZoneLocationEventSubscription
    Get single subscription with filter    ${NOT_EXISTING_SUB_ID}    subscription_type    event
    Check HTTP Response Status Code Is    404
    [Teardown]  Remove subscription    ${SUB_ID} 
         

*** Keywords ***
Create new subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}

    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}


Create multiple subscriptions
    [Arguments]    ${first_sub}      ${second_sub}
    Create new subscription   ${first_sub}
    Set Suite Variable    ${FIRST_SUB_ID}    ${SUB_ID}
    Create new subscription   ${second_sub}
    Set Suite Variable    ${SECOND_SUB_ID}    ${SUB_ID}


Remove subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}    
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones/${subscription_id}
    ${output}=    Output    response

Remove multiple subscriptions
    [Arguments]    ${first_sub_id}      ${second_sub_id}
    Remove subscription   ${first_sub_id}
    Remove subscription   ${second_sub_id}
        


Get sub info with filters
    [Arguments]    ${filter_key}    ${filter_value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones?${filter_key}=${filter_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get sub info with multiple filters
    [Arguments]    ${filter_key}    ${filter_value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones?${filter_key}=${filter_value}&address=10.30.0.3
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Get the zone info location 
    [Arguments]    ${zoneId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones/${zoneId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get single subscription with filter
    [Arguments]    ${subscription_id}    ${filter_key}  ${filter_value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/zones/${subscription_id}?${filter_key}=${filter_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

