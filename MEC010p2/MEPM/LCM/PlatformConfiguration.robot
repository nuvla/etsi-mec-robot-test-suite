''[Documentation]   robot --outputdir ./outputs ./PlatformConfiguration.robot
...    Test Suite to validate Platform Configuration operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEPM_SCHEMA}://${MEPM_HOST}:${MEPM_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem


*** Test Cases ***
TC_MEC_MEC010p2_MEPM_LCM_001_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_LCM_001_OK
    ...    Check that MEC API provider has created the configuration information in AppD to the MEPM-V
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.7.6.3.1
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.21.2   #ConfigPlatformForAppRequest
    [Setup]   Create new App Instance  CreateAppInstanceRequest
    ${APPD_ID_SET}   Get value entry from JSON file    CreateAppInstanceRequest  appDId
    Request to configure Platform    ${APP_INSTANCE_ID}    ConfigPlatformForAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [Teardown]   Delete APP Instance   ${APPD_ID_SET}
    

TC_MEC_MEC010p2_MEPM_LCM_001_BR
    [Documentation]    TP_MEC_MEC010p2_MEPM_LCM_001_BR
    ...    Check that MEC API provider sends an error when it receives a malformed request for the configuration information in AppD to the MEPM-V
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.7.6.3.1
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.21.2   #ConfigPlatformForAppRequest

    Request to configure Platform   ${APP_INSTANCE_ID}   ConfigPlatformForAppRequestBadRequest
    Check HTTP Response Status Code Is    400
    


TC_MEC_MEC010p2_MEPM_LCM_001_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_LCM_001_BR
    ...    "Check that MEC API provider sends an error when it receives a request 
	...    for the configuration information in AppD to the MEPM-V with not valid app instance ID
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.7.6.3.1
    ...    ETS3.2.1MEC 010-2 3.2.1, Table 6.2.2.21.2-1   #ConfigPlatformForAppRequest

    Request to configure Platform   ${NOT_EXISTING_APP_INSTANCE_ID}   ConfigPlatformForAppRequest
    Check HTTP Response Status Code Is    404


*** Keywords ***
Create new App Instance
    [Arguments]    ${content}
    Log    Creating a new app package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Delete APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Request to configure Platform
    [Arguments]  ${appInstanceId}   ${content}
    Log    Request to configure platform
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/configure_platform_for_app  ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     