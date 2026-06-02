''[Documentation]   robot --outputdir ./outputs ./AppInstanceMgmt.robot
...    Test Suite to validate App Instance Management operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEPM_SCHEMA}://${MEPM_HOST}:${MEPM_PORT}    ssl_verify=false
Library     BuiltIn
Library     Collections
Library     OperatingSystem
Library    String

Suite Setup       Suite Local Setup
Suite Teardown    Suite Local Teardown

*** Variables ***
${SCHEMA_BASE_DIR}    ${CURDIR}/schemas
${JSON_BASE_DIR}      ${CURDIR}/jsons


*** Test Cases ***
TC_MEC_MEC010p2_MEX_LCM_001_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_001_OK
    ...    Check that MEC API provider creates a new App Package when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.1.3.1
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.3.2-1      #CreateAppInstanceRequest
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.4.2-1      #AppInstanceInfo
    Create new App Instance  CreateAppInstanceRequest
    Check HTTP Response Status Code Is    201
    ##TODO validate against the new schema
    Check HTTP Response Body Json Schema Is   AppInstanceInfo
    Check HTTP Response Header Contains    Location
    Should Be Equal As Strings  ${response['body']['appDId']}      ${APPD_ID}
    Should Be Equal As Strings  ${response['body']['instantiationState']}       NOT_INSTANTIATED
    [TearDown]  Delete APP Instance   ${response['body']['id']}  

TC_MEC_MEC010p2_MEX_LCM_001_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_001_BR
    ...    Check that MEC API provider sends an error when it receives a malformed request for the creation of a new App Instance
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.1.3.1
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.3.2-1      #CreateAppInstanceRequest
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.4.2-1      #AppInstanceInfo
    Create new App Instance  CreateAppInstanceRequestBadRequest
    Check HTTP Response Status Code Is    400

    
TC_MEC_MEC010p2_MEX_LCM_002_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_002_OK
    ...    Check that MEC API provider retrieves the list of App instances when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.1.3.2
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.4.2-1  #AppInstanceInfo
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    GET all APP Instances  
    Check HTTP Response Status Code Is  200
    
    FOR    ${appInstance}    IN    @{response['body']}
        Validate Json By Schema File    ${appInstance}    ${SCHEMA_BASE_DIR}${/}AppInstanceInfo.schema.json
        ${passed}    Run Keyword And Return Status  Should Be Equal As Strings  ${appInstance}[id]    ${NEW_APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    [TearDown]  Delete APP Instance   ${NEW_APP_INSTANCE_ID}

    


TC_MEC_MEC010p2_MEX_LCM_003_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_003_OK
    ...    Check that MEC API provider retrieves an App Package when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.2.3.2
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.4.2-1  #AppInstanceInfo
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    GET APP Instance   ${NEW_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  200
    Check HTTP Response Body Json Schema Is   AppInstanceInfo
    Should Be Equal As Strings   ${response['body']['id']}    ${NEW_APP_INSTANCE_ID}
    [TearDown]  Delete APP Instance   ${NEW_APP_INSTANCE_ID}


TC_MEC_MEC010p2_MEX_LCM_003_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_003_NF
    ...    Check that MEC API provider fails on deletion of an App Instance when requested using wrong appInstanceId
    ...    ETSI GS MEC 010-2 3.2.1, Table 6.2.2.4.2-1  #AppInstanceInfo
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}
    GET APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  404
    
TC_MEC_MEC010p2_MEX_LCM_004_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_003_OK
    ...    Check that MEC API provider service deletes an App Instance when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.2.3.4
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    Delete APP Instance   ${NEW_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  204
    
TC_MEC_MEC010p2_MEX_LCM_004_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_004_NF
    ...    Check that MEC API provider fails on deletion of an App Instance when requested using wrong appInstanceId
    ...   ETSI GS MEC 010-2 3.2.1, clause 7.4.2.3.4
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}    
    Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  404
    

TC_MEC_MEC010p2_MEX_LCM_005_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_005_OK
    ...    Check that MEC API provider service instantiates an App Instance when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.6.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.7.2-1  #InstantiateAppRequest
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    Instantiate App Request  ${NEW_APP_INSTANCE_ID}  InstantiateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [TearDown]  Delete APP Instance   ${NEW_APP_INSTANCE_ID}  
    

TC_MEC_MEC010p2_MEX_LCM_005_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_005_BR
    ...    Check that MEC API provider service fails to instantiate an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.6.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.7.2-1  #InstantiateAppRequest
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}
    Instantiate App Request   ${NEW_APP_INSTANCE_ID}   InstantiateAppRequestBadRequest
    Check HTTP Response Status Code Is    400
    [TearDown]  Delete APP Instance   ${NEW_APP_INSTANCE_ID}
    


