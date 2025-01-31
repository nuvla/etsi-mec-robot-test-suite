*** Settings ***
Resource    environment/variables.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     Collections
Library     String


*** Variable ***
@{data}    /alcmi/v1/app_instances|POST|{"key":"value"}    /alcmi/v1/app_instances|GET    /alcmi/v1/app_instances|PUT    
*** Test Cases ***
Request access to all resources using no token
    [Documentation]    TP_MEC_MEX_ANY_001_NT
    ...    Check that a MEC API provider responds with an error when it 
    ...    receives a request without token
    ...    ETSI GS MEC 009 1.1.1, clause 6.16.1
    [Tags]    GENERIC_TESTS    INCLUDE_UNDEFINED_SCHEMAS
    FOR    ${INDEX}    IN RANGE    0    3
        @{list}    Split String    ${data[${INDEX}]}    separator=|    max_split=-1
        Perform a generic request using no token    @{list}
    END
    
Request access to all resources using invalid token
    [Documentation]    TP_MEC_MEX_ANY_001_WT
    ...    Check that a MEC API provider responds with an error when it 
    ...    receives a request with an invalid token
    ...    ETSI GS MEC 009 1.1.1, clause 6.16.1
    [Tags]    GENERIC_TESTS    INCLUDE_UNDEFINED_SCHEMAS
    FOR    ${INDEX}    IN RANGE    0    3
       @{list}    Split String    ${data[${INDEX}]}    separator=|    max_split=-1
       Perform a generic request using invalid token    @{list}
    END


    
*** Keywords ***
Perform a generic request using no token
    [Arguments]   @{params}
    Run Keyword If     '@{params[1]}' == "POST"
    ...    Perform a POST using no token        ${params[0]}    ${params[2]}
    Run Keyword If     '@{params[1]}' == "GET"
    ...    Perform a GET using no token        ${params[0]}    
    Run Keyword If     '@{params[1]}' == "DELETE"
    ...    Perform a DELETE using no token        ${params[0]}
    Run Keyword If     '@{params[1]}' == "PUT"
    ...    Perform a PUT using no token        ${params[0]}    ${params[2]}
    Run Keyword If     '@{params[1]}' == "PATCH"
    ...    Perform a PATCH using no token        ${params[0]}    ${params[2]}


Perform a generic request using invalid token
    [Arguments]    @{params}
    Run Keyword If     '@{params[1]}' == "POST"
    ...    Perform a POST using invalid token    ${params[0]}    ${params[2]}
    Run Keyword If     '@{params[1]}' == "GET"
    ...    Perform a GET using invalid token     ${params[0]}     
    Run Keyword If     '@{params[1]}' == "DELETE"
    ...    Perform a DELETE using invalid token    ${params[0]}   
    Run Keyword If     '@{params[1]}' == "PUT"
    ...    Perform a PUT using invalid token        ${params[0]}      ${params[2]}
    Run Keyword If     '@{params[1]}' == "PATCH"
    ...    Perform a PATCH using invalid token        ${params[0]}      ${params[2]}


Perform a POST using no token
    [Arguments]   ${uri}    ${payload}
    Log    "Running post"
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    POST    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}



Perform a GET using no token
    [Arguments]    ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    
    GET    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}



Perform a DELETE using no token
    [Arguments]   ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    
    DELETE    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PUT using no token
    [Arguments]    ${uri}    ${payload}=None
    Log    "Running post"
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    PUT    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PATCH using no token
    [Arguments]    ${uri}    ${payload}=None
    Log    "Running post"
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    PATCH    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}

    
Perform a POST using invalid token
    [Arguments]   ${uri}    ${payload}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    POST    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}




Perform a GET using invalid token
    [Arguments]   ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}
    GET    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a DELETE using invalid token
    [Arguments]   ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}
    DELETE    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PUT using invalid token
    [Arguments]   ${uri}    ${payload}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    PUT    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PATCH using invalid token
    [Arguments]   ${uri}    ${payload}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    PATCH    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}
