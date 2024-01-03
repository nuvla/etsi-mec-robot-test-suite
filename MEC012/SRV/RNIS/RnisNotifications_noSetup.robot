''[Documentation]   robot --outputdir ../../outputs ./RnisNotifications_BV.robot
...    Test Suite to validate RNIS/Notification (RNIS) operations.

*** Settings ***

Resource     environment/variables.txt
Resource     ../../../pics.txt
Resource     ../../../GenericKeywords.robot
Library      libraries/Server.py
Library      REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library      BuiltIn
Library      OperatingSystem
Library      Collections
Library      String


*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_001_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about cell change if the RNIS 
    ...  service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.2
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    CellChangeSubscriptionRequest
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url        CellChangeNotification    
    Validate Json   CellChangeNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 

TC_MEC_MEC012_SRV_RNIS_002_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about RAB establishment 
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.3
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    RabEstSubscriptionRequest
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url         RabEstNotification
    Validate Json   RabEstNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 
    


TC_MEC_MEC012_SRV_RNIS_003_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about RAB modification 
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.4
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    RabModSubscription
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url      RabModNotification
    Validate Json   RabModNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 
    
    
TC_MEC_MEC012_SRV_RNIS_004_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about RAB release 
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.5
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    RabRelSubscription
    Spawn Notification Server  10.30.8.189  8888  5  POST  /callback_url      RabRelNotification
    Validate Json   RabRelNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 
        

TC_MEC_MEC012_SRV_RNIS_005_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about UE measurement report 
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.6
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    MeasRepUeSubscription
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url        MeasRepUeNotification
    Validate Json   MeasRepUeNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 

TC_MEC_MEC012_SRV_RNIS_006_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about UE timing advance  
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.7
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    MeasTaSubscription
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url        MeasTaNotification
    Validate Json   MeasTaNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 
    

TC_MEC_MEC012_SRV_RNIS_007_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about UE carrier aggregation reconfiguration   
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.8
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    CaReconfSubscription
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url     CaReconfNotification
    Validate Json   CaReconfNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 


TC_MEC_MEC012_SRV_RNIS_008_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about S1-U bearer   
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.10
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    S1BearerSubscription
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url          S1BearerNotification
    Validate Json   S1BearerNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 


TC_MEC_MEC012_SRV_RNIS_009_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about 5G NR UE measurement report
    ...  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.11
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    NrMeasRepUeSubscription
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url      NrMeasRepUeNotification
    Validate Json   NrMeasRepUeNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 

TC_MEC_MEC012_SRV_RNIS_010_OK
    [Documentation]   
    ...  Check that the RNIS service sends an RNIS notification about cell change if the RNIS 
    ...  service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.2.1, clause 6.4.2
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    #[Setup]  Send a request for a subscription    CellChangeSubscriptionRequestWithExpiration
    Spawn Notification Server  10.30.8.189  8888  ${NOTIFICATION_SERVER_TIMEOUT}  POST  /callback_url        ExpiryNotification
    Validate Json   ExpiryNotification.schema.json    ${payload_notification}
    #[TearDown]   Delete subscription   ${SUB_ID} 
    
    
*** Keywords ***
Send a request for a subscription    
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[4]} 


Delete subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    


Spawn Notification Server
    [Arguments]  ${host}  ${port}  ${timeout}  ${method}  ${endpoint}         ${payload_notification}
    ${output}   Spawn Web Server  ${host}  ${port}  ${timeout}  ${method}  ${endpoint}    ${payload_notification} 
    Set Suite Variable    ${payload_notification}    ${output}
