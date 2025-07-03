Y''[Documentation]   robot --outputdir ../../../outputs ./QoSLookup.robot
...    Test Suite to validate QoSLookup API operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem
Library     libraries/Server.py
Library     libraries/StressGenerator.py
Library     JSONLibrary
Library     String    
Library     Collections
Library     DateTime 

*** Test Cases ***
TC_MEC_MEC045_SRV_QOSLOOKUP_001_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_001_OK
    ...    Check that the IUT responds with the list of QoS measurement subscriptions when queried by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.4,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve all subscriptions
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  SubscriptionList


TC_MEC_MEC045_SRV_QOSLOOKUP_001_BR
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_001_BR
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.4,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscriptions with query params    ${SUBSCRIPTION_ID}    ${WRONG_QUERY_PARAM}
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOSLOOKUP_001_NF
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_001_NF
    ...    Check that the IUT responds with an error when no subscription are created
    ...    ETSI GS MEC 045 Clause 5.2.4,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve all subscriptions
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC045_SRV_QOSLOOKUP_002_OK_01
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_002_OK_01
    ...    Check that the IUT responds with the list of QoS measurement subscriptions when queried by a MEC Application - Filter on subscriptionId
    ...    ETSI GS MEC 045 Clause 5.2.5,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscriptions with query params    ${SUBSCRIPTION_ID}    ${SUB_ID_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SubscriptionList


TC_MEC_MEC045_SRV_QOSLOOKUP_002_OK_02
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_002_OK_02
    ...    Check that the IUT responds with the list of QoS measurement subscriptions when queried by a MEC Application - Filter on subscriptionType
    ...    ETSI GS MEC 045 Clause 5.2.5,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscriptions with query params    ${SUBSCRIPTION_ID}   ${SUB_TYPE_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SubscriptionList

TC_MEC_MEC045_SRV_QOSLOOKUP_002_NF_01
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_002_NF_01
    ...    Check that the IUT responds with with an error when no subscription matches with the filter - Filter on subscriptionType
    ...    ETSI GS MEC 045 Clause 5.2.5,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscriptions with query params    ${SUBSCRIPTION_ID}   ${NF_SUB_TYPE_QUERY_PARAM}
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is  SubscriptionList
    

TC_MEC_MEC045_SRV_QOSLOOKUP_002_NF_02
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_002_NF_02
    ...    Check that the IUT responds with with an error when no subscription matches with the filter - Filter on subscriptionId
    ...    ETSI GS MEC 045 Clause 5.2.5,
    ...    ETSI GS MEC 045 Clause 6.3.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscriptions with query params    ${SUBSCRIPTION_ID}   ${NF_SUB_TYPE_QUERY_PARAM}
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is  SubscriptionList


TC_MEC_MEC045_SRV_QOSLOOKUP_003_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_003_OK
    ...    Check that the IUT responds with a QoS measurement subscription when queried by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.5,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.4.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscription    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  QoSMeasurementSubscription


TC_MEC_MEC045_SRV_QOSLOOKUP_003_NF
    [Documentation]    TP_MEC_MEC045_SRV_QOSLOOKUP_003_NF
    ...    Check that the IUT responds with an error 
    ...    when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.5,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.4.3.1
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Retrieve Subscription    ${UNKNOWN_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    
    
*** Keywords ***
Retrieve all subscriptions
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
   
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Retrieve Subscription
    [Arguments]    ${SUBSCRIPTION_ID}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
   
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Retrieve Subscriptions with query params
    [Arguments]    ${SUBSCRIPTION_ID}   ${QUERY_PARAMS}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
   
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}?${QUERY_PARAMS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

