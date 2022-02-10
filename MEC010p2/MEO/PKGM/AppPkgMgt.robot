''[Documentation]   robot --outputdir ./outputs ./AppPkgMgt.robot
...    Test Suite to validate Package Management (PKGM) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEO_SCHEMA}://${MEO_HOST}:${MEO_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
#Library     MockServerLibrary


*** Test Cases ***
TC_MEC_MEC010p2_MEO_PKGM_001_OK
    [Documentation]  TP_MEC_MEC010p2_MEO_PKGM_001_OK  
    ...  Check that MEO creates a new App Package when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.1.3.1
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1 (OnboardedAppPkgInfo)
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.2.2-1 (AppPkg)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Post Request to create new App Package Resource        CreateAppPackage.json
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   AppPkgInfo
    Check HTTP Response Header Contains    Location
    Should Be Equal As Strings  ${response['body']['appDVersion']}    ${APP_PKG_VERSION}
    Should Be Equal As Strings  ${response['body']['checksum']['algorithm']}    ${CHECKSUM}
    Should Be Equal As Strings  ${response['body']['operationalState']}    ${OPERATIONAL_STATE}
    Should Be Equal As Strings  ${response['body']['onboardingState']}    ${ONBOARDING_STATE}
    Should Be Equal As Strings  ${response['body']['usageState']}     ${USAGE_STATE}


TC_MEC_MEC010p2_MEO_PKGM_001_BR
    [Documentation]  TP_MEC_MEC010p2_MEO_PKGM_001_BR 
    ...  Check that MEO creates a new App Package when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.1.3.1
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.2.2-1 (AppPkg)
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Post Request to create new App Package Resource        CreateAppPackageBadRequest.json
    Check HTTP Response Status Code Is    400



TC_MEC_MEC010p2_MEO_PKGM_002_01_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_002_01_OK
    ...    Check that MEO returns the list of App Packages when requested - Note 3
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.1.3.2
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all app Packages
    Check HTTP Response Status Code Is    200
    FOR    ${onBoardedAppPkgInfo}    IN    @{response['body']}
        Validate Json    AppPkgInfo.schema.json    ${onBoardedAppPkgInfo}
    END



TC_MEC_MEC010p2_MEO_PKGM_002_02_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_002_02_OK
    ...    Check that MEO returns the list of App Packages when requested - Note 3
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.1.3.2
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all onboarded app Packages
    Check HTTP Response Status Code Is    200
    FOR    ${onBoardedAppPkgInfo}    IN    @{response['body']}
        Validate Json    AppPkgInfo.schema.json    ${onBoardedAppPkgInfo}
    END
        
TC_MEC_MEC010p2_MEO_PKGM_002_BR
    [Documentation]    TP_MEC_MEO_PKGM_002_BR
    ...    Check that MEO responds with an error when it receives 
    ...    a malformed request for retrieving the list of existing App Packages
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.1.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all APP Packages with filters    ${MALFORMED_FILTER_NAME}    ${FILTER_VALUE}
    Check HTTP Response Status Code Is    400
    
    
TC_MEC_MEC010p2_MEO_PKGM_003_01_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_003_01_OK
    ...    Check that MEO returns the an App Package when requested - Note 3
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.2
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an app Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppPkgInfo
    Should Be Equal As Strings  ${response['body']['id']}  ${ON_BOARDED_APP_PKG_ID}
    Should Be Equal As Strings  ${response['body']['appName']}  ${APP_NAME}
    


TC_MEC_MEC010p2_MEO_PKGM_003_02_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_003_02_OK
    ...    Check that MEO returns the an onboarded App Package when requested - Note 3
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.2
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an onboarded app Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppPkgInfo
    Should Be Equal As Strings  ${response['body']['id']}  ${ON_BOARDED_APP_PKG_ID}
    Should Be Equal As Strings  ${response['body']['appName']}  ${APP_NAME}

    
