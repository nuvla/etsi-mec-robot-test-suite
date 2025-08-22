''[Documentation]   robot --outputdir ./outputs ./SRV/UETAG/PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${AMS_SCHEMA}://${AMS_HOST}:${AMS_PORT}    ssl_verify=false
Library     BuiltIn
Library     libraries/Server.py
Library     OperatingSystem
Library     MockServerLibrary
Library     Collections


*** Test Cases ***

# Get    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services
TC_MEC_MEC021_SRV_AMS_001_OK_01
    [Documentation]  Request Registered AMS information 
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS

    [Setup]    Create two new application mobility service      ${APP_MOBILITY_SERVICE_ID}    ${APP_INS_ID}    ${APP_MOBILITY_SERVICE_ID2}    ${APP_INS_ID}
    Get Registered AMS information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppMobilityServiceInfos

    FOR    ${app}    IN    @{response['body']}
        ${passed_appMobilityServiceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID} 
        ${passed_appInstanceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['serviceConsumerId']['appInstanceId']}    ${APP_INS_ID}  
        Exit For Loop If    ${passed_appMobilityServiceId} and ${passed_appInstanceId}
    END

    Should be True    ${passed_appMobilityServiceId}
    Should be True    ${passed_appInstanceId}

    FOR    ${app}    IN    @{response['body']}
        ${passed_appMobilityServiceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID2} 
        ${passed_appInstanceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['serviceConsumerId']['appInstanceId']}    ${APP_INS_ID}  
        Exit For Loop If    ${passed_appMobilityServiceId} and ${passed_appInstanceId}
    END

    Should be True    ${passed_appMobilityServiceId}
    Should be True    ${passed_appInstanceId}

    [TearDown]    Delete two specific AMS services    ${APP_MOBILITY_SERVICE_ID}    ${APP_MOBILITY_SERVICE_ID2}

