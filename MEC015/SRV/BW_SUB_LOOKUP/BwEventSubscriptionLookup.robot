''[Documentation]   robot --outputdir ../../../outputs ./BwEventSubscription.robot
...    Test Suite to validate Bandwidth Management Event Subscription (BW) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     Collections
Library     String
Library     OperatingSystem
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false

*** Test Cases ***
TC_MEC_MEC015_SRV_BWSUBLOOKUP_001_OK
    [Documentation] 
    ...  Check that the IUT responds with a list of BWM change event susbsciption when queried by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 7.3.3
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.1

    [Setup]  Create New Subscription Info    BwChgEventSubscription
    Set Suite Variable    ${Location}    ${response['headers']['Location']}  
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the list of subscription information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList

    [TearDown]  Remove Subscription Info    ${Location}

TC_MEC_MEC015_SRV_BWSUBLOOKUP_001_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 7.3.3
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.1

    [Setup]  Create New Subscription Info    BwChgEventSubscription
    Set Suite Variable    ${Location}    ${response['headers']['Location']} 
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Get list of subscriptions using query parameters    ${INVALID_SUB_FILTER}
    Check HTTP Response Status Code Is    400

    [TearDown]  Remove Subscription Info    ${Location}

TC_MEC_MEC015_SRV_BWSUBLOOKUP_001_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when no subscription are created
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 7.3.3
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.1
    
    Retrieve the list of subscription information
    Check HTTP Response Status Code Is    404

TC_MEC_MEC015_SRV_BWSUBLOOKUP_002_OK
    [Documentation] 
    ...  Check that the IUT responds with a list of subscriptions for notifications on services availability when queried by a MEC Application - Filter on subscription_type
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.3
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.1

    [Setup]  Create New Subscription Info    BwChgEventSubscription
    Set Suite Variable    ${Location}    ${response['headers']['Location']} 
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Get list of subscriptions using query parameters    ${SUB_FILTER}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList

    [TearDown]  Remove Subscription Info    ${Location}

TC_MEC_MEC015_SRV_BWSUBLOOKUP_002_NF
    [Documentation] 
    ...  Check that the IUT responds with with an error when no subscription matches with the filter - Filter on subscription_type
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.3
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.1

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Get list of subscriptions using query parameters    ${SUB_FILTER}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC015_SRV_BWSUBLOOKUP_003_OK
    [Documentation] 
    ...  Check that the IUT responds with a BWM change event susbsciption when queried by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.6.3.1
    
    [Setup]  Create New Subscription Info    BwChgEventSubscription

    Set Suite Variable    ${Location}    ${response['body']['_links']['self']['href']}  
    ${elements} =  Split String    ${Location}    /
    ${SUBSCRIPTION_ID} =  Get From List    ${elements}    -1
    Set Suite Variable    ${SUBSCRIPTION_ID}    ${SUBSCRIPTION_ID}

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Retrieve existing subscription information  ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwChgEventSubscription

    ${subscription_type}    Get value entry from JSON file    BwChgEventSubscription  subscriptionType
    ${callbackReference}    Get value entry from JSON file    BwChgEventSubscription    callbackReference
    ${filterCriteria}    Get value entry from JSON file    BwChgEventSubscription    filterCriteria

    Should Be Equal As Strings    ${response['body']['subscriptionType']}    ${subscription_type}
    Should Be Equal As Strings    ${response['body']['callbackReference']}    ${callbackReference}
    Should Be Equal As Strings    ${response['body']['filterCriteria']['appInsId']}    ${filterCriteria['appInsId']}

    [TearDown]  Remove Subscription Info    ${Location}  

TC_MEC_MEC015_SRV_BWSUBLOOKUP_003_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.6.3.1

    Retrieve existing subscription information  ${SUB_ID}
    Check HTTP Response Status Code Is    404


*** Keywords ***
Retrieve the list of subscription information
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Retrieve existing subscription information
    [Arguments]    ${SUB_ID}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get list of subscriptions using query parameters
    [Arguments]    ${subscription_type}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions?subscription_type=${subscription_type}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Create New Subscription Info
    [Arguments]     ${content}   
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}

    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    
    POST   ${apiRoot}/${apiName}/${apiVersion}/subscriptions   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Remove Subscription Info 
    [Arguments]     ${delete_url}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    
    DELETE    ${delete_url}