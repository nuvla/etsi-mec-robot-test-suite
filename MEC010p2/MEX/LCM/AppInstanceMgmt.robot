''[Documentation]   robot --outputdir ./outputs ./AppInstanceMgmt.robot
...    Test Suite to validate App Instance Management operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEPM_SCHEMA}://${MEPM_HOST}:${MEPM_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library    String


*** Test Cases ***
TC_MEC_MEC010p2_MEX_LCM_001_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_001_OK
    ...    Check that MEC API provider creates a new App Package when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.1.3.1
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.3.2-1      #CreateAppInstanceRequest
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.4.2-1      #AppInstanceInfo
    Create new App Instance  CreateAppInstanceRequest
    ${APPD_ID_SET}   Get value entry from JSON file    CreateAppInstanceRequest  appDId
    Check HTTP Response Status Code Is    201
    ##TODO validate against the new schema
    Check HTTP Response Body Json Schema Is   AppInstanceInfo
    Check HTTP Response Header Contains    Location
    Should Be Equal As Strings  ${response['body']['appDId']}      ${APPD_ID_SET}
    Should Be Equal As Strings  ${response['body']['instantiationState']}       NOT_INSTANTIATED
    [TearDown]  Delete APP Instance   ${response['body']['id']}  

TC_MEC_MEC010p2_MEX_LCM_001_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_001_BR
    ...    Check that MEC API provider sends an error when it receives a malformed request for the creation of a new App Instance
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.1.3.1
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.3.2-1      #CreateAppInstanceRequest
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.4.2-1      #AppInstanceInfo
    Create new App Instance  CreateAppInstanceRequestBadRequest
    Check HTTP Response Status Code Is    400

    
TC_MEC_MEC010p2_MEX_LCM_002_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_002_OK
    ...    Check that MEC API provider retrieves the list of App instances when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.1.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.4.2-1  #AppInstanceInfo
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    GET all APP Instances  
    Check HTTP Response Status Code Is  200
    
    FOR    ${appInstance}    IN    @{response['body']}
        Validate Json    AppInstanceInfo.schema.json    ${appInstance}
        ${passed}    Run Keyword And Return Status  Should Be Equal As Strings  ${appInstance}[id]    ${NEW_APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    [TearDown]  Delete APP Instance   ${NEW_APP_INSTANCE_ID}

    


TC_MEC_MEC010p2_MEX_LCM_003_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_003_OK
    ...    Check that MEC API provider retrieves an App Package when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.2.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.4.2-1  #AppInstanceInfo
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
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.2.4.2-1  #AppInstanceInfo
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}
    GET APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  404
    
TC_MEC_MEC010p2_MEX_LCM_004_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_003_OK
    ...    Check that MEC API provider service deletes an App Instance when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.2.3.4
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    Delete APP Instance   ${NEW_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  204
    
TC_MEC_MEC010p2_MEX_LCM_004_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_004_NF
    ...    Check that MEC API provider fails on deletion of an App Instance when requested using wrong appInstanceId
    ...   ETSI GS MEC 010-2 3.1.1, clause 7.4.2.3.4
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}    
    Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is  404
    

TC_MEC_MEC010p2_MEX_LCM_005_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_005_OK
    ...    Check that MEC API provider service instantiates an App Instance when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.6.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.7.2-1  #InstantiateAppRequest
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Set Test Variable  ${NEW_APP_INSTANCE_ID}    ${response['body']['id']}  
    Instantiate App Request  ${NEW_APP_INSTANCE_ID}  InstantiateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [TearDown]  Delete APP Instance   ${NEW_APP_INSTANCE_ID}  
    

TC_MEC_MEC010p2_MEX_LCM_005_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_005_BR
    ...    Check that MEC API provider service fails to instantiate an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.6.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.7.2-1  #InstantiateAppRequest
    Instantiate App Request   ${APP_INSTANCE_ID}   InstantiateAppRequestBadRequest
    Check HTTP Response Status Code Is    400
    


TC_MEC_MEC010p2_MEX_LCM_005_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_005_NF
    ...    Check that MEC API provider service fails to instantiate an App Instance when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.6.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.7.2-1  #InstantiateAppRequest
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}
    Instantiate App Request   ${NOT_EXISTING_APP_INSTANCE_ID}   InstantiateAppRequest
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC010p2_MEX_LCM_006_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_006_OK
    ...    Check that MEC API provider service terminates an App Instance when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.7.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.9.2-1  #TerminateAppRequest
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Sleep  5   ##Change it according to your need
    Terminate App Request  ${APP_ID}  TerminateAppRequest    
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [TearDown]  Delete APP Instance   ${APP_ID}  


