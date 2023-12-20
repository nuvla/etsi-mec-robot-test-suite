*** Settings ***

Documentation
...    A test suite for validating Service Availability Query (SAQ) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem  

Default Tags    TC_MEC_SRV_SAQ



*** Test Cases ***
TC_MEC_MEC011_SRV_SAQ_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available MEC services
    ...    when queried by a MEC Application
    ...
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.5",
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 8.1.2.2",
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 8.2.3.3.1"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create new service   ServiceInfo    ${APP_INSTANCE_ID}
    ${SER_NAME}    Get value entry from JSON file   ServiceInfo     serName
    Get list of available MEC services
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfoList
    [TearDown]   Remove individual service    ${APP_INSTANCE_ID}   ${SER_NAME}
    

TC_MEC_MEC011_SRV_SAQ_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.5",
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 8.1.2.2",
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 8.2.3.3.1"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create new service   ServiceInfo    ${APP_INSTANCE_ID}
    ${SER_NAME}    Get value entry from JSON file   ServiceInfo     serName
    Get list of available MEC services with parameters    instance_id    ${INVALID_VALUE}
    Check HTTP Response Status Code Is    400
    [TearDown]   Remove individual service    ${APP_INSTANCE_ID}   ${SER_NAME}


TC_MEC_MEC011_SRV_SAQ_002_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific service
    ...    when queried by a MEC Application
    ...
    ...    "ETSI GS MEC 011 3.2.1, clause 5.2.5",
    ...    "ETSI GS MEC 011 3.2.1, clause 8.1.2.2",
    ...    "ETSI GS MEC 011 3.2.1, clause 8.2.4.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create new service   ServiceInfo    ${APP_INSTANCE_ID}
    ${SER_NAME}    Get value entry from JSON file   ServiceInfo     serName
    Get specific MEC service    ${response['body']['serInstanceId']}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Response Contains    ${response['body']}    serInstanceId     ${response['body']['serInstanceId']}
    [TearDown]   Remove individual service    ${APP_INSTANCE_ID}   ${SER_NAME}

TC_MEC_MEC011_SRV_SAQ_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    "ETSI GS MEC 011 3.2.1, clause 5.2.5",
    ...    "ETSI GS MEC 011 3.2.1, clause 8.1.2.2",
    ...    "ETSI GS MEC 011 3.2.1, clause 8.2.4.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [TearDown]   Remove individual service    ${APP_INSTANCE_ID}   ${NON_EXISTENT_SERVICE_ID}
    Get specific MEC service    ${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404


*** Keywords ***
Create new service
    [Arguments]    ${content}    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    POST      http://${HOST_APP_SAQ}:${PORT_APP_SAQ}/${apiRoot_APP_SAQ}${apiName_APP_SAQ}/${apiVersion_APP_SAQ}/applications/${appInstanceId}/services    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable     ${SERVICE_NAME}     ${response['body']['serName']}   
    
Remove individual service
    [Arguments]    ${appInstanceId}    ${serviceName} 
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    DELETE    http://${HOST_APP_SAQ}:${PORT_APP_SAQ}/${apiRoot_APP_SAQ}${apiName_APP_SAQ}/${apiVersion_APP_SAQ}/applications/${appInstanceId}/services/${serviceName}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Get list of available MEC services with parameters
    [Arguments]    ${key}=None    ${value}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/services?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get list of available MEC services
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/services
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get specific MEC service
    [Arguments]    ${serviceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/services/${serviceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}