TC_MEC_MEC010p2_MEX_LCM_005_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_005_NF
    ...    Check that MEC API provider service fails to instantiate an App Instance when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.6.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.7.2-1  #InstantiateAppRequest
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}
    Instantiate App Request   ${NOT_EXISTING_APP_INSTANCE_ID}   InstantiateAppRequest
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC010p2_MEX_LCM_006_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_006_OK
    ...    Check that MEC API provider service terminates an App Instance when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.7.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.9.2-1  #TerminateAppRequest
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Wait For APP Instance Operational State   ${APP_ID}   STARTED
    Terminate App Request  ${APP_ID}  TerminateAppRequest    
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [TearDown]  Delete APP Instance   ${APP_ID}  


TC_MEC_MEC010p2_MEX_LCM_006_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_006_OK
    ...    Check that MEC API provider service fails to terminate an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.7.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.9.2-1  #TerminateAppRequest
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest
    Terminate App Request  ${APP_ID}  TerminateAppRequestBadRequest
    Check HTTP Response Status Code Is    400
    [TearDown]  Delete APP Instance   ${APP_ID}
 

TC_MEC_MEC010p2_MEX_LCM_006_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_006_NF
    ...    Check that MEC API provider service fails to terminate an App Instance when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.7.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.9.2-1  #TerminateAppRequest
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}
    Terminate App Request  ${NOT_EXISTING_APP_INSTANCE_ID}  TerminateAppRequest
    Check HTTP Response Status Code Is    404  


TC_MEC_MEC010p2_MEX_LCM_007_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_007_OK
    ...    Check that MEC API provider service changes the status of an App Instance from its INITIAL_STATE to a given FINAL_STATE, when requested.
    ...     The following combinations INITIAL_STATE - FINAL_STATE are supported: 
    ...     - STARTED/STOP
    ...     - STOPPED/STARTCheck that MEC API provider service terminates an App Instance when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.8.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.8.2-1 #OperateAppRequest    
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Wait For APP Instance Operational State   ${APP_ID}   STARTED
    Operate App Request  ${APP_ID}  OperateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [TearDown]  Delete APP Instance   ${APP_ID}  


TC_MEC_MEC010p2_MEX_LCM_007_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_007_BR
    ...    Check that MEC API provider service fails to operate on an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.8.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.8.2-1  #OperateAppRequest    
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest
    Operate App Request  ${APP_ID}  OperateAppRequestBadRequest
    Check HTTP Response Status Code Is    400
    [TearDown]  Delete APP Instance   ${APP_ID}
    
TC_MEC_MEC010p2_MEX_LCM_007_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_007_NF
    ...    Check that MEC API provider service fails to change the status of an App Instance when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.8.3.1
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.8.2-1  #OperateAppRequest    
    Operate App Request  ${NOT_EXISTING_APP_INSTANCE_ID}  OperateAppRequest
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC010p2_MEX_LCM_008_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_008_OK
    ...    Check that MEC API provider service retrieves info about LCM Operation Occurrence on App Instances when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.9.3.2
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.13.2-1  #AppLcmOpOcc 
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    GET all App LCM op Occs   
    Check HTTP Response Status Code Is  200
    
    FOR    ${appLcmOpOcc}    IN    @{response['body']}
        Validate Json By Schema File    ${appLcmOpOcc}    ${SCHEMA_BASE_DIR}${/}AppLcmOpOcc.schema.json
    END

TC_MEC_MEC010p2_MEX_LCM_009_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_009_OK
    ...    Check that MEC API provider service retrieves info about LCM Operation Occurrence on an App Instance when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.10.3.2
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.13.2-1  #AppLcmOpOcc 
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    GET App LCM op Occ  ${APP_LCM_OP_OCCS_ID} 
    Check HTTP Response Status Code Is  200
    Validate Json By Schema File    ${response}[body]    ${SCHEMA_BASE_DIR}${/}AppLcmOpOcc.schema.json
    Should Be Equal As Strings  ${response}[body][id]    ${APP_LCM_OP_OCCS_ID}
    

