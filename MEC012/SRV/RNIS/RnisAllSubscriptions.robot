''[Documentation]   robot --outputdir ../../outputs ./RnisSpecificSubscription_BI_BO.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Resource    environment/variables_sandbox.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
#Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library     String


*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_011_BR
    [Documentation]   Request RNIS subscription list using bad parameters
    ...  Check that the RNIS service responds with an error when it receives a request to 
    ...  get all RNIS subscriptions with a wrong subscription type
    ...  ETSI GS MEC 012 2.2.1, clause 7.6.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml#/definitions/SubscriptionLinkList
    [Setup]   Send a request for a subscription and get sub ID     CellChangeSubscription
    Get RNIS subscription list with wrong parameter
    Check HTTP Response Status Code Is    400
    [TearDown]    Delete subscription   ${SUB_ID} 
    

TC_MEC_MEC012_SRV_RNIS_012_BR
    [Documentation]   Create RNIS subscription using bad parameters
    ...  Check that the RNIS service responds with an error when it receives a request to create a new RNIS subscription with a wrong format
    ...  ETSI GS MEC 012 2.2.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Send a request for a subscription     CellChangeSubscriptionBr
    Check HTTP Response Status Code Is    400

TC_MEC_MEC012_SRV_RNIS_011_OK
    [Documentation]   Request RNIS subscription list
    ...  Check that the RNIS service sends the list of links to the relevant RNIS subscriptions when requested
    ...  ETSI GS MEC 012 2.2.1, clause 7.6.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml#/definitions/SubscriptionLinkList
    [Setup]   Send a request for a subscription and get sub ID     CellChangeSubscription
    Get RNIS subscription list with filter   CellChangeSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    ${not_expected_syb_type}   Set Variable   ${FALSE}
    FOR    ${subscription}    IN    @{response['body']['_links']['subscription']}
    IF    '''${subscription}[subscriptionType]''' != '''CellChangeSubscription'''
        ${not_expected_syb_type}    Set Variable   ${TRUE}
      END
    END 
    Should Be Equal   ${not_expected_syb_type}      ${FALSE}
    [TearDown]    Delete subscription   ${SUB_ID} 

TC_MEC_MEC012_SRV_RNIS_012_OK
    [Documentation]   Create RNIS subscription
    ...  Check that the RNIS service creates a new RNIS subscription
    ...  ETSI GS MEC 012 2.2.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Send a request for a subscription and get sub ID     CellChangeSubscription
    ${sub_type}   Get value entry from JSON file    CellChangeSubscription    subscriptionType
    ${callback_ref}   Get value entry from JSON file    CellChangeSubscription    callbackReference
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   CellChangeSubscription
    Should Be Equal   ${response['body']['subscriptionType']}      ${sub_type}
    Should Be Equal   ${response['body']['callbackReference']}      ${callback_ref}
    [TearDown]    Delete subscription   ${SUB_ID} 

*** Keywords ***
Get RNIS subscription list with filter
    [Arguments]    ${sub_type_filter}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions?subscription_type=${sub_type_filter}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get RNIS subscription list with wrong parameter
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/rni/${apiVersion}/subscriptions?subscription_type=wrongSubscriptionType
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send a request for a subscription and get sub ID
    [Arguments]    ${content}
    Send a request for a subscription      ${content}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${SUB_ID}    ${elements[-1]} 


Send a request for a subscription    
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Log     ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Delete subscription
    [Arguments]    ${subscription_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscription_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

