''[Documentation]   robot --outputdir ../../../outputs ./TrafficManagement.robot
...    Test Suite to validate Bandwidth Management allocations (BWA) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    
Library     String

*** Test Cases ***

TC_MEC_MEC015_SRV_TM_001_OK_01
    [Documentation]
    ...  Check that the IUT responds with the list of configured bandwidth allocations when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1  
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Retrieve the list of configured bandwidth allocations
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfoList
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}
    

TC_MEC_MEC015_SRV_TM_001_OK_02
    [Documentation]
    ...  Check that the IUT responds with the list of configured bandwidth allocations when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1  
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Retrieve the list of configured bandwidth using filter  ${CORRECT_FILTER}   ${APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfoList
    FOR    ${bwInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${bwInfo['appInsId']}    ${APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}
    

TC_MEC_MEC015_SRV_TM_001_OK_03
    [Documentation]
    ...  Check that the IUT responds with a configured bandwidth allocation when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    [Setup]    Create new App Instance and Register for bw service    CreateAppInstanceRequest     BwInfoApplicationSpecific                            
    Retrieve the list of configured bandwidth using filter  ${APP_NAME_FILTER}   ${APP_NAME}  
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfoList
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}
    
# TC_MEC_MEC015_SRV_TM_001_OK_04
    ##TODO To discuss the corresponding TP: the sessionId is not attribute of BwInfo data type
    # [Documentation]
    # ...  Check that the IUT responds with a configured bandwidth allocation when queried by a MEC Application
    # ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    # ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    # ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    # [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific                            
    # Retrieve the list of configured bandwidth using filter  ${SESSION_ID_FILTER}   ${SESSION_ID}  
    # Check HTTP Response Status Code Is    200
    # Check HTTP Response Body Json Schema Is   BwInfoList
    # [TearDown]  Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}
    


TC_MEC_MEC015_SRV_TM_001_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Retrieve the list of configured bandwidth using filter  ${BAD_FILTER}   ${APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is    400
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}


TC_MEC_MEC015_SRV_TM_001_NF_01
    [Documentation]
    ...  Check that the IUT responds with an error when
    ...  a request with an unknown resource URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1   
    Retrieve the list of configured bandwidth using filter  ${CORRECT_FILTER}   ${NON_EXISTENT_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is    404
 
TC_MEC_MEC015_SRV_TM_001_NF_02
    [Documentation]
    ...  Check that the IUT responds with an error when a request with an unknown resource URI is sent by a MEC Application - app_name
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1   
    Retrieve the list of configured bandwidth using filter  ${APP_NAME_FILTER}   ${NON_EXISTENT_APP_NAME}  
    Check HTTP Response Status Code Is    404
 
TC_MEC_MEC015_SRV_TM_001_NF_03
    [Documentation]
    ...  Check that the IUT responds with an error when a request with an unknown resource URI is sent by a MEC Application - session_id
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.1    
    Retrieve the list of configured bandwidth using filter  ${SESSION_ID_FILTER}   ${NON_EXISTENT_SESSION_ID}  
    Check HTTP Response Status Code Is    404   


TC_MEC_MEC015_SRV_TM_002_OK
    [Documentation]
    ...  Check that the IUT acknowledges a creation of a bandwidthAllocation resource
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2,
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4 
     [Setup]    Create new App Instance   CreateAppInstanceRequest 
     Registration for bandwidth services  ${APP_INSTANCE_ID}   BwInfoApplicationSpecific
     Check HTTP Response Status Code Is    201 
      Check HTTP Response Body Json Schema Is   BwInfo
     ${appInsId}    Get value entry from JSON file    BwInfoApplicationSpecific   appInsId
     ${requestType}    Get value entry from JSON file    BwInfoApplicationSpecific   requestType
     ${fixedAllocation}    Get value entry from JSON file    BwInfoApplicationSpecific   fixedAllocation
     ${allocationDirection}    Get value entry from JSON file    BwInfoApplicationSpecific   allocationDirection    
     Should Be Equal As Strings  ${response['body']['appInsId']}    ${appInsId}   
     Should Be Equal As Strings  ${response['body']['requestType']}    ${requestType}  
     Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${fixedAllocation}  
     Should Be Equal As Strings  ${response['body']['allocationDirection']}    ${allocationDirection}  
     [TearDown]    Delete App Instance   ${APP_INSTANCE_ID}    
    

TC_MEC_MEC015_SRV_TM_002_BR_01
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    [Setup]    Create new App Instance   CreateAppInstanceRequest
    Registration for bandwidth services  ${APP_INSTANCE_ID}   BwInfo_BR
    Check HTTP Response Status Code Is    400
    [TearDown]    Delete App Instance   ${APP_INSTANCE_ID}    
    
TC_MEC_MEC015_SRV_TM_002_BR_02
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    [Setup]    Create new App Instance   CreateAppInstanceRequest
    Registration for bandwidth services  ${APP_INSTANCE_ID}   BwInfo_BR2
    Check HTTP Response Status Code Is    400
    [TearDown]    Delete App Instance   ${APP_INSTANCE_ID}   



TC_MEC_MEC015_SRV_TM_003_OK
    [Documentation]
    ...  Check that the IUT responds with the configured bandwidth allocation when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.1
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Get a bandwidth allocation   ${ALLOCATION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${APP_INSTANCE_ID}
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}


TC_MEC_MEC015_SRV_TM_003_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.5
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.1
    [Setup]    Unregister Bandwidth Management Service   ${NON_EXISTENT_ALLOCATION_ID}
    Get a bandwidth allocation   ${NON_EXISTENT_ALLOCATION_ID}
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC015_SRV_TM_004_OK
    [Documentation]
    ...  Check that the IUT updates the requested bandwidth requirements when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Update a bandwidth allocation   ${ALLOCATION_ID}   BwInfoUpdate
    ${appInsId}    Get value entry from JSON file    BwInfoUpdate   appInsId
    ${fixedAllocation}    Get value entry from JSON file    BwInfoUpdate   fixedAllocation
    ${allocationDirection}    Get value entry from JSON file    BwInfoUpdate   allocationDirection    
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${appInsId} 
    Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${fixedAllocation}
    Should Be Equal As Strings  ${response['body']['allocationDirection']}   ${allocationDirection}
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}


TC_MEC_MEC015_SRV_TM_004_BR_01
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
    
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Update a bandwidth allocation   ${ALLOCATION_ID}   BwInfoUpdate_BR
    Check HTTP Response Status Code Is    400
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}


