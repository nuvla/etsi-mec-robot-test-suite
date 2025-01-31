*** Settings ***

Documentation
...    A test suite for validating Service Subscriptions (SRVSUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables_sandbox.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 
Library     String
Default Tags    TC_MEC_SRV_SRVSUB


*** Test Cases ***
TC_MEC_MEC011_SRV_SRVSUB_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of subscriptions for notifications
    ...    on services availability when queried by a MEC Application
    ...
    ...    Reference  "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.2.8.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES    
    [Setup]  Create a new MEC application instance profile and create subscription  AppInfo   SerAvailabilityNotificationSubscription
    Get list of subscriptions    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinkList
    [TearDown]   Remove subscription and Delete MEC application instance profile   ${SUB_ID}   ${APP_INSTANCE_ID}


TC_MEC_MEC011_SRV_SRVSUB_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference  "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.2.8.3.1"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Remove MEC application   ${NON_EXISTENT_INSTANCE_ID}
    Get list of subscriptions    ${NON_EXISTENT_INSTANCE_ID}
    Check HTTP Response Status Code Is    404

TC_MEC_MEC011_SRV_SRVSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the subscription by a MEC Application
    ...    to notifications on service availability events
    ...
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.8.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    
    [Setup]  Create a new MEC application  AppInfo
    Create a new subscription    ${APP_INSTANCE_ID}    SerAvailabilityNotificationSubscription
    ${APP_SRVSUB_NOTIF_CALLBACK_URI}    Get value entry from JSON file   SerAvailabilityNotificationSubscription   callbackReference  
    ${SUB_TYPE}    Get value entry from JSON file   SerAvailabilityNotificationSubscription   subscriptionType  
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    SerAvailabilityNotificationSubscription
    Check HTTP Response Header Contains    Location
    Check Response Contains    ${response['body']}    subscriptionType    ${SUB_TYPE}
    Check Response Contains    ${response['body']}    callbackReference   ${APP_SRVSUB_NOTIF_CALLBACK_URI}
    [TearDown]  Remove MEC application   ${APP_INSTANCE_ID}
    

TC_MEC_MEC011_SRV_SRVSUB_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.8.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create a new MEC application  AppInfo
    Create a new subscription    ${APP_INSTANCE_ID}    SerAvailabilityNotificationSubscriptionError
    Check HTTP Response Status Code Is    400
    [TearDown]  Remove MEC application   ${APP_INSTANCE_ID}


TC_MEC_MEC011_SRV_SRVSUB_003_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific subscription
    ...    when queried by a MEC Application
    ...
    ...    Reference   "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...                "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...                "ETSI GS MEC 011 3.2.1, clause 8.2.9.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create a new MEC application instance profile and create subscription  AppInfo   SerAvailabilityNotificationSubscription
    Get individual subscription    ${APP_INSTANCE_ID}    ${SUB_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SerAvailabilityNotificationSubscription
    Check Response Contains    ${response['body']}    subscriptionType    SerAvailabilityNotificationSubscription
    [TearDown]   Remove subscription and Delete MEC application instance profile   ${SUB_ID}   ${APP_INSTANCE_ID}


    

TC_MEC_MEC011_SRV_SRVSUB_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference   "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...                "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...                "ETSI GS MEC 011 3.2.1, clause 8.2.9.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create a new MEC application  AppInfo
    Get individual subscription    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
   [TearDown]  Remove MEC application    ${APP_INSTANCE_ID} 

TC_MEC_MEC011_SRV_SRVSUB_004_OK
    [Documentation]
    ...    Check that the IUT acknowledges the unsubscribe from service availability event notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.9.3.5"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]  Create a new MEC application instance profile and create subscription  AppInfo   SerAvailabilityNotificationSubscription   
    Remove subscription    ${APP_INSTANCE_ID}    ${SUB_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC011_SRV_SRVSUB_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.6",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.3",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.9.3.5"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [TearDown]  Remove MEC application    ${NON_EXISTENT_INSTANCE_ID} 
    Remove subscription    ${NON_EXISTENT_INSTANCE_ID}    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


*** Keywords ***
Create a new MEC application
    [Arguments]    ${reg_app_content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${reg_app_content}    .json
    ${body}=    Get File    ${file}
    POST     ${SCHEMA_REGAPP}://${HOST_REGAPP}:${PORT_REGAPP}${apiRoot_REGAPP}/${apiName_REGAPP}/${apiVersion_REGAPP}/registrations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${APP_INSTANCE_ID}    ${output['body']['appInstanceId']}    

Remove MEC application
    [Arguments]  ${app_instance_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE     ${SCHEMA_REGAPP}://${HOST_REGAPP}:${PORT_REGAPP}${apiRoot_REGAPP}/${apiName_REGAPP}/${apiVersion_REGAPP}/registrations/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Create a new MEC application instance profile and create subscription
    [Arguments]    ${reg_app_content}   ${sub_content}
    Create a new MEC application  ${reg_app_content}
    Create a new subscription  ${APP_INSTANCE_ID}   ${sub_content}
    ${elements} =  Split String    ${response['body']['_links']['self']['href']}     /
    Set Suite Variable    ${SUB_ID}    ${elements[3]}
    

Remove subscription and Delete MEC application instance profile
    [Arguments]    ${subscription_id}  ${app_instance_id}
    Remove subscription   ${appInstanceId}   ${subscription_id}   
    Remove MEC application  ${app_instance_id}
    

Get list of subscriptions    
    [Arguments]    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/subscriptions
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
    
Get individual subscription 
    [Arguments]    ${appInstanceId}    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Remove subscription    
    [Arguments]    ${appInstanceId}    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}