TC_MEC_MEC010p2_MEX_LCM_009_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_009_NF
    ...    Check that MEC API provider service sends an error when it receives a query for a not existing LCM Operation Occurence
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.10.3.2
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.13.2-1  #AppLcmOpOcc 
    GET App LCM op Occ  ${NOT_EXISTING_APP_LCM_OP_OCC_ID} 
    Check HTTP Response Status Code Is  404
 



TC_MEC_MEC010p2_MEX_LCM_010_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_010_OK
    ...    Check that MEC API provider service creates a LCM Subscription when requested, where the subscription request can 
    ...    have SUBSCRIPTION_TYPE AppInstanceStateChangeSubscription or AppLcmOpOccStateChangeSubscription
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.3.3.1,
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.12.2-1   #AppInstSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.14.2-1   #AppLcmOpOccSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.25.2-1   #AppInstIdCreationSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.28.2-1   #AppInstIdDeletionSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.10.2-1   #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.15.2-1   #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.26.2-1   #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.29.2-1   #AppInstIdDeletionSubscriptionInfo

    Send a request for a subscription  AppInstSubscriptionRequest
    Check HTTP Response Status Code Is  201
    Validate Json By Schema File    ${response}[body]    ${SCHEMA_BASE_DIR}${/}AppInstSubscriptionInfo.schema.json
    ${REQ_SUBSCRIPTION_TYPE}   Get value entry from JSON file    AppInstSubscriptionRequest  subscriptionType
    ${REQ_CALLBACK_URI}   Set Variable    ${CALLBACK_URI}
   
    Should Be Equal As Strings  ${response['body']['subscriptionType']}             ${REQ_SUBSCRIPTION_TYPE}
    Should Be Equal As Strings  ${response['body']['callbackUri']}      ${REQ_CALLBACK_URI}
    [TearDown]   Send a request for deleting a subscription  ${response['body']['id']}
    


TC_MEC_MEC010p2_MEX_LCM_010_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_010_BR
    ...    Check that MEC API provider service sends an error when it receives a malformed request to create a LCM Subscription
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.3.3.1,
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.12.2-1   #AppInstSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.14.2-1   #AppLcmOpOccSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.25.2-1   #AppInstIdCreationSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.28.2-1   #AppInstIdDeletionSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.10.2-1   #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.15.2-1   #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.26.2-1   #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.29.2-1   #AppInstIdDeletionSubscriptionInfo
  
    Send a request for a subscription  AppInstSubscriptionRequestBadRequest
    Check HTTP Response Status Code Is  400
    


TC_MEC_MEC010p2_MEX_LCM_011_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_011_OK
    ...    Check that MEC API provider service sends the list of LCM Subscriptions when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.3.3.2,
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.12.2-1   #AppInstSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.14.2-1   #AppLcmOpOccSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.25.2-1   #AppInstIdCreationSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.28.2-1   #AppInstIdDeletionSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.10.2-1   #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.15.2-1   #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.26.2-1   #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.29.2-1   #AppInstIdDeletionSubscriptionInfo
    [Setup]  Send a request for a subscription  AppInstSubscriptionRequest
    Set Test Variable   ${SUB_ID}   ${response['body']['id']}
  
    Send a request for retrieving all subscriptions
    Check HTTP Response Status Code Is  200
    Validate Json By Schema File    ${response}[body]    ${SCHEMA_BASE_DIR}${/}AppInstanceSubscriptionLinkList.schema.json
    Dictionary Should Contain Key    ${response['body']['_links']}    subscriptions
    FOR    ${subscriptionLink}    IN    @{response['body']['_links']['subscriptions']}
        Dictionary Should Contain Key    ${subscriptionLink}    href
        Dictionary Should Contain Key    ${subscriptionLink}    subscriptionType
    END
    [TearDown]   Send a request for deleting a subscription  ${SUB_ID}
    

