*** Settings ***

Documentation
...    A test suite for validating MEC Liveness Service (MLS) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables_sandbox.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    


*** Test Cases ***
TC_MEC_MEC011_SRV_MSL_001_OK
    [Documentation]
    ...    Check that the IUT responds with the liveness of a MEC service instance 
    ...     when queried by a MEC Application
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.12",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.2.4",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.10.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create new service   ServiceInfo    ${APP_INSTANCE_ID}
    Individual MEC service liveness  ${LIVENESS_URI} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceLivenessInfo
    Check Response Contains    ${response['body']}   state    ACTIVE
    [TearDown]   Remove individual service    ${APP_INSTANCE_ID}   ${SERVICE_NAME}
    
TC_MEC_MEC011_SRV_MSL_001_NF
    [Documentation]
    ...   Check that the IUT responds with an error when
    ...   a request for an URI that cannot be mapped to a valid resource URI 
    ...   is sent by a MEC Application
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.12",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.2.4",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.10.3.1"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Individual MEC service liveness  ${NOT_EXISTING_URL_SERVICE_MEC_LIVENESS}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_MSL_002_OK_01
    [Documentation]
    ...    Check that the IUT updates the liveness of a MEC service instance 
    ...    when requested by a MEC Application
    ...    Reference  "ETSI GS MEC 011 3.2.1, clause 5.2.12",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.1.2.5",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.2.10.3.3"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ServiceLivenessUpdate    .json
    ${body}=    Get File    ${file}
    [Setup]   Create new service   ServiceInfo    ${APP_INSTANCE_ID}
    Update MEC service liveness  ${URL_SERVICE_MEC_LIVENESS}  ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceLivenessInfo
    Check Response Contains    ${response['body']}   state    ACTIVE
    [TearDown]   Remove individual service    ${APP_INSTANCE_ID}   ${SERVICE_NAME}


TC_MEC_MEC011_SRV_MSL_002_OK_02
    [Documentation]
    ...    Check that the IUT updates the liveness of a MEC service instance 
    ...    when requested by a MEC Application
    ...    Reference  "ETSI GS MEC 011 3.2.1, clause 5.2.12",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.1.2.5",
    ...               "ETSI GS MEC 011 3.2.1, clause 8.2.10.3.3"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ServiceLivenessUpdate    .json
    ${body}=    Get File    ${file}
    Update MEC service liveness  ${URL_SERVICE_MEC_LIVENESS}  ${body}
    Check HTTP Response Status Code Is    204
    

TC_MEC_MEC011_SRV_MSL_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    incorrect parameters were sent by a MEC Application
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.12",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.2.5",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.10.3.3"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Set Headers    {"Authorization":"${TOKEN}"}
    
    ${file}=    Catenate    SEPARATOR=    jsons/    ServiceLivenessUpdateError    .json
    ${body}=    Get File    ${file}
    Update MEC service liveness  ${URL_SERVICE_MEC_LIVENESS}  ${body}
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC011_SRV_MSL_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when 
    ...    a request for an URI that cannot be mapped to a valid 
    ...    resource URI is sent by a MEC Application
    ...    Reference    "ETSI GS MEC 011 3.2.1, clause 5.2.12",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.1.2.5",
    ...                 "ETSI GS MEC 011 3.2.1, clause 8.2.10.3.3"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ServiceLivenessUpdateError    .json
    ${body}=    Get File    ${file}
    Update MEC service liveness  ${NOT_EXISTING_URL_SERVICE_MEC_LIVENESS}  ${body}
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
    POST      ${SCHEMA_APP_SAQ}://${HOST_APP_SAQ}:${PORT_APP_SAQ}/${apiRoot_APP_SAQ}${apiName_APP_SAQ}/${apiVersion_APP_SAQ}/applications/${appInstanceId}/services    ${body}
    Log      ${SCHEMA_APP_SAQ}://${HOST_APP_SAQ}:${PORT_APP_SAQ}/${apiRoot_APP_SAQ}${apiName_APP_SAQ}/${apiVersion_APP_SAQ}/applications/${appInstanceId}/services
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable     ${LIVENESS_URI}     ${response['body']['_links']['liveness']['href']}   
    Set Suite Variable     ${SERVICE_NAME}     ${response['body']['serName']}   
    


Remove individual service
    [Arguments]    ${appInstanceId}    ${serviceName} 
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    DELETE    ${SCHEMA_APP_SAQ}://${HOST_APP_SAQ}:${PORT_APP_SAQ}/${apiRoot_APP_SAQ}${apiName_APP_SAQ}/${apiVersion_APP_SAQ}/applications/${appInstanceId}/services/${serviceName}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
    
Individual MEC service liveness
    [Arguments]    ${URL_MEC_SERVICE_LIVENESS}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get     ${URL_MEC_SERVICE_LIVENESS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Update MEC service liveness
    [Arguments]    ${URL_MEC_SERVICE_LIVENESS}  ${body}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"application/json"}
    Patch     ${URL_MEC_SERVICE_LIVENESS}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    