TC_MEC_MEC010p2_MEX_LCM_006_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_006_OK
    ...    Check that MEC API provider service fails to terminate an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.7.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.9.2-1  #TerminateAppRequest
    Terminate App Request  ${APP_INSTANCE_ID}  TerminateAppRequestBadRequest
    Check HTTP Response Status Code Is    400
 

TC_MEC_MEC010p2_MEX_LCM_006_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_006_NF
    ...    Check that MEC API provider service fails to terminate an App Instance when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.7.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.9.2-1  #TerminateAppRequest
    [Setup]  Delete APP Instance   ${NOT_EXISTING_APP_INSTANCE_ID}
    Terminate App Request  ${NOT_EXISTING_APP_INSTANCE_ID}  TerminateAppRequest
    Check HTTP Response Status Code Is    404  


TC_MEC_MEC010p2_MEX_LCM_007_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_007_OK
    ...    Check that MEC API provider service changes the status of an App Instance from its INITIAL_STATE to a given FINAL_STATE, when requested.
    ...     The following combinations INITIAL_STATE - FINAL_STATE are supported: 
    ...     - STARTED/STOP
    ...     - STOPPED/STARTCheck that MEC API provider service terminates an App Instance when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.8.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.8.2-1 #OperateAppRequest    
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    ##TODO sleep for a while because the instantiation is not immediate
    Operate App Request  ${APP_INSTANCE_ID}  OperateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    [TearDown]  Delete APP Instance   ${APP_ID}  


TC_MEC_MEC010p2_MEX_LCM_007_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_007_BR
    ...    Check that MEC API provider service fails to operate on an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.8.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.8.2-1  #OperateAppRequest    
    Operate App Request  ${APP_INSTANCE_ID}  OperateAppRequestBadRequest
    Check HTTP Response Status Code Is    400
    
TC_MEC_MEC010p2_MEX_LCM_007_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_007_NF
    ...    Check that MEC API provider service fails to change the status of an App Instance when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.8.3.1
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.8.2-1  #OperateAppRequest    
    Operate App Request  ${NOT_EXISTING_APP_INSTANCE_ID}  OperateAppRequest
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC010p2_MEX_LCM_008_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_008_OK
    ...    Check that MEC API provider service retrieves info about LCM Operation Occurrence on App Instances when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.9.3.2
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.13.2-1  #AppLcmOpOcc 
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    GET all App LCM op Occs   
    Check HTTP Response Status Code Is  200
    
    FOR    ${appLcmOpOcc}    IN    @{response['body']}
        Validate Json    AppLcmOpOcc.schema.json    ${appLcmOpOcc}
    END

TC_MEC_MEC010p2_MEX_LCM_009_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_009_OK
    ...    Check that MEC API provider service retrieves info about LCM Operation Occurrence on an App Instance when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.10.3.2
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.13.2-1  #AppLcmOpOcc 
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    GET App LCM op Occ  ${APP_LCM_OP_OCCS_ID} 
    Check HTTP Response Status Code Is  200
    Validate Json    AppLcmOpOcc.schema.json    ${response}[body]
    Should Be Equal As Strings  ${response}[body][id]    ${APP_LCM_OP_OCCS_ID}
    

TC_MEC_MEC010p2_MEX_LCM_009_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_009_NF
    ...    Check that MEC API provider service sends an error when it receives a query for a not existing LCM Operation Occurence
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.10.3.2
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.13.2-1  #AppLcmOpOcc 
    GET App LCM op Occ  ${NOT_EXISTING_APP_LCM_OP_OCC_ID} 
    Check HTTP Response Status Code Is  404
 