TC_MEC_MEC010p2_MEX_LCM_012_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_012_OK
    ...    Check that MEC API provider service sends the information about an existing LCM subscription when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.4.3.2
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.10.2-1    #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.15.2-1    #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.26.2-1    #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.29.2-1    #AppInstIdDeletionSubscriptionInfo
    [Setup]  Send a request for a subscription  AppInstSubscriptionRequest
    Set Test Variable   ${SUB_ID}   ${response['body']['id']}
    Send a request for retrieving a subscription  ${SUB_ID}
    Check HTTP Response Status Code Is  200
    Should Be Equal As Strings  ${response['body']['id']}             ${SUB_ID}
    [TearDown]   Send a request for deleting a subscription  ${SUB_ID}


TC_MEC_MEC010p2_MEX_LCM_012_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_012_NF
    ...    Check that MEC API provider service sends an error when it receives a query for a not existing LCM Subscription
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.4.3.2
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.10.2-1    #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.15.2-1    #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.26.2-1    #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.29.2-1    #AppInstIdDeletionSubscriptionInfo
    [Setup]   Send a request for deleting a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    Send a request for retrieving a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is  404
    

TC_MEC_MEC010p2_MEX_LCM_013_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_013_OK
    ...    Check that MEC API provider service delete an existing LCM Subscription when requested
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.3.3.4
    [Setup]  Send a request for a subscription  AppInstSubscriptionRequest
    Set Test Variable   ${SUB_ID}   ${response['body']['id']}
    
    Send a request for deleting a subscription  ${SUB_ID}
    Check HTTP Response Status Code Is  204


TC_MEC_MEC010p2_MEX_LCM_013_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_013_NF
    ...    Check that MEC API provider service sends an error when it receives a deletion request for a not existing LCM Subscription
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.3.3.4
    [Setup]   Send a request for deleting a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    
    Send a request for deleting a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is  404
    

    
TC_MEC_MEC010p2_MEX_LCM_014_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_014_OK
    ...    Check that MEC API provider service cancels an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.11.3.1",
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.32.2-1"   #CancelMode
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Cancel on going LCM Operation  ${APP_LCM_OP_OCCS_ID}   CancelMode
    Check HTTP Response Status Code Is    202
    [TearDown]  Cleanup APP Instance   ${APP_ID}  

    

TC_MEC_MEC010p2_MEX_LCM_014_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_014_BR
    ...    Check that MEC API provider service fails to cancel an on going LCM Operation when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.11.3.1",
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.32.2-1"   #CancelMode
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Cancel on going LCM Operation  ${APP_LCM_OP_OCCS_ID}   CancelModeBadRequest
    Check HTTP Response Status Code Is    400
    [TearDown]  Cleanup APP Instance   ${APP_ID} 

    
TC_MEC_MEC010p2_MEX_LCM_014_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_014_NF
    ...    Check that MEC API provider service fails to cancel an on going LCM Operation when it receives a request related to a not existing application LCM Operation
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.11.3.1",
    ...    ETSI GS MEC 010-2 3.2.1, table 6.2.2.32.2-1"   #CancelMode
    Cancel on going LCM Operation  ${NOT_EXISTING_APP_LCM_OP_OCC_ID}   CancelMode
    Check HTTP Response Status Code Is    404



TC_MEC_MEC010p2_MEX_LCM_015_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_015_OK
    ...    Check that MEC API provider service makes failed an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.12.3.1
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Fail on going LCM Operation  ${APP_LCM_OP_OCCS_ID}
    Check HTTP Response Status Code Is    200
    Validate Json By Schema File    ${response}[body]    ${SCHEMA_BASE_DIR}${/}AppLcmOpOcc.schema.json
    [TearDown]  Cleanup APP Instance   ${APP_ID} 


