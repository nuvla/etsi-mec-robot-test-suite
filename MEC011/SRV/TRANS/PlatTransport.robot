*** Settings ***

Documentation
...    A test suite for validating Transport (TRANS) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables_sandbox.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 

Default Tags    TC_MEC_SRV_TRANS


*** Test Cases ***
TC_MEC_MEC011_SRV_TRANS_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available transports
    ...    when queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 5.2.9,
    ...   ETSI GS MEC 011 clause 8.1.2.3,
    ...   ETSI GS MEC 011 clause 8.2.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of available transports
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    TransportInfoList

*** Keywords ***
Get list of available transports
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/transports
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}