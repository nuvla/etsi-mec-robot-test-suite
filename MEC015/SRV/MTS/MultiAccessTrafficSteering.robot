''[Documentation]   robot --outputdir ../../../outputs ./MultiAccessTrafficSteering.robot
...    Test Suite to validate Multi-access traffic steering API (MTS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    
Library     String

*** Test Cases ***
TC_MEC_MEC015_SRV_MTS_001_OK
    [Documentation]
    ...  Check that the IUT responds with the Multi-access Traffic Steering information when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.6,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.4,
    ...  ETSI GS MEC 015 V2.1.1, clause 9.3.3.1
    Retrieve MTS capability information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsCapabilityInfo
    

TC_MEC_MEC015_SRV_MTS_002_OK_01
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.6,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 9.3.3.1
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    Retrieve MTS session list information   
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   


TC_MEC_MEC015_SRV_MTS_002_OK_02
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.6,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    Retrieve MTS session list information using filter  ${APP_NAME_FILTER}   ${APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    LOG  ${response}
    FOR    ${mstSessionInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${mstSessionInfo['appInsId']}    ${APP_INSTANCE_ID}   
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   

# TC_MEC_MEC015_SRV_MTS_002_OK_03
    # ##TODO the corresponding TP must be fixed: appName is not a property of mtsSessionInfo
    # [Documentation]
    # ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    # ...  ETSI GS MEC 015 V2.1.1, clause 6.2.6,
    # ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5,
    # ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    # [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    
    # ${APP_NAME}    Get value entry from JSON file    MtsSessionInfoApplicationSpecific   appName
    # Retrieve MTS session list information using filter  ${APP_NAME_FILTER}   ${APP_NAME}   
    # Check HTTP Response Status Code Is    200
    # Check HTTP Response Body Json Schema Is   MtsSessionInfo
    # [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   

# TC_MEC_MEC015_SRV_MTS_002_OK_04
    # ##TODO the corresponding TP must be fixed: sessionId is not a property of mtsSessionInfo
    # [Documentation]
    # ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    # ...  ETSI GS MEC 015 V2.1.1, clause 6.2.6,
    # ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5,
    # ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    # [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    
    # Check HTTP Response Status Code Is    200
    # Check HTTP Response Body Json Schema Is   MtsSessionInfo
    # [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   


    
TC_MEC_MEC015_SRV_MTS_002_BR
    [Documentation]
    ...  Check that the IUT responds with the list of configured Multi-access Traffic Steering when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    LOG  ${response}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    
    Retrieve MTS session list information using filter  ${BAD_FILTER}   ${APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    400
    [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   


TC_MEC_MEC015_SRV_MTS_002_NF
    [Documentation]
    ...  Check that the IUT responds with the list of configured Multi-access Traffic Steering when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    [Setup]   Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID} 
    Retrieve MTS session list information using filter  ${CORRECT_FILTER}   ${NOT_EXISTING_APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    404


       
TC_MEC_MEC015_SRV_MTS_003_OK_01
    [Documentation]
    ...  Check that the IUT creates a MTS session when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.7,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    [Setup]  Create new App Instance   CreateAppInstanceRequest
    Register MTS session    MtsSessionInfoApplicationSpecific
    
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    ${appInsId}    Get value entry from JSON file    MtsSessionInfoApplicationSpecific   appInsId
    ${requestType}    Get value entry from JSON file    MtsSessionInfoApplicationSpecific   requestType
    ${qosD}    Get value entry from JSON file    MtsSessionInfoApplicationSpecific   qosD
    ${mtsMode}    Get value entry from JSON file    MtsSessionInfoApplicationSpecific   mtsMode
    ${trafficDirection}    Get value entry from JSON file    MtsSessionInfoApplicationSpecific   trafficDirection    

    Should Be Equal As Strings  ${response['body']['appInsId']}    ${appInsId}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${requestType}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${qosD}
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${mtsMode}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${trafficDirection}
    [TearDown]   Delete APP Instance   ${APP_INSTANCE_ID} 

TC_MEC_MEC015_SRV_MTS_003_OK_02
    [Documentation]
    ...  Check that the IUT creates a MTS session when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    [Setup]  Create new App Instance   CreateAppInstanceRequest
    Register MTS session     MtsSessionInfoSessionSpecific
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    ${appInsId}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   appInsId
    ${requestType}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   requestType
    ${flowFilter}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   flowFilter
    ${qosD}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   qosD
    ${mtsMode}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   mtsMode
    ${trafficDirection}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   trafficDirection    

    Should Be Equal As Strings  ${response['body']['appInsId']}    ${appInsId}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${requestType}
    Should Be Equal As Strings  ${response['body']['flowFilter']}    ${flowFilter}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${qosD}
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${mtsMode}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${trafficDirection}
    [TearDown]   Delete APP Instance   ${APP_INSTANCE_ID} 

TC_MEC_MEC015_SRV_MTS_003_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml    
    [Setup]  Create new App Instance   CreateAppInstanceRequest
    Register MTS session     MtsSessionInfoApplicationSpecific_BR
    Check HTTP Response Status Code Is    400
    [TearDown]   Delete APP Instance   ${APP_INSTANCE_ID} 

TC_MEC_MEC015_SRV_MTS_004_OK
    [Documentation]
    ...  Check that the IUT responds with a configured Multi-access Traffic Steering session when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    Retrieve single MTS session   ${SESSION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo    
    ${appInsId}    Get value entry from JSON file            MtsSessionInfoSessionSpecific   appInsId
    ${requestType}    Get value entry from JSON file         MtsSessionInfoSessionSpecific   requestType
    ${mtsMode}    Get value entry from JSON file             MtsSessionInfoSessionSpecific   mtsMode
    ${trafficDirection}    Get value entry from JSON file    MtsSessionInfoSessionSpecific   trafficDirection
    Should Be Equal As Strings  ${response['body']['appInsId']}                   ${appInsId}
    Should Be Equal As Strings  ${response['body']['requestType']}             ${requestType}     
    Should Be Equal As Strings  ${response['body']['mtsMode']}                   ${mtsMode} 
    Should Be Equal As Strings  ${response['body']['trafficDirection']}         ${trafficDirection}   
    [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   
    

# TC_MEC_MEC015_SRV_MTS_004_BR
    # [Documentation]
    # ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    # ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.1
    # ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    # Retrieve single MTS session   ${WRONG_SESSION_ID}	
    # Check HTTP Response Status Code Is    400
    
TC_MEC_MEC015_SRV_MTS_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    [Setup]   Unregister from the MTS Service   ${NOT_EXISTING_SESSION_ID} 
    Retrieve single MTS session   ${NOT_EXISTING_SESSION_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC015_SRV_MTS_005_OK
    [Documentation]
    ...  Check that the IUT updates the information about an individual MTS session when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.9
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.2
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    Update requested requirements on the MTS Service    ${SESSION_ID}     MtsSessionInfoApplicationSpecificUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    ${appInsId}    Get value entry from JSON file            MtsSessionInfoApplicationSpecificUpdate   appInsId
    ${requestType}    Get value entry from JSON file         MtsSessionInfoApplicationSpecificUpdate   requestType
    ${qosD}    Get value entry from JSON file                MtsSessionInfoApplicationSpecificUpdate   qosD
    ${mtsMode}    Get value entry from JSON file             MtsSessionInfoApplicationSpecificUpdate   mtsMode
    ${trafficDirection}    Get value entry from JSON file    MtsSessionInfoApplicationSpecificUpdate   trafficDirection
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${appInsId}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${requestType}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${qosD} 
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${mtsMode}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${trafficDirection}  
    [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}   

    
TC_MEC_MEC015_SRV_MTS_005_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.9
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    Update requested requirements on the MTS Service    ${SESSION_ID}       MtsSessionInfoApplicationSpecificUpdate_BR
    Check HTTP Response Status Code Is    400
    [TearDown]   Unregister from the MTS Service And Delete APP Instance   ${SESSION_ID}    ${APP_INSTANCE_ID}  
    

TC_MEC_MEC015_SRV_MTS_005_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with an unknown resource URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.9
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    [Setup]  Unregister from the MTS Service  ${NOT_EXISTING_SESSION_ID}
    Update requested requirements on the MTS Service    ${NOT_EXISTING_SESSION_ID}     MtsSessionInfoApplicationSpecificUpdate
    Check HTTP Response Status Code Is    404
             

TC_MEC_MEC015_SRV_MTS_006_OK
    [Documentation]
    ...  Check that the IUT deregisters a MTS session when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.8
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.3
    [Setup]  Create new App Instance and Register MTS session  CreateAppInstanceRequest   MtsSessionInfoApplicationSpecific
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SESSION_ID}    ${elements}[3]
    Unregister from the MTS Service   ${SESSION_ID}
    Check HTTP Response Status Code Is    204

TC_MEC_MEC015_SRV_MTS_006_NF
    [Documentation]
    ...  Check that the IUT deregisters a MTS session when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.8
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.3
    [Setup]   Unregister from the MTS Service   ${NOT_EXISTING_SESSION_ID}
    Unregister from the MTS Service   ${NOT_EXISTING_SESSION_ID}
    Check HTTP Response Status Code Is    404
   
*** Keywords ***
Create new App Instance and Register MTS session 
     [Arguments]    ${appInstancePayload}    ${mtsSessionPayload}
     Create new App Instance     ${appInstancePayload}
     Register MTS session     ${mtsSessionPayload}
       
      

Unregister from the MTS Service And Delete APP Instance
    [Arguments]    ${sessionId}   ${app_instance_id}
    Unregister from the MTS Service    ${sessionId}
    Delete APP Instance    ${app_instance_id}
    
Create new App Instance
    [Arguments]    ${content}
    Log    Creating a new app package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    POST    http://${APP_INST_HOST}:${APP_INST_PORT}/${apiRoot_APP_INST}/${apiName_APP_INST}/${apiVersion_APP_INST}/app_instances    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable    ${APP_INSTANCE_ID}    ${response['body']['id']} 




Delete APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE    http://${APP_INST_HOST}:${APP_INST_PORT}/${apiRoot_APP_INST}/${apiName_APP_INST}/${apiVersion_APP_INST}/app_instances${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Retrieve MTS capability information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
  
Retrieve MTS session list information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Retrieve MTS session list information using filter
    [Arguments]    ${filter}  ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions?${filter}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Register MTS session
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

    

Register MTS session wrong URI
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    #Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    POST    ${apiRoot}/${apiName}/v10/mts_sessions   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    

    
Retrieve single MTS session
    [Arguments]    ${sessionId}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/${sessionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Update requested requirements on the MTS Service
    [Arguments]    ${sessionId}   ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    PUT    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/${sessionId}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Unregister from the MTS Service
    [Arguments]    ${sessionId} 
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    LOG   ${sessionId} 
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/${sessionId} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}