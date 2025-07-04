Y''[Documentation]   robot --outputdir ../../../outputs ./QoSMeasurementSubNot.robot
...    Test Suite to validate QoSMeasurementSubNot Service API operations.

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
TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_OK_01
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_OK_01
    ...    Check that the IUT acknowledges the creation of QoS measurement subscription request when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 6.4.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSMeasureSubscription
    ${SUB_TYPE}   Get value entry from JSON file    QoSMeasureSubscription  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription
    Should Be Equal As Strings    ${response['body']['subscriptionType']}       ${SUB_TYPE}

TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_OK_02
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_OK_02
    ...    Check that the IUT acknowledges the creation of QoS measurement subscription request when commanded by a MEC Application - with reportingInterval
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 6.4.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSMeasureSubscriptionWithRepInterval
    ${SUB_TYPE}   Get value entry from JSON file    QoSMeasureSubscriptionWithRepInterval  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription
    Should Be Equal As Strings    ${response['body']['subscriptionType']}       ${SUB_TYPE}


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_OK_03
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_OK_03
    ...    Check that the IUT acknowledges the creation of QoS measurement subscription request when commanded by a MEC Application - with numberOfReports
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 6.4.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSMeasureSubscriptionWithNumOfReports
    ${SUB_TYPE}   Get value entry from JSON file    QoSMeasureSubscriptionWithNumOfReports  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription
    Should Be Equal As Strings    ${response['body']['subscriptionType']}       ${SUB_TYPE}


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_01
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_01
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Invalid subscriptionType
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_02
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_02
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR2
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_03
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_03
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Both callbackReference and websockNotifConfig provided
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR3
    Check HTTP Response Status Code Is    400  
    

TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_04
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_04
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - users not present (Note 2)
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR4
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_05
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_05
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - flowInfo not present (Note 2)
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR5
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_06
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_06
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Invalid flowFilter
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR6
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_07
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_07
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Invalid condition on reportingInterval/measuringPeriod
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR7
    Check HTTP Response Status Code Is    400  
    
TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_08
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_001_BR_08
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Invalid condition on measuringArea
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSSubscriptionBR8
    Check HTTP Response Status Code Is    400  


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_002_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_002_OK
    ...    Check that the IUT acknowledges the changes of an existing QoS measurement subscription request when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.4.3.2
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Update QoS Event Subscription    QoSMeasureSubscriptionUpdate   ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  QoSEventSubscription


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_002_NF
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_002_NF
    ...    Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.4.3.2
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Update QoS Event Subscription    QoSMeasureSubscriptionUpdate   ${UNKNOWN_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  QoSEventSubscription


TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_003_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_003_OK
    ...    Check that the IUT acknowledges the cancellation of QoS measurement subscription when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.4.3.5
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Delete QoS Event Subscription   ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204    
    

TC_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_003_NF
    [Documentation]    TP_MEC_MEC045_SRV_QOS_MEAS_SUB_NOT_003_NF
    ...    Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.2,
    ...    ETSI GS MEC 045 Clause 7.4.3.5
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Delete QoS Event Subscription   ${UNKNOWN_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404     
    

*** Keywords ***
Spawn Expiry Notification Server
    Log    Starting notification server on ${NOTIFICATION_SERVER_IP}:${NOTIFICATION_SERVER_PORT} for expiry notification
    ${notification}=    Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}  ResourceUsageSubscription
    [Return]    ${notification}

Spawn Resource Notification Server
    Log    Starting notification server on ${NOTIFICATION_SERVER_IP}:${NOTIFICATION_SERVER_PORT}
    ${notification}=    Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}  ResourceUsageSubscription
    [Return]    ${notification}

Spawn Notification Server
    Log    Starting notification server on ${NOTIFICATION_SERVER_IP}:${NOTIFICATION_SERVER_PORT}
    ${notification}=    Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}  SiteResourceUsageSubscription
    [Return]    ${notification}

Create QoS Event Subscription
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update QoS Event Subscription
    [Arguments]    ${content}        ${SUBSCRIPTION_ID}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Delete QoS Event Subscription
    [Arguments]    ${SUBSCRIPTION_ID}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
