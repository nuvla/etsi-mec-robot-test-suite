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