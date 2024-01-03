''[Documentation]   robot --outputdir ../../outputs ./RnisSpecificSubscription_BV.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Library    OperatingSystem
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library     String


*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_013_NF
    [Documentation]    Get an Individual RNIS subscription
    ...    Check that the RNIS service responds with error when a not existing 
    ...    RNIS subscription is requested
    ...    ETSI GS MEC 012 2.2.1, clause 7.8.3.1
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Delete Individual RNIS Subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Get Individual RNIS Subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404



TC_MEC_MEC012_SRV_RNIS_014_BR
    [Documentation]    Update an Individual RNIS subscription
    ...    Check that the RNIS service sends an error when it receives a malformed modify
    ...    request for a RNIS subscription
    ...    ETSI GS MEC 012 2.2.1, clause 7.8.3.2
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Post RNIS subscription request    CellChangeSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[4]} 
    Update Individual RNIS Subscription  ${SUB_ID}    UpdateCellChangeSubscriptionRequestBr
    Check HTTP Response Status Code Is    400
    [TearDown]  Delete Individual RNIS Subscription    ${SUB_ID}


TC_MEC_MEC012_SRV_RNIS_014_NF
    [Documentation]    Update an Individual RNIS subscription
    ...    Check that the RNIS service responds with error when a modification for a not existing RNIS subscription is requested
    ...    ETSI GS MEC 012 2.2.1, clause 7.8.3.2
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Delete Individual RNIS Subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Update Individual RNIS Subscription  ${NON_EXISTENT_SUBSCRIPTION_ID}    UpdateCellChangeSubscriptionRequest
    Check HTTP Response Status Code Is    404
    
TC_MEC_MEC012_SRV_RNIS_015_NF
    [Documentation]    Update an Individual RNIS subscription
    ...   Check that the RNIS service responds with error when the deletion of a not existing RNIS subscription is requested
    ...    ETSI GS MEC 012 2.2.1, clause 7.8.3.5
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Delete Individual RNIS Subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Delete Individual RNIS Subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC012_SRV_RNIS_013_OK
    [Documentation]    Get an Individual RNIS subscription
    ...    Check that the RNIS service sends a RNIS subscription when requested
    ...    ETSI GS MEC 012 2.2.1, clause 7.8.3.1
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Post RNIS subscription request    CellChangeSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[4]} 
    Get Individual RNIS Subscription    ${SUB_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   CellChangeSubscription
    ${sub_type}    Get value entry from JSON file    CellChangeSubscription    subscriptionType
    ${callbackReference}    Get value entry from JSON file    CellChangeSubscription    callbackReference
    Should be Equal   ${response['body']['subscriptionType']}     ${sub_type}
    Should be Equal   ${response['body']['callbackReference']}    ${callbackReference}
    [TearDown]  Delete Individual RNIS Subscription    ${SUB_ID}

TC_MEC_MEC012_SRV_RNIS_014_OK
    [Documentation]    Update an Individual RNIS subscription
    ...    Check that the RNIS service modifies a RNIS subscription when requested
    ...    ETSI GS MEC 012 2.2.1, clause 7.8.3.2
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Post RNIS subscription request    CellChangeSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[4]} 
    Update Individual RNIS Subscription  ${SUB_ID}    UpdateCellChangeSubscriptionRequest
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   CellChangeSubscription
    ${sub_type}    Get value entry from JSON file    UpdateCellChangeSubscriptionRequest    subscriptionType
    ${callbackReference}    Get value entry from JSON file    UpdateCellChangeSubscriptionRequest    callbackReference
    Should be Equal   ${response['body']['subscriptionType']}     ${sub_type}
    Should be Equal   ${response['body']['callbackReference']}    ${callbackReference}
    [TearDown]  Delete Individual RNIS Subscription    ${SUB_ID}
     
TC_MEC_MEC012_SRV_RNIS_015_OK
    [Documentation]    Remove an Individual RNIS subscription
    ...    Check that the RNIS service deletes a RNIS subscription when requested
    ...    ETSI GS MEC 012 2.1.1, clause 7.8.3.5
    ...    Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    [Setup]   Post RNIS subscription request    CellChangeSubscription
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[4]} 
    Delete Individual RNIS Subscription    ${SUB_ID}
    Check HTTP Response Status Code Is    204

*** Keywords ***
Get RNIS subscription list
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions?subscription_type=${SUBSCRIPTION_HREF_VALUE}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Post RNIS subscription request
    [Arguments]    ${content}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${json_file} =    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${json_file}
    ${body}=    Replace String    ${body}    \${HREF}    ${HREF}
    ${body}=    Replace String    ${body}    \${LINKS_SELF}    ${LINKS_SELF}
    Post    ${apiRoot}/rni/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get Individual RNIS Subscription
    [Arguments]    ${subscription_id}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update Individual RNIS Subscription
    [Arguments]    ${subscription_id}   ${content}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${json_file} =    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${json_file}
    #${body}=    Replace String    ${body}    \${HREF}    ${HREF}
    #${body}=    Replace String    ${body}    \${LINKS_SELF}    ${LINKS_SELF}
    Put    ${apiRoot}/rni/${apiVersion}/subscriptions/${subscription_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Delete Individual RNIS Subscription
    [Arguments]    ${subscription_id}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/rni/${apiVersion}/subscriptions/${SUBSCRIPTION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}