TC_MEC_MEC010p2_MEO_PKGM_003_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_003_NF
    ...    Check that MEO responds with an error when it receives 
    ...    a request for retrieving a App Package referred with a wrong ID
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.2
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an APP Package identified by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC010p2_MEO_PKGM_004_OK
    [Documentation]    TP_MEC_MEO_PKGM_004_OK
    ...    Check that MEO deletes an App Package when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an individual APP Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body is Empty
    

TC_MEC_MEC010p2_MEO_PKGM_004_NF
    [Documentation]    TP_MEC_MEO_PKGM_004_NF
    ...    Check that MEO responds with an error when it receives 
    ...    a request for deleting an App Package referred with a wrong ID
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an individual APP Package identified by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEO_PKGM_005_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_005_OK
    ...    Check that MEO updates the operational state of an individual application package resource
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.5
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Update Operational State for an app Package    ${ON_BOARDED_APP_PKG_ID}    AppPkgInfoModifications.json
    Check HTTP Response Body Json Schema Is   AppPkgInfoModifications
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings  ${response['body']['operationalState']}  ${OPERATIONAL_STATE}


TC_MEC_MEC010p2_MEO_PKGM_005_BR
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_005_BR
    ...    Check that MEO sends an error when it receives a malformed request to modify the operational state of an application package
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.5
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Update Operational State for an app Package    ${ON_BOARDED_APP_PKG_ID}      AppPkgInfoModificationsBadRequest.json
    Check HTTP Response Status Code Is    400

TC_MEC_MEC010p2_MEO_PKGM_005_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_005_NF
    ...   Check that MEO responds with an error when it receives 
    ...   a request for updating an App Package referred with a wrong ID
    ...   ETSI GS MEC 010-2 2.2.1, clause 7.3.2.3.5
    ...   ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Update Operational State for an app Package    ${NON_EXISTENT_APP_PKG_ID}      AppPkgInfoModificationsBadRequest.json
    Check HTTP Response Status Code Is    404

    
TC_MEC_MEC010p2_MEO_PKGM_006_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_006_OK
    ...    Check that MEO service returns an application package subscription when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.3.3.1
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    AppPkgSubscription.json
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Should Be Equal As Strings  ${response['body']['subscriptionType']}     ${SUBSCRIPTION_TYPE}
    Should Be Equal As Strings  ${response['body']['callbackUri']}     ${CALLBACK_URI}
    
TC_MEC_MEC010p2_MEO_PKGM_006_BR
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_006_BR
    ...    Check that MEO service sends an error when it receives a  malformed request for creating a new subscription on AppPackages
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.4.3.1",
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.4",
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    AppPkgSubscriptionBadRequest.json
    Check HTTP Response Status Code Is    400
    