TC_MEC_MEC010p2_MEX_LCM_015_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_015_NF
    ...    Check that MEC API provider service makes failed an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.12.3.1
    Fail on going LCM Operation  ${NOT_EXISTING_APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEX_LCM_016_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_016_OK
    ...    Check that MEC API provider service retries an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.13.3.1
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Retry on going LCM Operation  ${APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    202
    [TearDown]  Cleanup APP Instance   ${APP_ID} 


TC_MEC_MEC010p2_MEX_LCM_016_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_016_NF
    ...    Check that MEC API provider service fails to retry an LCM Operation when it receives a request related to a not existing application LCM Operation
    ...    ETSI GS MEC 010-2 3.2.1, clause 7.4.13.3.1
    Retry on going LCM Operation  ${NOT_EXISTING_APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    404



*** Keywords ***
Suite Local Setup
    Local Auth Setup
    Ensure Test App Package

Suite Local Teardown
    Sleep    15 sec
    Cleanup Test App Package

Local Auth Setup
    IF    '''${NUVLA_API_KEY}''' != '''''' and '''${NUVLA_API_SECRET}''' != ''''''
        Log    Creating local Nuvla session from API key
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"application/json"}
        ${body}=    Catenate    SEPARATOR=
        ...    {"template":{"href":"session-template/api-key","key":"${NUVLA_API_KEY}","secret":"${NUVLA_API_SECRET}"}}
        POST    /api/session    ${body}
        ${output}=    Output    response
        Set Suite Variable    ${auth_response}    ${output}
        Should Be Equal As Integers    ${auth_response['status']}    201
    END

Set Auth Header
    IF    '''${AUTH_HEADER_NAME}''' != '''''' and '''${AUTH_HEADER_VALUE}''' != ''''''
        Set Headers    {"${AUTH_HEADER_NAME}":"${AUTH_HEADER_VALUE}"}
    ELSE
        Set Headers    {"Authorization":"${TOKEN}"}
    END

Resource Id From Location
    [Arguments]    ${location}
    ${resource_id}=    Evaluate    '/'.join([part for part in '''${location}'''.split('/') if part][-2:])
    RETURN    ${resource_id}

Load JSON Fixture
    [Arguments]    ${content}
    ${path}    Catenate    SEPARATOR=      ${JSON_BASE_DIR}${/}     ${content}    .json
    ${body}    Get File    ${path}
    RETURN    ${body}

Prepare app instance request body
    [Arguments]    ${content}
    ${body}    Load JSON Fixture    ${content}
    ${body}    Evaluate
    ...    (lambda data: json.dumps(dict(data, appDId='${APPD_ID}')) if 'appDId' in data else json.dumps(data))(json.loads('''${body}'''))
    ...    json
    RETURN    ${body}

Prepare subscription request body
    [Arguments]    ${content}
    ${body}    Load JSON Fixture    ${content}
    IF    '''${CALLBACK_URI}''' != ''''''
        ${body}    Evaluate    json.dumps(dict(json.loads('''${body}'''), callbackUri='${CALLBACK_URI}'))    json
    END
    RETURN    ${body}

Ensure Test App Package
    IF    '''${TEST_APP_PKG_ID}''' == '''''' or '''${APPD_ID}''' == ''''''
        Log    Creating test app package for LCM suite
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"application/json"}
        Set Auth Header
        ${path}    Catenate    SEPARATOR=      ${CURDIR}${/}..${/}..${/}MEO${/}PKGM${/}jsons${/}     CreateAppPackage.json
        ${body}    Get File    ${path}
        Post    ${PKGM_API_ROOT}/${PKGM_API_NAME}/${PKGM_API_VERSION}/app_packages    ${body}    allow_redirects=false
        ${output}=    Output    response
        Should Be Equal As Integers    ${output['status']}    201
        Set Suite Variable    ${TEST_APP_PKG_ID}    ${output['body']['id']}
        Set Suite Variable    ${APPD_ID}    ${output['body']['appDId']}
    END

Cleanup Test App Package
    IF    '''${TEST_APP_PKG_ID}''' != ''''''
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"*/*"}
        Set Auth Header
        Delete    ${PKGM_API_ROOT}/${PKGM_API_NAME}/${PKGM_API_VERSION}/app_packages/${TEST_APP_PKG_ID}
        Set Suite Variable    ${TEST_APP_PKG_ID}    ${EMPTY}
        Set Suite Variable    ${APPD_ID}    ${EMPTY}
    END

Create new App Instance
    [Arguments]    ${content}
    Log    Creating a new app package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Auth Header
    ${body}=    Prepare app instance request body    ${content}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    IF    ${output['status']} == 201
        Set Suite Variable    ${APP_INSTANCE_ID}    ${output['body']['id']}
        Set Suite Variable    ${APP_ID}    ${output['body']['id']}
    END


GET all APP Instances 
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_instances?page=1&size=200
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    


GET APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

