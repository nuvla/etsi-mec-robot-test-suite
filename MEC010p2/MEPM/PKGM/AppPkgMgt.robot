''[Documentation]   robot --outputdir ../../outputs ./AppPkgMgt.robot
...    Test Suite to validate MEPM Package Management (PKGM) operations.

*** Settings ***
Resource     environment/variables.txt
Resource     ../../../GenericKeywords.robot
Library      REST    ${MEPM_SCHEMA}://${MEPM_HOST}:${MEPM_PORT}    ssl_verify=false
Library      BuiltIn
Library      OperatingSystem
Resource     ../../../pics.txt


*** Test Cases ***
TC_MEC_MEC010p2_MEPM_PKGM_001_01_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_001_01_OK  
    ...  Check that MEO creates a new App Package when requested
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.1.3.1
    ...  ETSI GS MEC 010-2 3.1.1, clause 6.2.3.2.2    ##AppPkgInfo
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Create new App Package        CreateAppPackage.json
    Set Suite Variable    ${APP_PKG_ID}    ${response['body']['id']}
    GET all app Packages
    Check HTTP Response Status Code Is    200
    FOR    ${onBoardedAppPkgInfo}    IN    @{response['body']}
        Validate Json    AppPkgInfo.schema.json    ${onBoardedAppPkgInfo}
        Should Be Equal As Strings  ${onBoardedAppPkgInfo['onboardingState']}    ${ONBOARDING_STATE}
    END
    [Teardown]   Delete an individual APP Package identified by ID    ${APP_PKG_ID}


TC_MEC_MEC010p2_MEPM_PKGM_002_01_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_002_01_OK  
    ...  Check that MEPM returns the list of on-boarded App Packages when requested - Note 3
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.1.3.1
    ...  ETSI GS MEC 010-2 3.1.1, clause 6.2.3.2.2    ##AppPkgInfo
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Create new App Package        CreateAppPackage.json
    
    Set Suite Variable    ${APP_PKG_ID}    ${response['body']['id']}
    Set Suite Variable    ${APPD_ID}    ${response['body']['appDId']}
    GET all app Packages
    Check HTTP Response Status Code Is    200
    FOR    ${onBoardedAppPkgInfo}    IN    @{response['body']}
        Validate Json    AppPkgInfo.schema.json    ${onBoardedAppPkgInfo}
        Should Contain  ${onBoardedAppPkgInfo['_links']['self']['href']}    ${APP_PKG_ID}       
        Should Contain  ${onBoardedAppPkgInfo['_links']['appD']['href']}    ${APPD_ID}       
        Should Contain  ${onBoardedAppPkgInfo['_links']['appPkgContent']['href']}   ${APPD_ID}       
        Should Be Equal As Strings  ${onBoardedAppPkgInfo['onboardingState']}    ${ONBOARDING_STATE}
    END
    [Teardown]   Delete an individual APP Package identified by ID    ${APP_PKG_ID}
    
TC_MEC_MEC010p2_MEPM_PKGM_001_BR
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_001_BR  
    ...  Check that MEPM responds with an error when it receives 
    ...  a malformed request for requesting the list of existing App Packages
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.1.3.1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Create new App Package        CreateAppPackage.json
    Set Suite Variable    ${APP_PKG_ID}    ${response['body']['id']}
    Set Suite Variable    ${APPD_ID}    ${response['body']['appDId']}
    GET all app Packages with filter    operationalStatus     ENABLED
    Check HTTP Response Status Code Is    400    
    [Teardown]   Delete an individual APP Package identified by ID    ${APP_PKG_ID}



TC_MEC_MEC010p2_MEPM_PKGM_002_01_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_002_01_OK  
    ...  Check that MEPM returns the an App Package when requested - Note 3
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.2.3.2
    ...  ETSI GS MEC 010-2 3.1.1, clause 6.2.3.3.2   ##AppPkgInfo
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Create new App Package        CreateAppPackage.json
    Set Suite Variable    ${APP_PKG_ID}    ${response['body']['id']}
    Set Suite Variable    ${APPD_ID}    ${response['body']['appDId']}
    Get an individual APP Package identified by ID    ${APP_PKG_ID}
    Check HTTP Response Status Code Is    200    
    Validate Json    AppPkgInfo.schema.json    ${response['body']}
    Should Contain  ${response['body']['_links']['self']['href']}    ${APP_PKG_ID}       
    Should Contain  ${response['body']['_links']['appD']['href']}    ${APPD_ID}       
    Should Contain  ${response['body']['_links']['appPkgContent']['href']}   ${APPD_ID}       
    Should Be Equal As Strings  ${response['body']['onboardingState']}    ${ONBOARDING_STATE}
    [Teardown]   Delete an individual APP Package identified by ID     ${APP_PKG_ID}



TC_MEC_MEC010p2_MEPM_PKGM_002_02_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_002_02_OK  
    ...  Check that MEPM returns the an App Package when requested - Note 3
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.2.3.2
    ...  ETSI GS MEC 010-2 3.1.1, clause 6.2.3.3.2   ##AppPkgInfo
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]   Create new App Package        CreateAppPackage.json
    Set Suite Variable    ${APP_PKG_ID}    ${response['body']['id']}
    Set Suite Variable    ${APPD_ID}    ${response['body']['appDId']}
    Get an individual APP Package identified by ID    ${APPD_ID}
    Check HTTP Response Status Code Is    200    
    Validate Json    AppPkgInfo.schema.json    ${response['body']}
    Should Contain  ${response['body']['_links']['self']['href']}    ${APP_PKG_ID}       
    Should Contain  ${response['body']['_links']['appD']['href']}    ${APPD_ID}       
    Should Contain  ${response['body']['_links']['appPkgContent']['href']}   ${APPD_ID}       
    Should Be Equal As Strings  ${response['body']['onboardingState']}    ${ONBOARDING_STATE}
    [Teardown]   Delete an individual APP Package identified by ID     ${APP_PKG_ID}