TC_MEC_MEC010p2_MEX_LCM_010_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_010_OK
    ...    Check that MEC API provider service creates a LCM Subscription when requested, where the subscription request can 
    ...    have SUBSCRIPTION_TYPE AppInstanceStateChangeSubscription or AppLcmOpOccStateChangeSubscription
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.3.3.1,
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.12.2-1   #AppInstSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.14.2-1   #AppLcmOpOccSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.25.2-1   #AppInstIdCreationSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.28.2-1   #AppInstIdDeletionSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.10.2-1   #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.15.2-1   #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.26.2-1   #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.29.2-1   #AppInstIdDeletionSubscriptionInfo

    Send a request for a subscription  AppInstSubscriptionRequest
    Check HTTP Response Status Code Is  201
    Validate Json    AppInstSubscriptionRequest.schema.json    ${response}[body]
    ${REQ_SUBSCRIPTION_TYPE}   Get value entry from JSON file    AppInstSubscriptionRequest  subscriptionType
    ${REQ_CALLBACK_URI}   Get value entry from JSON file    AppInstSubscriptionRequest  callbackUri
   
    Should Be Equal As Strings  ${response['body']['subscriptionType']}             ${REQ_SUBSCRIPTION_TYPE}
    Should Be Equal As Strings  ${response['body']['callbackUri']}      ${REQ_CALLBACK_URI}
    [TearDown]   Send a request for deleting a subscription  ${response['body']['id']}
    


TC_MEC_MEC010p2_MEX_LCM_010_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_010_BR
    ...    Check that MEC API provider service sends an error when it receives a malformed request to create a LCM Subscription
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.3.3.1,
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.12.2-1   #AppInstSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.14.2-1   #AppLcmOpOccSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.25.2-1   #AppInstIdCreationSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.28.2-1   #AppInstIdDeletionSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.10.2-1   #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.15.2-1   #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.26.2-1   #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.29.2-1   #AppInstIdDeletionSubscriptionInfo
  
    Send a request for a subscription  AppInstSubscriptionRequestBadRequest
    Check HTTP Response Status Code Is  400
    


TC_MEC_MEC010p2_MEX_LCM_011_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_011_OK
    ...    Check that MEC API provider service sends the list of LCM Subscriptions when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.3.3.2,
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.12.2-1   #AppInstSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.14.2-1   #AppLcmOpOccSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.25.2-1   #AppInstIdCreationSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.28.2-1   #AppInstIdDeletionSubscriptionRequest
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.10.2-1   #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.15.2-1   #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.26.2-1   #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.29.2-1   #AppInstIdDeletionSubscriptionInfo
    [Setup]  Send a request for a subscription  AppInstSubscriptionRequest
    Set Test Variable   ${SUB_ID}   ${response['body']['id']}
  
    Send a request for retrieving all subscriptions
    Check HTTP Response Status Code Is  200
    Validate Json     AppInstanceSubscriptionLinkList.schema.json    ${response}[body]
    [TearDown]   Send a request for deleting a subscription  ${SUB_ID}
    

TC_MEC_MEC010p2_MEX_LCM_012_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_012_OK
    ...    Check that MEC API provider service sends the information about an existing LCM subscription when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.4.3.2
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.10.2-1    #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.15.2-1    #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.26.2-1    #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.29.2-1    #AppInstIdDeletionSubscriptionInfo
    [Setup]  Send a request for a subscription  AppInstSubscriptionRequest
    Set Test Variable   ${SUB_ID}   ${response['body']['id']}
    Send a request for retrieving a subscription  ${SUB_ID}
    Check HTTP Response Status Code Is  200
    Should Be Equal As Strings  ${response['body']['id']}             ${SUB_ID}
    [TearDown]   Send a request for deleting a subscription  ${SUB_ID}


TC_MEC_MEC010p2_MEX_LCM_012_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_012_NF
    ...    Check that MEC API provider service sends an error when it receives a query for a not existing LCM Subscription
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.4.3.2
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.10.2-1    #AppInstSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.15.2-1    #AppLcmOpOccSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.26.2-1    #AppInstIdCreationSubscriptionInfo
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.29.2-1    #AppInstIdDeletionSubscriptionInfo
    [Setup]   Send a request for deleting a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    Send a request for retrieving a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is  404
    

TC_MEC_MEC010p2_MEX_LCM_013_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_013_OK
    ...    Check that MEC API provider service delete an existing LCM Subscription when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.3.3.4
    [Setup]  Send a request for a subscription  AppInstSubscriptionRequest
    Set Test Variable   ${SUB_ID}   ${response['body']['id']}
    
    Send a request for deleting a subscription  ${SUB_ID}
    Check HTTP Response Status Code Is  204


