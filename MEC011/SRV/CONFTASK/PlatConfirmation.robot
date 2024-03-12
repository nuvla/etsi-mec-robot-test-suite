*** Settings ***

Documentation
...    A test suite for validating Platform Configuration (CONF) operations.

Resource    ../../../GenericKeywords.robot
#Resource    environment/variables.txt
Resource    environment/variables_sandbox.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}  
Library     OperatingSystem 

Default Tags    TC_MEC_SRV_CONF


*** Test Cases ***
TC_MEC_MEC011_SRV_CONFTASK_001_OK
    [Documentation]
    ...    Check that the IUT responds that it has completed 
    ...    the application level termination
    ...
    ...    Reference   "ETSI GS MEC 011 3.2.1, clause 5.2.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.1.4.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.2.11.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a new MEC application instance profile  AppInfo       
    Request termination of MEC Application   ${APP_INSTANCE_ID}    AppTerminationConfirmation
    Check HTTP Response Status Code Is    204
    [Teardown]   Delete MEC application instance profile   ${APP_INSTANCE_ID}
    

TC_MEC_MEC011_SRV_CONFTASK_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error
    ...    when requested graceful termination/stop of an unknown MEC Application instance
    ...
    ...    Reference   "ETSI GS MEC 011 3.2.1, clause 5.2.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.1.4.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.2.11.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Teardown]   Delete MEC application instance profile   ${NON_EXISTING_APP_INSTANCE_ID}
    Request termination of MEC Application    ${NON_EXISTING_APP_INSTANCE_ID}    AppTerminationConfirmation
    Check HTTP Response Status Code Is    404
    



TC_MEC_MEC011_SRV_CONFTASK_002_OK
    [Documentation]
    ...    Check that the IUT responds with an acknowledge
    ...    when requested readiness status for a MEC Application instance
    ...
    ...    Reference   "ETSI GS MEC 011 3.2.1, clause 5.2.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.1.4.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.2.11.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a new MEC application instance profile  AppInfo       
    Request readiness status of MEC Application    ${APP_INSTANCE_ID}    AppReadyConfirmation
    Check HTTP Response Status Code Is    204
    [Teardown]   Delete MEC application instance profile   ${APP_INSTANCE_ID}
 

TC_MEC_MEC011_SRV_CONFTASK_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error
    ...    when requested readiness status for an unknown MEC Application instance
    ...
    ...    Reference   "ETSI GS MEC 011 3.2.1, clause 5.2.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.1.4.3",
    ...    "ETSI GS MEC 011 3.2.1, clause 7.2.11.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Delete MEC application instance profile   ${NON_EXISTING_APP_INSTANCE_ID}
    Request readiness status of MEC Application    ${NON_EXISTING_APP_INSTANCE_ID}   AppReadyConfirmation
    Check HTTP Response Status Code Is    404


*** Keywords ***
Create a new MEC application instance profile
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post      ${HOST_REG_APP}:${PORT_REG_APP}/${apiRoot_REG_APP}${apiName_REG_APP}/${apiVersion_REG_APP}/registrations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable    ${APP_INSTANCE_ID}   ${response['body']['appInstanceId']}



Delete MEC application instance profile
    [Arguments]    ${app_instance_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${HOST_REG_APP}:${PORT_REG_APP}/${apiRoot_REG_APP}${apiName_REG_APP}/${apiVersion_REG_APP}/registrations/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Request termination of MEC Application
    [Arguments]    ${appInstanceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/confirm_termination    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Request readiness status of MEC Application
    [Arguments]    ${appInstanceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/confirm_ready    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