TC_MEC_MEC010p2_MEPM_PKGM_002_NF
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_002_NF  
    ...  Check that MEPM responds with an error when it receives 
    ...  a request for returning a App Package referred with a wrong ID
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.2.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]    Delete an individual APP Package identified by ID     ${NON_EXISTENT_APP_PKG_ID}
    Get an individual APP Package identified by ID    ${NON_EXISTENT_APP_PKG_ID}
    Check HTTP Response Status Code Is    404    
     
         
TC_MEC_MEC010p2_MEPM_PKGM_003_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_003_OK  
    ...  Check that MEPM service returns an application package subscription when requested
    ...      ETSI GS MEC 010-2 3.1.1, clause 7.3.3.3.1
    ...      ETSI GS MEC 010-2 3.1.1, clause 6.2.3.7.2  ##AppPkgSubscription
    ...      ETSI GS MEC 010-2 3.1.1, clause 6.2.3.4.2  ##AppPkgSubscriptionInfo
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a subscription     AppPkgSubscription.json
    Set Suite Variable     ${SUBSCRIPTION_ID}  ${response['body']['id']}
    Check HTTP Response Status Code Is    201    
    Validate Json    AppPkgSubscriptionInfo.schema.json    ${response['body']}
    [TearDown]  Delete a subscription  ${SUBSCRIPTION_ID}
       

TC_MEC_MEC010p2_MEPM_PKGM_003_BR
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_003_BR  
    ...  Check that MEPM service sends an error when it receives a 
    ...  malformed request for creating a new subscription on AppPackages
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.3.3.1
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a subscription     AppPkgSubscriptionBadRequest.json
    Check HTTP Response Status Code Is    400

TC_MEC_MEC010p2_MEPM_PKGM_004_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_004_OK  
    ...  Check that MEPM service returns the list of Application 
    ...  Package Subscriptions when requested
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.3.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Create a subscription     AppPkgSubscription.json
    Set Suite Variable     ${SUBSCRIPTION_ID}  ${response['body']['id']}
    Get all subscriptions 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionLinkList
    [TearDown]  Delete a subscription  ${SUBSCRIPTION_ID}

 

TC_MEC_MEC010p2_MEPM_PKGM_005_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_005_OK  
    ...  Check that MEPM service returns an Application Package Subscription when requested
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.2
    ...  ETSI GS MEC 010-2 3.1.1, clause 6.2.3.4.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Create a subscription     AppPkgSubscription.json
    Set Suite Variable     ${SUBSCRIPTION_ID}  ${response['body']['id']}
    Get an individual subscription       ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    [TearDown]  Delete a subscription  ${SUBSCRIPTION_ID}
    

TC_MEC_MEC010p2_MEPM_PKGM_005_NF
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_005_NF
    ...  C"Check that MEPM service sends an error when 
    ...    it receives a query for a subscription on AppPackages with a wrong identifier
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.2
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Delete a subscription  ${NON_EXISTENT_SUBSCRIPTION_ID}
    Get an individual subscription       ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
 

TC_MEC_MEC010p2_MEPM_PKGM_006_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_006_OK
    ...  Check that MEPM service deletes an Application Package Subscription when requested
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Create a subscription     AppPkgSubscription.json
    Set Suite Variable     ${SUBSCRIPTION_ID}  ${response['body']['id']}
    Delete a subscription  ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204   

TC_MEC_MEC010p2_MEPM_PKGM_006_OK
    [Documentation]  TP_MEC_MEC010p2_MEPM_PKGM_006_NF
    ...  Check that MEPM service sends an error 
    ...  when it receives a deletion request for a subscription on AppPackages 
    ...  with a wrong identifier
    ...  ETSI GS MEC 010-2 3.1.1, clause 7.3.4.3.4
    [Tags]    PIC_APP_PACKAGE_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    [Setup]  Delete a subscription   ${NON_EXISTENT_SUBSCRIPTION_ID}
    Delete a subscription  ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404  
        
    
*** Keywords ***
Create new App Package
    [Arguments]    ${content}
    Set Headers    {"Accept":"*/*"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_packages    ${body}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     
   

GET all app Packages
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages    
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


GET all app Packages with filter
    [Arguments]    ${key}    ${value}
    Log    Getting all App Packages using filtering parameters
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Get an individual APP Package identified by ID
    [Arguments]    ${identifier}    
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get   ${apiRoot}/${apiName}/${apiVersion}/app_packages/${identifier}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 


Create a subscription    
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    
        
Delete a subscription    
    [Arguments]    ${id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    

Get all subscriptions   
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    

Get an individual subscription
    [Arguments]    ${id}    
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Delete an individual APP Package identified by ID
    [Arguments]    ${identifier}    
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_packages/${identifier}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

Spawn Notification Server
    [Arguments]  ${host}  ${port}  ${timeout}  ${method}  ${endpoint}  ${notification_content}    ${autosent_notification}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${notification_content}    .json
    ${body}=    Get File    ${file}
    #Spawn Web Server  ${host}  ${port}  ${timeout}  ${method}  ${endpoint}  ${body}     ${autosent_notification}