TC_MEC_MEC010p2_MEX_LCM_013_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_013_NF
    ...    Check that MEC API provider service sends an error when it receives a deletion request for a not existing LCM Subscription
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.3.3.4
    [Setup]   Send a request for deleting a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    
    Send a request for deleting a subscription  ${NOT_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is  404
    

    
TC_MEC_MEC010p2_MEX_LCM_014_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_014_OK
    ...    Check that MEC API provider service cancels an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.11.3.1",
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.32.2-1"   #CancelMode
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Cancel on going LCM Operation  ${APP_LCM_OP_OCCS_ID}   CancelMode
    Check HTTP Response Status Code Is    202
    [TearDown]  Delete APP Instance   ${APP_ID}  

    

TC_MEC_MEC010p2_MEX_LCM_014_BR
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_014_BR
    ...    Check that MEC API provider service fails to cancel an on going LCM Operation when it receives a malformed request
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.11.3.1",
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.32.2-1"   #CancelMode
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Cancel on going LCM Operation  ${APP_LCM_OP_OCCS_ID}   CancelModeBadRequest
    Check HTTP Response Status Code Is    400
    [TearDown]  Delete APP Instance   ${APP_ID} 

    
TC_MEC_MEC010p2_MEX_LCM_014_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_014_NF
    ...    Check that MEC API provider service fails to cancel an on going LCM Operation when it receives a request related to a not existing application LCM Operation
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.11.3.1",
    ...    ETSI GS MEC 010-2 3.1.1, table 6.2.2.32.2-1"   #CancelMode
    Cancel on going LCM Operation  ${NOT_EXISTING_APP_LCM_OP_OCC_ID}   CancelMode
    Check HTTP Response Status Code Is    404



TC_MEC_MEC010p2_MEX_LCM_015_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_015_OK
    ...    Check that MEC API provider service makes failed an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.12.3.1
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Fail on going LCM Operation  ${APP_LCM_OP_OCCS_ID}
    Check HTTP Response Status Code Is    200
    Validate Json    AppLcmOpOcc.schema.json    ${response}[body]
    [TearDown]  Delete APP Instance   ${APP_ID} 


TC_MEC_MEC010p2_MEX_LCM_015_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_015_NF
    ...    Check that MEC API provider service makes failed an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.12.3.1
    Fail on going LCM Operation  ${NOT_EXISTING_APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEX_LCM_016_OK
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_016_OK
    ...    Check that MEC API provider service retries an on going LCM Operation
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.13.3.1
    [Setup]  Create and Instantiate App Instance    CreateAppInstanceRequest     InstantiateAppRequest 
    Retry on going LCM Operation  ${APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    202
    [TearDown]  Delete APP Instance   ${APP_ID} 


TC_MEC_MEC010p2_MEX_LCM_016_NF
    [Documentation]    TP_MEC_MEC010p2_MEX_LCM_016_NF
    ...    Check that MEC API provider service fails to retry an LCM Operation when it receives a request related to a not existing application LCM Operation
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.13.3.1
    Retry on going LCM Operation  ${NOT_EXISTING_APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    404



*** Keywords ***
Create new App Instance
    [Arguments]    ${content}
    Log    Creating a new app package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   


GET all APP Instances 
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_instances
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    


GET APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Delete APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Create and Instantiate App Instance
    [Arguments]    ${appInstanceFile}  ${instantiatePayloadFile}
    Create new App Instance  ${appInstanceFile} 
    Set Suite Variable   ${APP_ID}   ${response['body']['id']}
    Instantiate App Request  ${response['body']['id']}   ${instantiatePayloadFile}
    ${elements} =  Split String    ${response['headers']['Location']}       /
    Set Suite Variable    ${APP_LCM_OP_OCCS_ID}     ${elements}[4]
    
    

Instantiate App Request
    [Arguments]    ${appInstanceId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/instantiate   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Terminate App Request
    [Arguments]    ${appInstanceId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/terminate   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Operate App Request
    [Arguments]    ${appInstanceId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/operate   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    


GET all App LCM op Occs 
    Log    Get all App LCM Operation occurrences
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    



GET App LCM op Occ
    [Arguments]    ${appLcmOpOccsId}
    Log    Get App LCM Operation occurrence
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOpOccsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    


Send a request for a subscription    
    [Arguments]    ${content}
    Log    Creating a new subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    



Send a request for retrieving all subscriptions    
    Log    Get all subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Send a request for retrieving a subscription
    [Arguments]    ${subscriptionId}    
    Log    Get all subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Send a request for deleting a subscription
    [Arguments]    ${subscriptionId}    
    Log    Get all subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Cancel on going LCM Operation 
    [Arguments]    ${appLcmOccOpId}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOccOpId}/cancel   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    



Fail on going LCM Operation 
    [Arguments]    ${appLcmOccOpId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOccOpId}/fail
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Retry on going LCM Operation 
    [Arguments]    ${appLcmOccOpId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOccOpId}/retry
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
