*** Settings ***

Documentation
...    A test suite for validating UE Information Lookup (UEINFOLOOK) operations.

Resource    ../../../GenericKeywords.robot
Resource    ../../../pics.txt
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 

Default Tags    TC_MEC_SRV_UEINFOLOOK


*** Test Cases ***

TC_MEC_MEC013_SRV_UEINFLOOK_001_OK_01
    [Documentation]
    ...    Check that the IUT responds with the information pertaining to one or more UEs in a particular location
    ...    when queried by a MEC Application - No Filter
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.5
    ...        ETSI GS MEC 013 3.1.1 Clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of users
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserList

TC_MEC_MEC013_SRV_UEINFLOOK_001_OK_02
    [Documentation]
    ...    Check that the IUT responds with the information pertaining to one or more UEs in a particular location
    ...    when queried by a MEC Application - Filter with one address
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.5
    ...        ETSI GS MEC 013 3.1.1 Clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of users with filter      address     ${ACR_ADDRESS} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserList
    


TC_MEC_MEC013_SRV_UEINFLOOK_001_OK_03
    [Documentation]
    ...    Check that the IUT responds with the information pertaining to one or more UEs in a particular location
    ...    when queried by a MEC Application - Filter with several addresses
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.5
    ...        ETSI GS MEC 013 3.1.1 Clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of users with filter      address     ${ACR_ADDRESS},${ACR_ADDRESS2}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserList
    

TC_MEC_MEC013_SRV_UEINFLOOK_001_OK_04
    [Documentation]
    ...    Check that the IUT responds with the information pertaining to one or more UEs in a particular location
    ...    when queried by a MEC Application - Filter with several zoneIds
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.5
    ...        ETSI GS MEC 013 3.1.1 Clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of users with filter      zoneId     ${ZONE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UserList
    



TC_MEC_MEC013_SRV_UEINFLOOK_001_BR
    [Documentation]
    ...    Check that the IUT responds with the information pertaining to one or more UEs in a particular location
    ...    when queried by a MEC Application - Filter with several zoneIds
    ...    Reference    ETSI GS MEC 013 3.1.1 Clause 5.3.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.5
    ...        ETSI GS MEC 013 3.1.1 Clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of users with filter      addr     ${ACR_ADDRESS}
    Check HTTP Response Status Code Is    400

TC_MEC_MEC013_SRV_UEINFLOOK_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...   a request for an unknown URI is sent by a MEC Application
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.2
    ...        ETSI GS MEC 013 3.1.1 Clause 6.2.5
    ...        ETSI GS MEC 013 3.1.1 Clause 7.4.3.1
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get list of users with filter    address    ${ACR_UNKNOWN_IP}
    Check HTTP Response Status Code Is    404
    
*** Keywords ***
Get list of users
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/users
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get list of users with filter   
    [Arguments]     ${key}   ${values}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/users?${key}=${values}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