TC_MEC_MEC021_SRV_AMS_001_OK_02
    [Documentation]  Request Registered AMS information 
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS

    [Setup]    Create two new application mobility service      ${APP_MOBILITY_SERVICE_ID}    ${APP_INS_ID}    ${APP_MOBILITY_SERVICE_ID2}    ${APP_INS_ID}

    Get Registered AMS information using attribute-selector    filter    ${APP_MOBILITY_SERVICE_FILTER_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfos

    FOR    ${app}    IN    @{response['body']}
        ${passed_appMobilityServiceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID} 
        ${passed_appInstanceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['serviceConsumerId']['appInstanceId']}    ${APP_INS_ID}  
        Exit For Loop If    ${passed_appMobilityServiceId} and ${passed_appInstanceId}
    END

    Should be True    ${passed_appMobilityServiceId}
    Should be True    ${passed_appInstanceId}

    [TearDown]    Delete two specific AMS services    ${APP_MOBILITY_SERVICE_ID}    ${APP_MOBILITY_SERVICE_ID2}


TC_MEC_MEC021_SRV_AMS_001_OK_03
    [Documentation]  Request Registered AMS information 
    ...  Check that the AMS service returns information about the a specific registered application mobility service when requested - filter
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS

    [Setup]    Create two new application mobility service      ${APP_MOBILITY_SERVICE_ID}    ${APP_INS_ID}    ${APP_MOBILITY_SERVICE_ID2}    ${APP_INS_ID}

    Get Registered AMS information using attribute-selector    filter    ${APP_MOBILITY_SERVICE_FILTER_SERVICE_CONSUMER_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfos

    FOR    ${app}    IN    @{response['body']}
        ${passed_appMobilityServiceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID} 
        ${passed_appInstanceId}    Run Keyword And Return Status    Should Be Equal As Strings  ${app['serviceConsumerId']['appInstanceId']}    ${APP_INS_ID}  
        Exit For Loop If    ${passed_appMobilityServiceId} and ${passed_appInstanceId}
    END

    [TearDown]    Delete two specific AMS services    ${APP_MOBILITY_SERVICE_ID}    ${APP_MOBILITY_SERVICE_ID2}


TC_MEC_MEC021_SRV_AMS_001_OK_04
    [Documentation]  Request Registered AMS information 
    ...  Check that the AMS service returns information about the a specific registered application mobility service when requested - filter
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS

    [Setup]    Create two new application mobility service      ${APP_MOBILITY_SERVICE_ID}    ${APP_INS_ID}    ${APP_MOBILITY_SERVICE_ID2}    ${APP_INS_ID}

    Get Registered AMS information using attribute-selector    filter    ${APP_MOBILITY_SERVICE_FILTER_EXCLUDE_FIELDS}
    Check HTTP Response Status Code Is    200
    #Check HTTP Response Body Json Schema Is    AppMobilityServiceInfos

    FOR    ${app}    IN    @{response['body']}
        Should Be Equal As Strings  ${app['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID} 
        Should Not Contain    ${app}    serviceConsumerId
    END

    [TearDown]    Delete two specific AMS services    ${APP_MOBILITY_SERVICE_ID}    ${APP_MOBILITY_SERVICE_ID2}

TC_MEC_MEC021_SRV_AMS_001_OK_05
    [Documentation]  Request Registered AMS information 
    ...  Check that the AMS service returns information about the registered application mobility services when requested - No registered application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.1
    Get Registered AMS information   
    Check HTTP Response Status Code Is    200
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS



TC_MEC_MEC021_SRV_AMS_001_BR
    [Documentation]    Request Registered AMS information using bad parameters
    ...  Check that the AMS service returns an error when receives a query about a registered application mobility service with wrong parameters
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Registered AMS information using bad parameters
    Check HTTP Response Status Code Is    400


# Post    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services
TC_MEC_MEC021_SRV_AMS_002_OK
    [Documentation]   Register a new application mobility services
    ...  Check that the AMS service creates a new application mobility services when requested
    ...  ETSI GS MEC 021 3.1.1, clause 6.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Create a new application mobility service      ${APP_MOBILITY_SERVICE_ID}    ${APP_INS_ID}      
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo
    Should Be Equal As Strings  ${response['body']['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID}   
    Should Be Equal As Strings  ${response['body']['serviceConsumerId']['appInstanceId']}    ${APP_INS_ID}  


TC_MEC_MEC021_SRV_AMS_002_BR
    [Documentation]   Register an UE Identity Tag using invalid parameter
    ...  Check that the AMS service sends an error when it receives a malformed request to create a new application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 6.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.3.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Create a new application mobility service    ${MALFORMED_APP_MOBILITY_SERVICE_ID}    ${APP_INS_ID}  
    Check HTTP Response Status Code Is    400


# Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
TC_MEC_MEC021_SRV_AMS_003_OK
    [Documentation]   Request Subscriptions List for the registered AMS services
    ...  Check that the AMS service returns information about the available subscriptions when requested.
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.4
    ...  ETSI GS MEC 021 3.1.1, clause 8.6.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Subscriptions for registered AMS
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinkList


TC_MEC_MEC021_SRV_AMS_003_BR
    [Documentation]   Request Subscription List for registered AMS Services using wrong attribute parameters
    ...  Check that the AMS service sends an error when it receives a malformed query about the available subscriptions
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.4
    ...  ETSI GS MEC 021 3.1.1, clause 8.6.3.1 
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get Subscriptions for registered AMS with wrong attbirube parameter
    Check HTTP Response Status Code Is    400


# Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
TC_MEC_MEC021_SRV_AMS_004_OK
    [Documentation]   Create a notification subscription
    ...  Check that the AMS service creates a notification subscriptions when requested.
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.6.3.4 
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Post a new notification subscription    NotificationSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    NotificationSubscription
    

TC_MEC_MEC021_SRV_AMS_004_BR
    [Documentation]   Create a notification subscription with wrong attribute parameter
    ...  Check that the AMS service creates a notification subscriptions when requested.
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.6.3.4 
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Post a new notification subscription    NotificationSubscriptionError
    Check HTTP Response Status Code Is    400


# Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
TC_MEC_MEC021_SRV_AMS_005_OK
    [Documentation]   Request a specific subscription
    ...  Check that the AMS service returns information about a given subscription when requested.
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.1 
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscription



TC_MEC_MEC021_SRV_AMS_005_NF
    [Documentation]   Request a specific subscription using wrong identifier
    ...  Check that the AMS service returns an error when receives a query about a not existing subscription
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.1 
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


# Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
TC_MEC_MEC021_SRV_AMS_006_OK
    [Documentation]   Remove a specific subscription
    ...  Check that the AMS service deletes a given subscription when requested
    ...  ETSI GS MEC 021 3.1.1, clause 6.7
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.5 
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC021_SRV_AMS_006_NF
    [Documentation]   Remove a specific subscription using wrong identifier
    ...  Check that the AMS service sends an error when it receives a delete request for a not existing subscription
    ...  ETSI GS MEC 021 3.1.1, clause 6.7
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.5 


    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    
  
# Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${identifier}
TC_MEC_MEC021_SRV_AMS_007_OK
    [Documentation]   Modify a specific subscription
    ...  Check that the AMS service modifies a given subscription when requested.
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Update individual subscription for AMS services    ${SUBSCRIPTION_ID}    NotificationSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscription



TC_MEC_MEC021_SRV_AMS_007_BR
    [Documentation]   Modify a specific subscription using malformed request
    ...  Check that the AMS service sends an error when it receives a malformed modify request for a given subscription.
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Update individual subscription for AMS services    ${SUBSCRIPTION_ID}    NotificationSubscriptionError
    Check HTTP Response Status Code Is    400


TP_MEC_MEC021_SRV_AMS_007_NF
    [Documentation]   Modify a specific subscription using wrong identifier
    ...  Check that the AMS service sends an error when it receives a modify request for a not existing subscription.
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.7.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Update individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}    NotificationSubscription
    Check HTTP Response Status Code Is    404



TC_MEC_MEC021_SRV_AMS_008_OK
    [Documentation]   Post Mobility Procedure Notification
    ...  Check that the AMS service sends an AMS notification  about a mobility procedure 
    ...  if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.9.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    
    [Setup]  Post a new notification subscription    NotificationSubscription
    Spawn Notification Server   MobilityProcedureNotification
    Validate Json   MobilityProcedureNotification.schema.json    ${payload_notification}
    [TearDown]  Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}


TC_MEC_MEC021_SRV_AMS_009_OK
    [Documentation]   Adjacent App Info Notification
    ...  Check that the AMS service sends an AMS notification about adjacent application instances if the AMS service has an associated 
    ...  subscription and the event is generated
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.9.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    
    [Setup]  Post a new notification subscription    NotificationSubscription
    Spawn Notification Server   AdjacentAppInfoNotification
    Validate Json   AdjacentAppInfoNotification.schema.json    ${payload_notification}
    [TearDown]  Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}


TC_MEC_MEC021_SRV_AMS_010_OK
    [Documentation]   Post Expire Notification
    ...  Check that the AMS service sends an AMS notification on subscription expiration if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 3.1.1, clause 7.4.4
    ...  ETSI GS MEC 021 3.1.1, clause 8.9.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    
    [Setup]  Post a new notification subscription    NotificationSubscription
    Spawn Notification Server   ExpiryNotification
    Validate Json   ExpiryNotification.schema.json    ${payload_notification}


# Get    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${APP_MOBILITY_SERVICE_ID_1}
TC_MEC_MEC021_SRV_AMS_011_OK
    [Documentation]   Request a specific AMS service
    ...  Check that the AMS service returns information about this individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get specific AMS service    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo



TC_MEC_MEC021_SRV_AMS_011_NF
    [Documentation]   Request a specific AMS Service using non existent identifier
    ...  Check that the AMS service sends an error when receives a query about a not existing individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Get specific AMS service     ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    404


# Put    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}
TC_MEC_MEC021_SRV_AMS_012_OK
    [Documentation]   Modify a specific AMS service
    ...  Check that the AMS service modifies the individual application mobility service when requested
    ...  ETSI GS MEC 021 3.1.1, clause 6.4
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Modify a specific AMS service    ${APP_MOBILITY_SERVICE_ID}     RegistrationInfo 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo
    Should Be Equal As Strings  ${response['body']['appMobilityServiceId']}    ${APP_MOBILITY_SERVICE_ID}
    Should Be Equal As Strings  ${response['body']['serviceConsumerId']['appInstanceId']}    ${APP_MOBILITY_SERVICE_ID}            # from req


TC_MEC_MEC021_SRV_AMS_012_NF
    [Documentation]   Modify a specific AMS Service using non existent identifier
    ...  Check that the AMS service sends an error when receives a request to modify a not existing individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 6.4
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Modify a specific AMS service    ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}    RegistrationInfo 
    Check HTTP Response Status Code Is    404


TC_MEC_MEC021_SRV_AMS_012_BR
    [Documentation]   Modify a specific AMS Service using bad parameters
    ...  Check that the AMS service sends an error when receives a request to modify a individual application mobility service using bad parameters
    ...  ETSI GS MEC 021 3.1.1, clause 6.4
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.2
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Modify a specific AMS service    ${APP_MOBILITY_SERVICE_ID}     RegistrationInfoWithError
    Check HTTP Response Status Code Is    400


# Delete    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}
TC_MEC_MEC021_SRV_AMS_013_OK
    [Documentation]   Remove a specific AMS service
    ...  Check that the AMS service de-register the individual application mobility service and delete the resource
    ...  that represents the individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 6.3
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.5
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete specific AMS service    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC021_SRV_AMS_013_NF
    [Documentation]   Remove a specific AMS Service using non existent identifier
    ...  Check that the AMS service sends an error when is requested to delete the resource
	...		that represents the individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 6.3
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.4.3.5
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Delete specific AMS service     ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    404


# POST    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices/${amsId}/deregisterTask
TC_MEC_MEC021_SRV_AMS_014_OK
    [Documentation]   Request to deregister a specific AMS service
    ...  Check that the AMS service deregister an individual application mobility service on expiry of the timer associated with the service
	...	 that represents the individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.5.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Deregister specific AMS service    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    204



TC_MEC_MEC021_SRV_AMS_014_NF
    [Documentation]   Request to deregister a specific AMS service using non existent identifier
    ...  Check that the AMS service send an error when is requested to deregister a not existent individual application mobility service
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.2
    ...  ETSI GS MEC 021 3.1.1, clause 8.5.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Deregister specific AMS service     ${NON_EXISTENT_APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    404

TC_MEC_MEC021_SRV_AMS_015_OK_01
    [Documentation]  
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.8.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Retrieve info about registered app mobility service

    Check HTTP Response Body Json Schema Is    AdjacentAppInstanceInfoList
    Check HTTP Response Status Code Is    200
    
TC_MEC_MEC021_SRV_AMS_015_OK_02
    [Documentation]  
    ...  Check that the AMS service returns information about the adjacent application instances when requested - filter
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.8.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Retrieve info about registered app mobility service with filter   (eq,appInstanceId,{APP_INSTANCE_ID_1})
    Check HTTP Response Body Json Schema Is    AdjacentAppInstanceInfoList
    Check HTTP Response Status Code Is    200    


TC_MEC_MEC021_SRV_AMS_015_OK_03
    [Documentation]  
    ...  Check that the AMS service returns information about a specified adjacent application instances when requested - filter
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.8.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Retrieve info about registered app mobility service with filter   (eq,appInstanceId,{APP_INSTANCE_ID_1})&filter(eq,appDId,{APP_ID_3})
    Check HTTP Response Body Json Schema Is    AdjacentAppInstanceInfoList
    Check HTTP Response Status Code Is    200     


TC_MEC_MEC021_SRV_AMS_015_OK_04
    [Documentation]  
    ...  Check that the AMS service returns information about a specified adjacent application instances when requested - filter
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.8.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Retrieve info about registered app mobility service
    Check HTTP Response Body Json Schema Is    AdjacentAppInstanceInfoList
    Check HTTP Response Status Code Is    200 
    

TC_MEC_MEC021_SRV_AMS_015_BR
    [Documentation]  
    ...  Check that the AMS service sends an error about a specified adjacent application instances when request is inconsistent
    ...  ETSI GS MEC 021 3.1.1, clause 7.2.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.8.3.1
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    Retrieve info about registered app mobility service with filter   (appInstanceId,eq,{APP_INSTANCE_ID_1})
    Check HTTP Response Status Code Is    400 
 

TC_MEC_MEC021_SRV_UETESTNOT_001_OK
    [Documentation]  
    ...  Check that the IUT provides a test notification when requested by a MEC Application
    ...  ETSI GS MEC 021 3.1.1, clause 6.9
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.2
    ...  ETSI GS MEC 021 3.1.1, clause 7.3.3
    ...  ETSI GS MEC 021 3.1.1, clause 8.6.3.4
    [Tags]    PIC_AMS    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Post a new notification subscription    NotificationSubscriptionWithTestNotification
    Spawn Notification Server   MobilityProcedureNotification
    Validate Json   MobilityProcedureNotification.schema.json    ${payload_notification}
    [TearDown]  Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Spawn Notification Server    TestNotification
    Validate Json   TestNotification.schema.json    ${payload_notification}
    [TearDown]  Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}
*** Keywords ***
Get Registered AMS information
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get Registered AMS information using attribute-selector
    [Arguments]    ${key}    ${value}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get specific AMS service
    [Arguments]     ${amsId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Get Registered AMS information using bad parameters
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services?appMobilityService=${APP_MOBILITY_SERVICE_ID}     #param should be appMobilityServiceId
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Modify a specific AMS service
    [Arguments]     ${amsId}     ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}   ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Delete specific AMS service
    [Arguments]     ${amsId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Delete two specific AMS services
    [Arguments]     ${amsId}    ${amsId2}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId2}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Deregister specific AMS service
    [Arguments]     ${amsId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services/${amsId}/deregisterTask
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

    
    
Create a new application mobility service
    [Arguments]    ${appMobilityServiceId}    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    RegistrationInfo    .json
    ${body}=    Get File    ${file}
    ${json_data}=    Evaluate    json.loads('''${body}''')    json
    Set To Dictionary    ${json_data}    appMobilityServiceId=${appMobilityServiceId}
    Set To Dictionary    ${json_data['serviceConsumerId']}    appInstanceId=${appInstanceId}
    ${modified_json_string}=    Evaluate    json.dumps(${json_data})
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services    ${modified_json_string}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Create two new application mobility service
    [Arguments]    ${appMobilityServiceId}    ${appInstanceId}    ${appMobilityServiceId2}    ${appInstanceId2}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    RegistrationInfo    .json
    ${body}=    Get File    ${file}
    ${json_data}=    Evaluate    json.loads('''${body}''')    json
    Set To Dictionary    ${json_data}    appMobilityServiceId=${appMobilityServiceId}
    Set To Dictionary    ${json_data['serviceConsumerId']}    appInstanceId=${appInstanceId}
    ${modified_json_string}=    Evaluate    json.dumps(${json_data})
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services    ${modified_json_string}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    RegistrationInfo    .json
    ${body}=    Get File    ${file}
    ${json_data}=    Evaluate    json.loads('''${body}''')    json
    Set To Dictionary    ${json_data}    appMobilityServiceId=${appMobilityServiceId2}
    Set To Dictionary    ${json_data['serviceConsumerId']}    appInstanceId=${appInstanceId2}
    ${modified_json_string}=    Evaluate    json.dumps(${json_data})
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_mobility_services    ${modified_json_string}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Get Subscriptions for registered AMS    
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
    
Get Subscriptions for registered AMS with wrong attbirube parameter
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?subscriptionTyp=${SUBSCRIPTION_TYPE}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Post a new notification subscription
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
    
Get individual subscription for AMS services
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    

Delete individual subscription for AMS services 
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}      


Update individual subscription for AMS services
    [Arguments]    ${identifier}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${identifier}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Spawn Notification Server
    [Arguments]  ${payload_notification}
    ${output}   Spawn Web Server  ${NOTIFICATION_SERVER_IP}  ${NOTIFICATION_SERVER_PORT}  ${NOTIFICATION_SERVER_TIMEOUT}  ${NOTIFICATION_SERVER_HTTP_METHOD}  ${NOTIFICATION_SERVER_URI}   ${payload_notification} 
    ${length} =  Get Length  ${output}  
    Set Suite Variable    ${payload_notification}    ${output}
    Run Keyword If  ${length} == 0  Skip
    

Retrieve info about registered app mobility service
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/amsi/v1/queries/adjacent_app_instances
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     


Retrieve info about registered app mobility service with filter
    [Arguments]    ${filter}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/amsi/v1/queries/adjacent_app_instances?filter${filter}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    
