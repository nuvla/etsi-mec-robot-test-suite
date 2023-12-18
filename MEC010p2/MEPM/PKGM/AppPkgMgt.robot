''[Documentation]   robot --outputdir ./outputs ./AppPkgMgt.robot
...    Test Suite to validate Package Management (PKGM) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEPM_SCHEMA}://${MEPM_HOST}:${MEPM_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
#Library     MockServerLibrary


*** Test Cases ***
TC_MEC_MEC010p2_MEPM_PKGM_001_01_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_001_01_OK
   ...    Check that MEPM returns the list of App Packages when requested - Note 3
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.1.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Variable    ${APP_PKG_ID}    ${response['body']['id']}  
    GET all APP Packages
    Check HTTP Response Status Code Is    200
   
    FOR    ${appPkg}    IN    @{response['body']}
        Validate Json    AppPkgInfo.schema.json   ${appPkg} 
        Should Be Equal As Strings  ${appPkg['onboardingState']}    ${ONBOARDING_STATE}
    
    END
    [TearDown]  Delete APP Package  ${APP_PKG_ID}
    


TC_MEC_MEC010p2_MEPM_PKGM_001_02_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_001_02_OK
    ...    Check that MEPM returns the list of on boarded app Packages when requested - Note 3
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.1.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Variable    ${APP_PKG_ID}    ${response['body']['id']}  
    GET all onboarded APP Packages
    Check HTTP Response Status Code Is    200
    FOR    ${appPkg}    IN    @{response['body']}
        Validate Json    AppPkgInfo.schema.json   ${appPkg} 
    END
    [TearDown]  Delete APP Package  ${APP_PKG_ID}
   
