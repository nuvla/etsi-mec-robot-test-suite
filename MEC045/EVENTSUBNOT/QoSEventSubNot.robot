Y''[Documentation]   robot --outputdir ../../../outputs ./QoSEventSubNot.robot
...    Test Suite to validate QoSEventSubNot Service API operations.

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
TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_OK_01
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_OK_01
    ...    Check that the IUT acknowledges the creation of QoS event subscription request when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscription
    ${SUB_TYPE}   Get value entry from JSON file    QoSEventSubscription  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription
    Should Be Equal As Strings    ${response['body']['subscriptionType']}       ${SUB_TYPE}

TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_OK_02
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_OK_02
    ...    Check that the IUT acknowledges the creation of QoS event subscription request when commanded by a MEC Application - With thresholds
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionWithThreshold
    ${SUB_TYPE}   Get value entry from JSON file    QoSEventSubscriptionWithThreshold  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription
    Should Be Equal As Strings    ${response['body']['subscriptionType']}       ${SUB_TYPE}


TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_01
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_01
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Invalid SubscritionType
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionBR
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_02
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_02
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionBR2
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_03
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_03
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Both callbackReference and websockNotifConfig provided
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionBR3
    Check HTTP Response Status Code Is    400

TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_04
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_04
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - users not present (Note 2)
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionBR4
    Check HTTP Response Status Code Is    400


TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_05
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_05
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - flowFilter not present (Note 2)
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionBR5
    Check HTTP Response Status Code Is    400

    
TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_06
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_001_BR_06
    ...    Check that the IUT responds with an error when a request with incorrect parameters is sent 
    ...    by a MEC Application - Invalid flowFilter
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 6.4.3,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionBR6
    Check HTTP Response Status Code Is    400
    

    
TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_002_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_002_OK
    ...    Check that the IUT acknowledges the changes of QoS event subscription request 
    ...    when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 7.4.3.2
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Update QoS Event Subscription    QoSEventSubscriptionUpdate   ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  QoSEventSubscription


TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_002_NF
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_002_NF
    ...    Check that the IUT acknowledges the creation of QoS event subscription request when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 7.4.3.2
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Update QoS Event Subscription    QoSEventSubscriptionUpdate   ${UNKNOWN_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
        

TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_003_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_003_OK
    ...    Check that the IUT acknowledges the cancellation of QoS event subscription when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 7.4.3.5
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Delete QoS Event Subscription    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204
 
   
TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_003_NF
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_003_NF
    ...    Check that the IUT acknowledges the cancellation of QoS event subscription when commanded by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.3.3,
    ...    ETSI GS MEC 045 Clause 7.4.3.5
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Delete QoS Event Subscription    ${UNKNOWN_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_004_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_004_OK
    ...    Check that the IUT provides a test notification when requested by a MEC Application
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.4.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionTestNotification
    ${SUB_TYPE}   Get value entry from JSON file    QoSEventSubscriptionTestNotification  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription
    Should Be Equal As Strings    ${response['body']['subscriptionType']}       ${SUB_TYPE}


TC_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_005_OK
    [Documentation]    TP_MEC_MEC045_SRV_QOS_EVENT_SUB_NOT_005_OK
    ...    Check that the IUT terminates notifications when the expiry timer expires
    ...    ETSI GS MEC 045 Clause 5.2.2,
    ...    ETSI GS MEC 045 Clause 6.4.1,
    ...    ETSI GS MEC 045 Clause 7.3.3.4
    [Tags]    PIC_MEC_PLAT     PIC_SERVICES
    Create QoS Event Subscription    QoSEventSubscriptionExpiryTimer
    ${SUB_TYPE}   Get value entry from JSON file    QoSEventSubscriptionExpiryTimer  subscriptionType
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  QoSEventSubscription

    
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
