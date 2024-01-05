*** Settings ***

Documentation
...    A test suite for validating Radio Node Location Lookup (RLOCLOOK) operations.

Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 

Default Tags    TC_MEC_SRV_RLOCLOOK


*** Test Cases ***


TC_MEC_MEC013_SRV_RLOCLOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with the list of radio nodes currently associated with the MEC host and the location of each radio node
    ...    when queried by a MEC Application
    ...
    ...    Reference
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.2.1
    ...    ETSI GS MEC 013 3.1.1 Clause 7.9.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES    
    Get the access points list by zone identifier    ${ZONE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AccessPointList
    Should Be Equal As Strings    ${response['body']['zoneId']}    ${ZONE_ID}



TC_MEC_MEC013_SRV_RLOCLOOK_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an URI that cannot be mapped to a valid resource URI
    ...    is sent by a MEC Application
    ...
    ...    Reference
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.2.1
    ...    ETSI GS MEC 013 3.1.1 Clause 7.9.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get the access points list by zone identifier       ${NON_EXISTENT_ZONE_ID}
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC013_SRV_RLOCLOOK_002_OK
    [Documentation]
    ...    Check that the IUT responds with the radio nodes when queried 
    ...    by a MEC Application
    ...
    ...    Reference
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.2.1
    ...    ETSI GS MEC 013 3.1.1 Clause 7.10.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES    
    Get the access points list by zone identifier and access point  ${ZONE_ID}    ${AP_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AccessPointList
    Should Be Equal As Strings    ${response['body']['zoneId']}    ${ZONE_ID}
    Should Be Equal As Strings    ${response['body']['accessPoint'][0]['accessPointId']}    ${AP_ID}


TC_MEC_MEC013_SRV_RLOCLOOK_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when the 
    ...    radio nodes does not exist
    ...
    ...    Reference
    ...    ETSI GS MEC 013 3.1.1 Clause 5.3.7
    ...    ETSI GS MEC 013 3.1.1 Clause 6.2.1
    ...    ETSI GS MEC 013 3.1.1 Clause 7.10.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES    
    Get the access points list by zone identifier and access point  ${ZONE_ID}    ${NON_EXISTENT_AP_ID}
    Check HTTP Response Status Code Is    404


*** Keywords ***
Get the access points list by zone identifier
    [Arguments]    ${zoneId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/zones/${zoneId}/accessPoints
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get the access points list by zone identifier and access point
    [Arguments]    ${zoneId}    ${accessPointId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/zones/${zoneId}/accessPoints/${accessPointId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