TC_MEC_MEC010p2_MEPM_PKGM_001_BR
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_001_BR
    ...    Check that MEPM responds with an error when it receives 
    ...    a malformed request for requesting the list of existing App Packages
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.4.1.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all APP Packages with filters    ${MALFORMED_FILTER_NAME}    ${FILTER_VALUE}
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC010p2_MEPM_PKGM_002_01_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_002_01_OK
    ...    Check that MEPM returns the an App Package when requested - Note 3
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.2.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Test Variable    ${APP_PKG_CREATED_ID}    ${response['body']['id']}  
    GET an APP Package identified by    ${APP_PKG_CREATED_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppPkgInfo
    Should Be Equal As Strings  ${response['body']['id']}      ${APP_PKG_ID} 
    [TearDown]  Delete APP Package  ${APP_PKG_CREATED_ID}
    


TC_MEC_MEC010p2_MEPM_PKGM_002_02_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_002_02_OK
    ...    Check that MEPM returns the an App Package when requested - Note 3
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.2.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Test Variable    ${APP_PKG_CREATED_ID}    ${response['body']['id']}  
    GET an onboarded APP Package identified by    ${APP_PKG_CREATED_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppPkgInfo
    Should Be Equal As Strings  ${response['body']['id']}      ${APP_PKG_ID} 
    [TearDown]  Delete APP Package  ${APP_PKG_CREATED_ID}
    

TC_MEC_MEC010p2_MEPM_PKGM_002_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_002_NF
    ...    Check that MEPM responds with an error when it receives 
    ...    a request for returning a App Package referred with a wrong ID
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.2.3.2
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1
    ...    ETSI GS MEC 010-2 3.1.1, Table 6.2.3.3.2-1 Note 3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [TearDown]  Delete APP Package  ${NON_EXISTENT_APP_PKG_ID}
    GET an APP Package identified by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC010p2_MEPM_PKGM_003_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_003_OK
    ...    Check that MEPM service returns an application package subscription when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.3.3.1",
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    AppPkgSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Should Be Equal As Strings  ${response}[body][subscriptionType]      AppPackageOnBoardingSubscription
    Should Be Equal As Strings  ${response}[body][callbackUri]           ${CALLBACK_URI}
    [TearDown]   Delete an App Package Subscription identified by    ${response}[body][id]  
    
    

TC_MEC_MEC010p2_MEPM_PKGM_003_BR
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_003_BR
    ...    Check that MEPM service sends an error when it receives a 
    ...    malformed request for creating a new subscription on AppPackages
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.3.3.1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    AppPkgSubscriptionBadRequest
    Check HTTP Response Status Code Is    400


TC_MEC_MEC010p2_MEPM_PKGM_004_OK
   [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_006_OK
    ...    Check that MEPM service returns the list of Application Package Subscriptions when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.3.3.2
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.3.5.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Send a request for a subscription    AppPkgSubscription   
    Set Test Variable  ${SUB_ID}   ${response}[body][id]        
    Get all APP Package subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionLinkList 
    [TearDown]   Delete an App Package Subscription identified by    ${SUB_ID}
    

TC_MEC_MEC010p2_MEPM_PKGM_005_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_005_OK
    ...    Check that MEPM service returns an Application Package Subscription when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.2
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Send a request for a subscription    AppPkgSubscription   
    Set Test Variable    ${SUB_ID}    ${response['body']['id']}
    Get an individual APP Package subscriptions    ${SUB_ID}
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings  ${response}[body][id]           ${SUB_ID}
    Should Contain  ${response}[body][_links][self][href]  /app_pkgm/v1/subscriptions/${SUB_ID}
    [TearDown]   Delete an App Package Subscription identified by    ${SUB_ID}


TC_MEC_MEC010p2_MEPM_PKGM_005_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_005_NF
    ...    Check that MEPM service sends an error when it receives a query for a subscription on AppPackages 
    ...    with a wrong identifier
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.2
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Delete an App Package Subscription identified by    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Get an individual APP Package subscriptions    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
   

TC_MEC_MEC010p2_MEPM_PKGM_006_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_006_OK
    ...    Check that MEPM service deletes an Application Package Subscription when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Send a request for a subscription    AppPkgSubscription   
    Set Test Variable    ${SUB_ID}    ${response['body']['id']}
    Delete an App Package Subscription identified by    ${SUB_ID}
    Check HTTP Response Status Code Is    204
    
TC_MEC_MEC010p2_MEPM_PKGM_006_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_006_NF
    ...    Check that MEPM service sends an error when it receives a deletion request for a subscription on AppPackages 
    ...    with a wrong identifier
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.4
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.4
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.3.7
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Delete an App Package Subscription identified by    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Delete an App Package Subscription identified by    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404

##### TP_MEC_MEC010p2_MEPM_PKGM_007_OK TODO


TC_MEC_MEC010p2_MEPM_PKGM_008_NA
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_008_NA
    ...    Check that MEPM responds with an error when it receives 
    ...    a POST request referring an application descriptor AppD
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.6.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Post AppD by   ${APPD_ID}
    Check HTTP Response Status Code Is    405    

TC_MEC_MEC010p2_MEPM_PKGM_009_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_009_OK
    ...    Check that MEPM returns the Application Descriptor contained on a on-boarded Application Package when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.6.3.2
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.1.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Test Variable    ${APP_PKG_ID}    ${response['body']['id']}  
    Set Test Variable    ${CREATED_APPD_ID}    ${response['body']['appDId']}  
    Get AppD by   ${CREATED_APPD_ID}
    Check HTTP Response Status Code Is    200
    [TearDown]  Delete APP Package  ${APP_PKG_ID}

TC_MEC_MEC010p2_MEPM_PKGM_009_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_009_NF
    ...    Check that MEPM responds with an error when it receives
    ...    a request for returning a App Descriptor referred with a wrong App Package ID
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.6.3.2",
    ...    ETSI GS MEC 010-2 3.1.1, clause 6.2.1.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Delete APP Package  ${NON_EXISTENT_APP_PKG_ID}
    Get AppD by    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404   



TC_MEC_MEC010p2_MEPM_PKGM_010_FO
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_010_FO
    ...    Check that MEPM responds with an error when it receives 
    ...    a PUT request referring an application descriptor AppD
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.6.3.3
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Put on AppD endpoint    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    403      

TC_MEC_MEC010p2_MEPM_PKGM_011_NA
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_011_NA
    ...    Check that MEPM responds with an error when it receives 
    ...    a DELETE request referring an application descriptor AppD
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.6.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete on AppD endpoint    ${APP_PKG_ID}
    Check HTTP Response Status Code Is    405


TC_MEC_MEC010p2_MEPM_PKGM_012_01_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_012_01_OK
    ...    Check that MEPM fetches the on-boarded application package content identified by appPkgId when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Test Variable    ${APP_PKG_ID}    ${response['body']['id']}  
    Set Test Variable    ${CREATED_APPD_ID}    ${response['body']['appDId']}  
    Get application package by AppId  ${CREATED_APPD_ID}
    Check HTTP Response Status Code Is    200
    [TearDown]  Delete APP Package  ${APP_PKG_ID}

    
TC_MEC_MEC010p2_MEPM_PKGM_012_02_OK
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_012_02_OK
    ...    Check that MEPM fetches the on-boarded application package content identified by appDId when requested
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Post APP Package  CreateAppPackage.json 
    Set Test Variable    ${APP_PKG_ID}    ${response['body']['id']}  
    Set Test Variable    ${CREATED_APPD_ID}    ${response['body']['appDId']}  
    
    Get onboarded application package by AppdId   ${CREATED_APPD_ID}
    Check HTTP Response Status Code Is    200
    [TearDown]  Delete APP Package  ${APP_PKG_ID}
    

TC_MEC_MEC010p2_MEPM_PKGM_012_01_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_012_01_NF
    ...    Check that MEPM returns an error when performing
    ...    a request for returning a App Descriptor referred with a wrong App Package ID
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS    
    Get application package by AppId    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404     


TC_MEC_MEC010p2_MEPM_PKGM_012_02_NF
    [Documentation]    TP_MEC_MEC010p2_MEPM_PKGM_012_02_NF
    ...    Check that MEPM returns an error when performing
    ...    a request for returning an onboarded App Descriptor referred with a wrong App Package ID
    ...    ETSI GS MEC 010-2 3.1.1, clause 7.3.7.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get onboarded application package by AppdId    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404      
 

*** Keywords ***
Post APP Package
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_packages
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Delete APP Package
    [Arguments]    ${app_pkg_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${app_pkg_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

GET all APP Packages
    Log    Getting all App Packages
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     
GET all onboarded APP Packages
    Log    Getting all App Packages
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
GET all APP Packages with filters
    [Arguments]    ${key}    ${value}
    Log    Getting all App Packages using filtering parameters
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
   

GET an APP Package identified by
    [Arguments]    ${value}    
    Log    Getting an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

GET an onboarded APP Package identified by
    [Arguments]    ${value}    
    Log    Getting an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
        
Get AppD by
    [Arguments]    ${appdId}
    Log    Getting App Descriptor by its identifier
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Content-Type":"*/*"}   
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appdId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get AppD from onboarded app packages by
    [Arguments]    ${appdId}
    Log    Getting App Descriptor by its identigier
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Content-Type":"*/*"}   
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${appdId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Post AppD by
    [Arguments]    ${appdId}
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appdId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Post AppD from onboarded app packages by
    [Arguments]    ${appdId}
    Log    Getting App Descriptor by its identifier
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${appdId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 



Put on AppD endpoint
    [Arguments]    ${appdId}
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${appdId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Delete on AppD endpoint
    [Arguments]    ${appdId}
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${appdId}/appd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Get application package by AppId
    [Arguments]    ${appPkgId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Content-Type":"*/*"}   
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    
    
Get onboarded application package by AppdId
    [Arguments]    ${appdId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"${ACCEPTED_CONTENT_TYPE}"}
    Set Headers    {"Content-Type":"*/*"}   
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/onboarded_app_packages/${appdId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   


Get an AppD from App Package identified by
    [Arguments]    ${appPkgId}
    Log    Getting App descriptor for App Package
    Set Headers    {"Accept":"application/zip"}
    Set Headers    {"Content-Type":"*/*"}    
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${appPkgId}/app_descriptor
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

Get all APP Package subscriptions
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