TC_MEC_MEC010p2_MEO_PKGM_007_OK
   [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_007_OK
    ...    Check that MEO service returns the list of Application Package Subscriptions when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.3.3.2
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get all APP Package subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionLinkList


TC_MEC_MEC010p2_MEO_PKGM_008_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_008_OK
    ...    Check that MEO service returns an Application Package Subscription when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.4.3.2
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual APP Package subscriptions    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Should Be Equal As Strings  ${response['body']['id']}  ${SUBSCRIPTION_ID}

TC_MEC_MEC010p2_MEO_PKGM_008_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_008_NF
    ...    Check that MEO service sends an error when it receives a query for a subscription on AppPackages  with a wrong identifier
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.4.3.2
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual APP Package subscriptions    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    


TC_MEC_MEC010p2_MEO_PKGM_009_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_009_OK
    ...    Check that MEO service deletes an Application Package Subscription when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.4.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an App Package Subscription identified by    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body is Empty


TC_MEC_MEC010p2_MEO_PKGM_009_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_009_NF
    ...    Check that MEO service sends an error when it receives a deletion request for a subscription on AppPackages 
    ...    with a wrong identifier
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.4.3.4
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an App Package Subscription identified by    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404

TC_MEC_MEC010p2_MEO_PKGM_011_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_011_OK
    ...    Check that MEO reads the content of the AppD of on-boarded individual application package resources when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.6.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an AppD from App Package identified by    ${ON_BOARDED_APP_PKG_ID}
    Check HTTP Response Status Code Is    200
    

TC_MEC_MEC010p2_MEO_PKGM_011_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_011_NF
    ...    Check that MEO responds with an error when it receives 
    ...    a request to retrieve an application descriptor referred with a wrong app package ID
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.6.3.2",
    ...    ETSI GS MEC 010-2 2.2.1, Table 6.2.3.3.2-1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an AppD from App Package identified by    ${NON_EXISTING_APPD_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEO_PKGM_012_01_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_012_01_OK
    ...    Check that MEO fetches the application package content identified by appPkgId when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get app Package identified by    ${ON_BOARDED_APP_PKG_ID}      ${ACCEPTED_CONTENT_TYPE_ZIP}
    Check HTTP Response Status Code Is    200

TC_MEC_MEC010p2_MEO_PKGM_012_02_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_012_02_OK
    ...    Check that MEO fetches the application package content identified by appPkgId when requested
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get onboarded app Package identified by    ${ON_BOARDED_APP_PKG_ID}     ${ACCEPTED_CONTENT_TYPE_ZIP}
    Check HTTP Response Status Code Is    200    


TC_MEC_MEC010p2_MEO_PKGM_012_BR
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_012_BR
    ...    Check that MEO service sends an error when it receives a malformed request
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get app Package identified by    ${ON_BOARDED_APP_PKG_ID}      ${WRONG_CONTENT_TYPE}
    Check HTTP Response Status Code Is    400
    
TC_MEC_MEC010p2_MEO_PKGM_013_OK
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_013_OK
    ...    Check that MEO accepts application package when submitted
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.7.3.3
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.1.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Submit application package    ${APP_PKG_ID}
    Check HTTP Response Status Code Is    202   


TC_MEC_MEC010p2_MEO_PKGM_013_NF
    [Documentation]    TP_MEC_MEC010p2_MEO_PKGM_013_NF
    ...    Check that MEO returns an errore when an application package with wrong id is submitted
    ...    ETSI GS MEC 010-2 2.2.1, clause 7.3.7.3.3
    ...    ETSI GS MEC 010-2 2.2.1, clause 6.2.1.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Submit application package    ${NOT_EXISTING_APP_PKG_ID}
    Check HTTP Response Status Code Is    404      
      


*** Keywords ***
Post Request to create new App Package Resource
    [Arguments]    ${content}
    Log    Creating a new App Package
    Set Headers    {"Accept":"*/*"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_packages    ${body}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     
   
    
GET all app Packages
    Log    Getting all App Packages
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages    
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     

GET all onboarded app Packages
    Log    Getting all App Packages
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages    
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

    
GET all app Packages with filters
    [Arguments]    ${key}    ${value}
    Log    Getting all App Packages using filtering parameters
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
    
GET an app Package identified by
    [Arguments]    ${value}    
    Log    Getting an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

GET an onboarded app Package identified by
    [Arguments]    ${value}    
    Log    Getting an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
        
    
Delete an individual APP Package identified by
    [Arguments]    ${value}    
    Log    Removing an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
    
    
Update Operational State for an app Package    
    [Arguments]    ${appPkgId}    ${content}
    Log    Updating an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}     ${body} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
   
  
Get an AppD from App Package identified by
    [Arguments]    ${appPkgId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Get app Package identified by
    [Arguments]    ${appPkgId}      ${CONTENT_TYPE}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Get onboarded app Package identified by
    [Arguments]    ${appPkgId}      ${CONTENT_TYPE}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${appPkgId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Submit application package
    [Arguments]    ${appPkgId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE_ZIP}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     

Send a request for a subscription    
    [Arguments]    ${content}
    Log    Creating a new subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}       



Get all app Package subscriptions
    Log    Getting list of subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

    
Get an individual APP Package subscriptions
    [Arguments]    ${subId}
    Log    Getting an individual subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 



Delete an App Package Subscription identified by
    [Arguments]    ${subId}
    Log    Deleting a subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

    