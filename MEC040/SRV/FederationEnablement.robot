Y''[Documentation]   robot --outputdir ../../../outputs ./FederationEnablement.robot
...    Test Suite to validate the Federation Enablement API (FED) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    

*** Test Cases ***
TP_MEC_MEC040_SRV_MEF_001_OK
    [Documentation]
    ...  Check that the IUT responds with a list of all available systemInfo 
    ...  when requested by a MEC Orchestrator - No query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList


TP_MEC_MEC040_SRV_MEF_001_OK_02
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - SystemId query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${SYSTEM_ID_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[systemId]      ${EXPECTED_SYSTEM_ID}
    END

TP_MEC_MEC040_SRV_MEF_001_OK_03
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo 
    ...  when requested by a MEC Orchestrator - Multiple SystemId query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${MULTIPLE_SYSTEM_ID_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    
    FOR  ${element}  IN  @{response['body']}
      IF    '''${element}[systemId]''' == '''${EXPECTED_SYSTEM_ID}'''
        ${item}    Set Variable   ${TRUE}
      END
      IF    '''${element}[systemId]''' == '''${EXPECTED_SYSTEM_ID2}'''
        ${item2}    Set Variable   ${TRUE}
      END
    END
    Should Be True  ${item}
    Should Be True  ${item2}
   
TP_MEC_MEC040_SRV_MEF_001_OK_04
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - Empty SystemId query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList

TP_MEC_MEC040_SRV_MEF_001_OK_05
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - SystemName query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${SYSTEM_NAME_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[systemName]      ${EXPECTED_SYSTEM_NAME}
    END

TP_MEC_MEC040_SRV_MEF_001_OK_06
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - Multiple SystemName query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params     ${MUTIPLE_SYSTEM_NAME_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      IF    '''${element}[systemName]''' == '''${EXPECTED_SYSTEM_NAME}'''
        ${item}    Set Variable   ${TRUE}
      END
      IF    '''${element}[systemName]''' == '''${EXPECTED_SYSTEM_NAME2}'''
        ${item2}    Set Variable   ${TRUE}
      END
    END
    Should Be True  ${item}
    Should Be True  ${item2}


TP_MEC_MEC040_SRV_MEF_001_OK_07
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - Empty SystemName query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params     ${EMPTY_SYSTEM_NAME_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[systemName]      ${EMPTY}
    END

TP_MEC_MEC040_SRV_MEF_001_OK_08
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - systemProvider query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params     ${SYSTEM_PROVIDER_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[systemProvider]      ${EXPECTED_SYSTEM_PROVIDER}
    END    

TP_MEC_MEC040_SRV_MEF_001_OK_09
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - Multiple systemProvider query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${MUTIPLE_SYS_PROVIDER_QUERY_PAR}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      IF    '''${element}[systemProvider]''' == '''${EXPECTED_SYSTEM_PROVIDER}'''
        ${item}    Set Variable   ${TRUE}
      END
      IF    '''${element}[systemProvider]''' == '''${EXPECTED_SYSTEM_PROVIDER2}'''
        ${item2}    Set Variable   ${TRUE}
      END
    END
    Should Be True  ${item}
    Should Be True  ${item2} 


TP_MEC_MEC040_SRV_MEF_001_OK_10
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - Empty systemProvider query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${EMPTY_SYSTEM_PROVIDER_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[systemProvider]      ${EMPTY}
    END
    
TP_MEC_MEC040_SRV_MEF_001_OK_11
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo
    ...  when requested by a MEC Orchestrator - Multiple query parameters
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${FILTER_ON_SYSTEM_ID_AND_NAME}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfoList
    ${counterSystemId}    Set Variable    ${0}
    ${counterSystemName}  Set Variable    ${0}
    FOR  ${element}  IN  @{response['body']}
      IF    '''${element}[systemId]''' == '''${EXPECTED_SYSTEM_ID}'''
        ${counterSystemId}=  set variable  ${counterSystemId+1}
      END
      IF    '''${element}[systemId]''' == '''${EXPECTED_SYSTEM_ID}'''
         ${counterSystemName}=  set variable  ${counterSystemName+1}
      END
      ${counterSystemName}=  set variable  ${counterSystemName+1}
    END
    Should Be True    '${counterSystemName}'>'0'
    Should Be True    '${counterSystemId}'>'0'
                                    
TP_MEC_MEC040_SRV_MEF_001_NF_01
    [Documentation]
    ...  Check that the IUT responds with an error 
    ...  when selection is not applicable - SystemId
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${NOT_EXT_SYSTEM_ID_QUERY_PARAM}
    Check HTTP Response Status Code Is    404

TP_MEC_MEC040_SRV_MEF_001_NF_02
    [Documentation]
    ...  Check that the IUT responds with an error
    ...  when selection is not applicable - SystemName
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${NOT_EXT_SYSTEM_NAME_QUERY_PARAM}
    Check HTTP Response Status Code Is    404


TP_MEC_MEC040_SRV_MEF_001_NF_03
    [Documentation]
    ...  Check that the IUT responds with an error
    ...  when selection is not applicable - SystemProvider
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve all system info resources with query params   ${NOT_EXT_SYS_PROVIDER_QUERY_PARAM}
    Check HTTP Response Status Code Is    404

##TODO double check
TP_MEC_MEC040_SRV_MEF_001_BR
    [Documentation]
    ...  Check that the IUT responds with an error when request is malformed
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.1, clause 5.2.2.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
   Retrieve all system info resources wrong URL
   #Check HTTP Response Status Code Is    400
    
TP_MEC_MEC040_SRV_MEF_002_OK
    [Documentation]
    ...  Check that the IUT creates a new systemInfo when requested by a MEC Orchestrator
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.4, clause 5.2.2.1.1
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Register System Info    SystemInfo
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  SystemInfo   
    

TP_MEC_MEC040_SRV_MEF_002_BR_01
    [Documentation]
    ...  Check that the IUT responds with an error on creating an existing systemInfo
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.4, clause 5.2.2.1.1
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Register System Info    SystemInfoBR
    Check HTTP Response Status Code Is    400


##TODO double check
TP_MEC_MEC040_SRV_MEF_002_BR_02
    [Documentation]
    ...  Check that the IUT responds with an error on providing inconsistent data
    ...  ETSI GS MEC 040 V3.1.1, clause 7.3.3.4, clause 5.2.2.1.1
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Register System Info    SystemInfoBR
    Check HTTP Response Status Code Is    400    
    
TP_MEC_MEC040_SRV_MEF_003_OK
    [Documentation]
    ...  Check that the IUT responds with a selection of all available systemInfo 
    ...  when requested by a MEC Orchestrator
    ...  ETSI GS MEC 040 V3.1.1, clause 7.4.3.1, clause 5.2.2.1.1
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve specific system info resource   ${EXPECTED_SYSTEM_ID} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  SystemInfo
    
TP_MEC_MEC040_SRV_MEF_003_NF
    [Documentation]
    ...  Check that the IUT responds with an error
    ...  when it receives a request for returning a systemInfo  referred with a wrong systemId
    ...  ETSI GS MEC 040 V3.1.1, clause 7.4.3.1, clause 5.2.2.1.1
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve specific system info resource    ${NOT_EXISTING_SYSTEM_ID} 
    Check HTTP Response Status Code Is    404

##TODO double check    
TP_MEC_MEC040_SRV_MEF_003_BR
    [Documentation]
    ...  Check that the IUT responds with an error
    ...  when it receives a request for returning a systemInfo  referred with a wrong systemId
    ...  ETSI GS MEC 040 V3.1.1, clause 7.4.3.1, clause 5.2.2.1.1
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Retrieve specific system info resource    ${NOT_EXISTING_SYSTEM_ID} 
    #Check HTTP Response Status Code Is    400
    
TP_MEC_MEC040_SRV_MEF_004_OK_01
    [Documentation]
    ...  Check that the IUT updates the systemInfo when requested by a MEC Orchestrator
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.3, clause 5.2.2.1.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Update specific system info resource  ${EXPECTED_SYSTEM_ID}    SystemInfoUpdate
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings    ${response['body']['systemProvider']}        ${EXPECTED_NEW_SYSTEM_PROVIDER}

TP_MEC_MEC040_SRV_MEF_004_OK_02
    [Documentation]
    ...  Check that the IUT updates the systemInfo when requested by a MEC Orchestrator
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.3, clause 5.2.2.1.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Update specific system info resource  ${EXPECTED_SYSTEM_ID}    SystemInfoUpdate2
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings    ${response['body']['systemName']}        ${EXPECTED_NEW_SYSTEM_NAME}
  
TP_MEC_MEC040_SRV_MEF_004_OK_02
    [Documentation]
    ...  Check that the IUT updates the systemInfo when requested by a MEC Orchestrator
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.3, clause 5.2.2.1.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Update specific system info resource  ${EXPECTED_SYSTEM_ID}    SystemInfoUpdate3
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings    ${response['body']['systemName']}        ${EXPECTED_NEW_SYSTEM_NAME}
    Should Be Equal As Strings    ${response['body']['systemProvider']}    ${EXPECTED_NEW_SYSTEM_PROVIDER}

TP_MEC_MEC040_SRV_MEF_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when requested to update an unknown systemInfo
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.3, clause 5.2.2.1.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Update specific system info resource  ${NOT_EXISTING_SYSTEM_ID}    SystemInfoUpdate3
    Check HTTP Response Status Code Is    404

##TODO double check the corresponding TP
#TP_MEC_MEC040_SRV_MEF_004_BR_01
    #[Documentation]
    #...  Check that the IUT responds with an error when requested to update with an inconsistant URI
    #...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.3, clause 5.2.2.1.2
    #...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    #Update specific system info resource  ${NOT_EXISTING_SYSTEM_ID}    SystemInfoUpdate3
    #Check HTTP Response Status Code Is    400

TP_MEC_MEC040_SRV_MEF_004_BR_02
    [Documentation]
    ...  Check that the IUT responds with an error when requested to update with no data provided
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.3, clause 5.2.2.1.2
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Update specific system info resource  ${EXPECTED_SYSTEM_ID}    SystemInfoUpdateBR
    Check HTTP Response Status Code Is    400            
    
TP_MEC_MEC040_SRV_MEF_005_OK
    [Documentation]
    ...  Check that the IUT responds with an error when requested to delete an unknown systemInfo
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.5, clause 5.2.2.1.3
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Remove specific system info resource  ${EXPECTED_SYSTEM_ID}  
    Check HTTP Response Status Code Is    204  
    
TP_MEC_MEC040_SRV_MEF_005_NF
    [Documentation]
    ...  Check that the IUT responds with an error when requested to delete an unknown systemInfo
    ...  ETSI GS MEC 040 V3.1.1, clause clause 7.4.3.5, clause 5.2.2.1.3
    ...  https://www.etsi.org/deliver/etsi_gs/mec/001_099/040/03.01.01_60/gs_mec040v030101p.pdf
    Remove specific system info resource  ${NOT_EXISTING_SYSTEM_ID}  
    Check HTTP Response Status Code Is    404
############################################################################


   
      
*** Keywords ***
Retrieve all system info resources
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/fed_resources/system_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Retrieve all system info resources with query params
    [Arguments]     ${query_params}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/fed_resources/system_info?${query_params}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

 Retrieve specific system info resource
    [Arguments]     ${SYSTEM_INFO_ID}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/fed_resources/system_info/${SYSTEM_INFO_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
        
Register System Info
    [Arguments]     ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    POST   ${apiRoot}/${apiName}/${apiVersion}/fed_resources/system_info   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  


Update specific system info resource
    [Arguments]     ${systemId}     ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    PATCH  ${apiRoot}/${apiName}/${apiVersion}/fed_resources/system_info/${systemId}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Remove specific system info resource 
    [Arguments]     ${systemId} 
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    DELETE  ${apiRoot}/${apiName}/${apiVersion}/fed_resources/system_info/${systemId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
        
Retrieve all system info resources wrong URL
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/v10/fed_resources/system_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    