APP Instance Should Have Operational State
    [Arguments]    ${app_instance_id}    ${operational_state}
    GET APP Instance   ${app_instance_id}
    Check HTTP Response Status Code Is  200
    Should Be Equal As Strings   ${response['body']['instantiationState']}    INSTANTIATED
    Should Be Equal As Strings   ${response['body']['operationalState']}    ${operational_state}

Wait For APP Instance Operational State
    [Arguments]    ${app_instance_id}    ${operational_state}
    Wait Until Keyword Succeeds    90 sec    2 sec    APP Instance Should Have Operational State    ${app_instance_id}    ${operational_state}

APP Instance Should Be Not Instantiated
    [Arguments]    ${app_instance_id}
    GET APP Instance   ${app_instance_id}
    Check HTTP Response Status Code Is  200
    Should Be Equal As Strings   ${response['body']['instantiationState']}    NOT_INSTANTIATED

Wait For APP Instance To Be Not Instantiated
    [Arguments]    ${app_instance_id}
    Wait Until Keyword Succeeds    90 sec    2 sec    APP Instance Should Be Not Instantiated    ${app_instance_id}

Cleanup APP Instance
    [Arguments]    ${app_instance_id}
    GET APP Instance   ${app_instance_id}
    IF    ${response['status']} == 200 and '${response["body"]["instantiationState"]}' == 'INSTANTIATED'
        Terminate App Request   ${app_instance_id}   TerminateAppRequest
        IF    ${response['status']} == 202
            Wait For APP Instance To Be Not Instantiated   ${app_instance_id}
        END
    END
    Delete APP Instance   ${app_instance_id}


Delete APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Create and Instantiate App Instance
    [Arguments]    ${appInstanceFile}  ${instantiatePayloadFile}
    Create new App Instance  ${appInstanceFile} 
    Set Suite Variable   ${APP_ID}   ${response['body']['id']}
    Instantiate App Request  ${response['body']['id']}   ${instantiatePayloadFile}
    ${app_lcm_op_occ_id}=    Resource Id From Location    ${response['headers']['Location']}
    Set Suite Variable    ${APP_LCM_OP_OCCS_ID}     ${app_lcm_op_occ_id}
    Set Suite Variable    ${APP_LCM_OP_OCC_ID}      ${app_lcm_op_occ_id}
    
    

Instantiate App Request
    [Arguments]    ${appInstanceId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Auth Header
    ${body}=    Load JSON Fixture    ${content}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/instantiate   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    IF    '${output["status"]}' == '202'
        ${app_lcm_op_occ_id}=    Resource Id From Location    ${output['headers']['Location']}
        Set Suite Variable    ${APP_LCM_OP_OCCS_ID}     ${app_lcm_op_occ_id}
        Set Suite Variable    ${APP_LCM_OP_OCC_ID}      ${app_lcm_op_occ_id}
    END
    

Terminate App Request
    [Arguments]    ${appInstanceId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Auth Header
    ${body}=    Load JSON Fixture    ${content}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/terminate   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Operate App Request
    [Arguments]    ${appInstanceId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Auth Header
    ${body}=    Load JSON Fixture    ${content}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/operate   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    


GET all App LCM op Occs 
    Log    Get all App LCM Operation occurrences
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    



GET App LCM op Occ
    [Arguments]    ${appLcmOpOccsId}
    Log    Get App LCM Operation occurrence
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOpOccsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    


Send a request for a subscription    
    [Arguments]    ${content}
    Log    Creating a new subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Auth Header
    ${body}=    Prepare subscription request body    ${content}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    IF    ${output['status']} == 201
        Set Suite Variable    ${SUBSCRIPTION_ID}    ${output['body']['id']}
    END
    



Send a request for retrieving all subscriptions    
    Log    Get all subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Send a request for retrieving a subscription
    [Arguments]    ${subscriptionId}    
    Log    Get all subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Send a request for deleting a subscription
    [Arguments]    ${subscriptionId}    
    Log    Get all subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Cancel on going LCM Operation 
    [Arguments]    ${appLcmOccOpId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Auth Header
    ${body}=    Load JSON Fixture    ${content}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOccOpId}/cancel   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    



Fail on going LCM Operation 
    [Arguments]    ${appLcmOccOpId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOccOpId}/fail
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Retry on going LCM Operation 
    [Arguments]    ${appLcmOccOpId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Auth Header
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOccOpId}/retry
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
