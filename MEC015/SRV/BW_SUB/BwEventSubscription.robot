''[Documentation]   robot --outputdir ../../../outputs ./BwEventSubscription.robot
...    Test Suite to validate Bandwidth Management Event Subscription (BW) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     Collections
Library     String
Library     OperatingSystem
Library     MockServerLibrary
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false

*** Test Cases ***
TC_MEC_MEC015_SRV_BW_SUB_NOT_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the creation of BWM change event subscription request when commanded by a MEC Application
    ...    Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.2
    ...                 ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...                 ETSI GS MEC 015 3.1.1, clause 8.5.3.4

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Create New Subscription Info    BwChgEventSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   BwChgEventSubscription
    Set Suite Variable    ${Location}    ${response['headers']['Location']}
    
    Check Response Contains    ${response['body']}    subscriptionType    ${SUB_TYPE}
    Check Response Contains    ${response['body']}    callbackReference    ${CALLBACK_URI}
    Check Response Contains    ${response['body']['filterCriteria']}    appInsId    ${appInsId}
    Should Not Be Empty  ${response['body']['_links']['self']['href']}

    [TearDown]  Remove Subscription Info    ${Location}

TC_MEC_MEC015_SRV_BW_SUB_NOT_001_BR_01
    [Documentation] 
    ...  Check that the IUT acknowledges the creation of BWM change event subscription request when commanded by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.1
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.4    

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Create New Subscription Info with Invalid subscriptionType    BwChgEventSubscription
    Check HTTP Response Status Code Is    400

TC_MEC_MEC015_SRV_BW_SUB_NOT_001_BR_02
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application - Both callbackReference and websockNotifConfig provided
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.1
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.4

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Create New Subscription Info    BwChgEventSubscription_BR
    Check HTTP Response Status Code Is    400

TC_MEC_MEC015_SRV_BW_SUB_NOT_001_BR_03
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application - Neither callbackReference nor websockNotifConfig provided
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.1
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.5.3.4   

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Create New Subscription Info   BwChgEventSubscription_BR_02
    Check HTTP Response Status Code Is    400


TC_MEC_MEC015_SRV_BW_SUB_NOT_002_OK
    [Documentation] 
    ...  Check that the IUT acknowledges the update of BWM change event subscription request when commanded by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.3
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.6.3.2   
    
    [Setup]  Create New Subscription Info    BwChgEventSubscription
    Set Suite Variable    ${Location}    ${response['headers']['Location']}
    ${elements} =  Split String    ${Location}    /
    ${SUBSCRIPTION_ID} =  Get From List    ${elements}    -1
    Set Suite Variable    ${SUBSCRIPTION_ID}    ${SUBSCRIPTION_ID}

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Modify existing subscription information    ${SUBSCRIPTION_ID}    UpdateBwChgEventSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   UpdateBwChgEventSubscription

    ${callbackReference}    Get value entry from JSON file    UpdateBwChgEventSubscription    callbackReference
    ${filterCriteria}    Get value entry from JSON file    UpdateBwChgEventSubscription    filterCriteria

    Check Response Contains    ${response['body']}    subscriptionType    BwChgEventSubscription
    Check Response Contains    ${response['body']}    callbackReference    ${callbackReference}
    Check Response Contains    ${response['body']['filterCriteria']}    appInsId    ${filterCriteria['appInsId']}
    Should Not Be Empty  ${response['body']['_links']['self']['href']}

    [TearDown]  Remove Subscription Info    ${Location}

TC_MEC_MEC015_SRV_BW_SUB_NOT_002_NF
    [Documentation] 
    ...  Check that the IUT acknowledges an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.3
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.6.3.2   

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Modify existing subscription information    ${NON_EXISTENT_SUB_ID}    UpdateBwChgEventSubscription
    Check HTTP Response Status Code Is    404

TC_MEC_MEC015_SRV_BW_SUB_NOT_003_OK
    [Documentation] 
    ...  Check that the IUT acknowledges the cancellation of BWM change event subscription request when commanded by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.4
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.6.3.5   
    
    [Setup]  Create New Subscription Info    ${SUB_ID}
    Set Suite Variable    ${Location}    ${response['headers']['Location']}
    ${elements} =  Split String    ${Location}    /
    ${SUBSCRIPTION_ID} =  Get From List    ${elements}    -1
    Set Suite Variable    ${SUBSCRIPTION_ID}    ${SUBSCRIPTION_ID}

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Remove existing subscription information  ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204  

TC_MEC_MEC015_SRV_BW_SUB_NOT_003_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.4
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.6.3.5

    Remove existing subscription information  ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404

TP_MEC_MEC015_SRV_BW_SUB_NOT_004_OK
    [Documentation]   Post Bandwidth Change Event Notification
    ...  Check that the BWM service sends a notification about a bandwidth utility or the data volume 
    ...    if the BWM service has an associated subscription and the event is generated"
    ...  Reference    ETSI GS MEC 015 3.1.1, clause 6.2.6.2
    ...               ETSI GS MEC 015 3.1.1, clause 7.3.2
    ...               ETSI GS MEC 015 3.1.1, clause 8.7.3.4

    ${json}=	Get File	schemas/BwChgEventNotification.schema.json
    # Log  Creating mock request and response to handle Bandwidth Change Event Notification
    # &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    # &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    # Create Mock Expectation  ${req}  ${rsp}
    # Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    # Log  Verifying results
    # Verify Mock Expectation  ${req}
    # Log  Cleaning the endpoint
    # Clear Requests  ${callback_endpoint}

*** Keywords ***
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

Modify existing subscription information
    [Arguments]    ${SUB_ID}    ${content}   
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}

    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    ${json_data}=    Evaluate    json.loads('''${body}''')    json
    ${new_href}=    Set Variable    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}/${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}
    Set To Dictionary    ${json_data["_links"]["self"]}    href=${new_href}
    ${modified_json_string}=    Evaluate    json.dumps(${json_data})
    
    Put   ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}   ${modified_json_string}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Create New Subscription Info with Invalid subscriptionType
    [Arguments]     ${content}   
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}

    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}

    # Modify JSON: Change subscriptionType to an invalid value
    ${body}=    Evaluate    json.loads('''${body}''')    json
    Set To Dictionary    ${body}    subscriptionType    InvalidType
    ${modified_json_string}=    Evaluate    json.dumps(${body})
    
    POST   ${apiRoot}/${apiName}/${apiVersion}/subscriptions   ${modified_json_string}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Remove existing subscription information
    [Arguments]    ${SUB_ID}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE     ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${SUB_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Remove Subscription Info 
    [Arguments]     ${delete_url}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}

    DELETE    ${delete_url}