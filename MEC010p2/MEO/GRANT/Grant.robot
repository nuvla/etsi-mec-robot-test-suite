''[Documentation]   robot --outputdir ./outputs ./Grant.robot
...    Test Suite to validate Grant operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEO_SCHEMA}://${MEO_HOST}:${MEO_PORT}    ssl_verify=false
Library     OperatingSystem


Test Setup       Test Setup   ${GRANT_ID_PLACEHOLDER}   grantRequest      ${NO_ACTION}
Test Teardown    Test TearDown    ${GRANT_ID_PLACEHOLDER}   grantRequest      ${NO_ACTION}


*** Test Cases ***
TC_MEC_MEC010p2_MEO_GRANT_001_OK
    [Documentation]   TP_MEC_MEC010p2_MEO_GRANT_001_OK
    ...  Check that MEO sends a synchronous grant response when a grant request is requested
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.5.1.3.1
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.2.2-1 (GrantRequest)
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.2.2-1 Note 2 (GrantRequest)
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a GRANT request    grantRequest
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   Grant

TC_MEC_MEC010p2_MEO_GRANT_001_BR
    [Documentation]   TP_MEC_MEC010p2_MEO_GRANT_001_BR
    ...  Check that MEO responds with an error when it receives a malformed request when a new grant request is performed
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.6.1.3.2
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a GRANT request    grantBadRequest
    Check HTTP Response Status Code Is    400

TC_MEC_MEC010p2_MEO_GRANT_002_OK
    [Documentation]  TP_MEC_MEC010p2_MEO_GRANT_002_OK  
    ...  Check that MEO sends a synchronous grant response when a grant request is requested
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.5.1.3.1
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.2.2-1        //GrantRequest
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a GRANT request    grantRequest2
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   Grant
    

TC_MEC_MEC010p2_MEO_GRANT_003_OK
    [Documentation]   TP_MEC_MEC010p2_MEO_GRANT_003_OK
    ...  Check that MEO sends an asynchronous grant response when a grant request is requested
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.5.1.3.1
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.2.2-1 (GrantRequest)
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.2.2-1 Note 2 (GrantRequest)
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    ${GRANT_ID_VALUE}   Get value entry from JSON file    grantRequestAsynchronous  id
    Create a GRANT request    grantRequestAsynchronous
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location


TC_MEC_MEC010p2_MEO_GRANT_004_OK
    [Documentation]  TP_MEC_MEC010p2_MEO_GRANT_004_OK 
    ...  Check that MEO sends an asynchronous grant response when a grant request is requested
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.5.1.3.1
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.2.2-1 (GrantRequest)
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    ${GRANT_ID_VALUE}   Get value entry from JSON file    grantRequestAsynchronous2  id
    Create a GRANT request    grantRequestAsynchronous2
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
 

TC_MEC_MEC010p2_MEO_GRANT_005_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_GRANT_005_OK
    ...  Check that MEO sends the status of a grant request when a query on a granting ID is performed.
    ...  The process of creating the grant is ongoing, no grant is available yet 
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.5.2.3.2
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1  
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]      Test Setup   ${None}   grantRequestAsynchronous    ${REGISTER_ACTION}
    ${GRANT_ID_VALUE}   Get value entry from JSON file    grantRequestAsynchronous  id
    Get an individual grant    ${GRANT_ID_VALUE}
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   Grant

    
    
TC_MEC_MEC010p2_MEO_GRANT_006_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_GRANT_006_OK
    ...  Check that MEO sends the status of a grant request when a query on a granting ID is performed.
    ...  The process of creating the grant is ongoing, no grant is available yet 
    ...  ETSI GS MEC 010-2 3.2.1, clause 7.5.2.3.2
    ...  ETSI GS MEC 010-2 3.2.1, Table 6.2.4.4.2-1  
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]      Test Setup   ${None}   grantRequest    ${REGISTER_ACTION}
    Get an individual grant     ${setup_response['body']['id']}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   Grant

    

TC_MEC_MEC010p2_MEO_GRANT_006_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_GRANT_006_NF
    ...  Check that MEO responds with an error when it receives 
    ...  a request for returning a grant referred with a wrong ID
    ...  ETSI GS MEC 010-2 2.1.1, clause 7.5.2.3.2
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    ##No test setup can be applied because delete operation on grant is not supported (yet).
    Get an individual grant    ${NOT_EXISTING_GRANT_ID}
    Check HTTP Response Status Code Is    404
    
   

*** Keywords ***

Test Setup 
    [Arguments]    ${grantId}    ${content}   ${action}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
     
    IF    '''${action}''' == '''${REGISTER_ACTION}'''
       ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
       ${body}=    Get File    ${file}
       Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}    allow_redirects=false
       ${output}=    Output    response
       Set Suite Variable    ${setup_response}    ${output}
    END
    
Test Teardown  
    [Arguments]     ${grantId}    ${content}   ${action}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
     
    IF    '''${action}''' == '''${REGISTER_ACTION}'''
       ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
       ${body}=    Get File    ${file}
        Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}    allow_redirects=false
    END
   
   

Create a GRANT request
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get an individual grant
    [Arguments]    ${grantId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


    