TC_MEC_MEC015_SRV_TM_004_BR_02
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Update a bandwidth allocation   ${ALLOCATION_ID}   BwInfoUpdate_BR2
    Check HTTP Response Status Code Is    400
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}


TC_MEC_MEC015_SRV_TM_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request sent by a MEC Application doesn't comply with a required condition
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
   
    [Setup]  Delete APP Instance    ${NON_EXISTENT_ALLOCATION_ID}
    Update a bandwidth allocation   ${NON_EXISTENT_ALLOCATION_ID}    BwInfoUpdate
    Check HTTP Response Status Code Is    404


TC_MEC_MEC015_SRV_TM_005_OK
    [Documentation]
    ...  Check that the IUT when provided with just the changes (deltas) updates the requested bandwidth requirements when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Request a deltas changes    ${ALLOCATION_ID}    BwInfoDeltas
    
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfoDelta
    ${appInsId}    Get value entry from JSON file    BwInfoDeltas   appInsId
    ${fixedAllocation}    Get value entry from JSON file    BwInfoDeltas   fixedAllocation
    ${allocationDirection}    Get value entry from JSON file    BwInfoDeltas   allocationDirection    
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${appInsId}   
    Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${fixedAllocation}  
    Should Be Equal As Strings  ${response['body']['allocationDirection']}    ${allocationDirection}  
    [TearDown]   Unregister bw Service And Delete APP Instance    ${ALLOCATION_ID}    ${APP_INSTANCE_ID}
        
TC_MEC_MEC015_SRV_TM_005_BR_01
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Request a deltas changes    ${ALLOCATION_ID}    BwInfoDeltas_BR
    Check HTTP Response Status Code Is    400

TC_MEC_MEC015_SRV_TM_005_BR_02
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application - sessionFilter shall be present
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Request a deltas changes    ${ALLOCATION_ID}    BwInfoDeltas_BR2
    Check HTTP Response Status Code Is    400
    
    
TC_MEC_MEC015_SRV_TM_005_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.4
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    [Setup]   Delete APP Instance    ${NON_EXISTENT_ALLOCATION_ID}
    Request a deltas changes    ${NON_EXISTENT_ALLOCATION_ID}    BwInfoDeltas
    Check HTTP Response Status Code Is    404


TC_MEC_MEC015_SRV_TM_006_OK
    [Documentation]
    ...  Check that the IUT unregisters from the Bandwidth Management Service when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.3
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.5
    [Setup]    Create new App Instance and Register for bw service   CreateAppInstanceRequest     BwInfoApplicationSpecific
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}
    Check HTTP Response Status Code Is    204
    [TearDown]   Delete APP Instance    ${ALLOCATION_ID}

TC_MEC_MEC015_SRV_TM_006_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 6.2.3
    ...  ETSI GS MEC 015 V2.1.1, clause 7.2.2
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.5
    [Setup]   Unregister Bandwidth Management Service    ${NON_EXISTENT_ALLOCATION_ID}        
    Unregister Bandwidth Management Service    ${NON_EXISTENT_ALLOCATION_ID}
    Check HTTP Response Status Code Is    404
        

*** Keywords ***
Create new App Instance and Register for bw service
     [Arguments]    ${appInstancePayload}    ${bwServicePayload}
     Create new App Instance     ${appInstancePayload}
     Registration for bandwidth services   ${APP_INSTANCE_ID}    ${bwServicePayload}
     ${elements} =  Split String    ${response['headers']['Location']}       /
     Set Suite Variable    ${ALLOCATION_ID}    ${elements}[3]
     
       
     
Unregister bw Service And Delete APP Instance
    [Arguments]    ${allocationId}   ${app_instance_id}
    Unregister Bandwidth Management Service   ${allocationId}
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

Retrieve the list of configured bandwidth allocations
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/bw_allocations
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Retrieve the list of configured bandwidth using filter
    [Arguments]    ${filter}  ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations?${filter}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
     
Retrieve a configured bandwidth allocations
    [Arguments]    ${app_instance_id}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Registration for bandwidth services
    [Arguments]    ${app_instance_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post     ${apiRoot}/${apiName}/${apiVersion}/bw_allocations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get a bandwidth allocation
    [Arguments]    ${allocation_id}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update a bandwidth allocation
    [Arguments]    ${allocation_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Request a deltas changes
    [Arguments]    ${allocation_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Unregister Bandwidth Management Service
    [Arguments]    ${allocationId}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocationId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
