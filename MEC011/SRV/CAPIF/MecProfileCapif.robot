*** Settings ***

Documentation
...    A test suite for validating Common API Framework (CAPIF) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 

Default Tags    TC_MEC_SRV_TRANS


*** Test Cases ***
TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_001_OK_01
    [Documentation]
    ...    Check that the IUT responds with all service APIs when 
    ...    queried by a MEC Application - No filter
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get all services APIs
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescriptionList 


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_001_OK_02
    [Documentation]
    ...    Check that the IUT responds with all service APIs when 
    ...    queried by a MEC Application - Filter on apiName
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get services APIs with query params     apiName=${API_NAME_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescriptionList 
     FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[apiName]      ${API_NAME_QUERY_PARAM}
    END


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_001_OK_03
    [Documentation]
    ...    Check that the IUT responds with all service APIs when 
    ...    queried by a MEC Application - Filter on apiId
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get services APIs with query params     apiId=${API_ID_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescriptionList 
     FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[apiId]      ${API_ID_QUERY_PARAM}
    END
    

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_001_OK_04
    [Documentation]
    ...    Check that the IUT responds with all service APIs when 
    ...    queried by a MEC Application - Filter on apiId and apiName
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get services APIs with query params     apiId=${API_ID_QUERY_PARAM}&apiName=${API_NAME_QUERY_PARAM}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescriptionList 
     FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[apiId]      ${API_ID_QUERY_PARAM}
      Should Be Equal As Strings    ${element}[apiName]      ${API_NAME_QUERY_PARAM}
    END




TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when applying a malformed filter
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get services APIs with query params     badQueryParam=${API_ID_QUERY_PARAM}
    Check HTTP Response Status Code Is    400
    
    
TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when applying a filter on an unknown apiName
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get services APIs with query params     apiName=${UNKNOWN_MEC_SRV_SER_NAME}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_002_OK
    [Documentation]
    ...    Check that the IUT responds with all service APIs 
    ...    for a specific apfId when queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get published services APIs   ${MEC_SRV_INSTANCE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescriptionList 
     FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[apiId]      ${MEC_SRV_INSTANCE_ID}
    END

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when 
    ...    applying a filter on an unknown apfId
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.1
    ...   ETSI GS MEC 011 clause 9.2.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get published services APIs   ${NOT_EXISTING_MEC_SRV_INSTANCE_ID}
    Check HTTP Response Status Code Is    404



TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_003_OK
    [Documentation]
    ...    Check that the IUT acknowledges the publishing of a new API when 
    ...    queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.2
    ...   ETSI GS MEC 011 clause 9.2.4.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Publish new APIs   ${MEC_SRV_INSTANCE_ID}   serviceApiDescription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ServiceApiDescription
    ${MEC_SRV_SER_NAME}    Get value entry from JSON file   ServiceApiDescription     apiName  
    Check Response Contains    ${response['body']}    apiId    ${MEC_SRV_SER_INSTANCE_ID}
    Check Response Contains    ${response['body']}    apiName    ${MEC_SRV_SER_NAME}
    

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_003_BR
    [Documentation]
    ...    Check that the IUT responds with an error when incorrect parameters were sent by a MEC 
    ...    Application - supportedFeatures shall be present
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0"
    ...  "ETSI GS MEC 011 clause 9.1.2.2"
    ...  "ETSI GS MEC 011 clause 9.2.4.3.4"
    ...   "ETSI TS 129 222 V18.6.0 (2024-07) Table 8.2.4.2.2-1: Definition of type ServiceAPIDescription

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Publish new APIs   ${MEC_SRV_INSTANCE_ID}   serviceApiDescriptionBR
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_004_OK
    [Documentation]
    ...    Check that the IUT responds with a serviceAPIDescription 
    ...    when queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.2
    ...   ETSI GS MEC 011 clause 9.2.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get published APIs   ${MEC_SRV_INSTANCE_ID}   ${SERVICE_API_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescription
    Check Response Contains    ${response['body']}    apiId    ${SERVICE_API_ID}
 

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_004_NF_01
    [Documentation]
    ...    Check that the IUT responds with an error when 
    ...    applying a filter on an unknown apfId
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.2
    ...   ETSI GS MEC 011 clause 9.2.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get published APIs   ${NOT_EXISTING_MEC_SRV_INSTANCE_ID}   ${SERVICE_API_ID}
    Check HTTP Response Status Code Is    404

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_004_NF_02
    [Documentation]
    ...    Check that the IUT responds with an error
    ...    when applying a filter on an unknown serviceApiId
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.2
    ...   ETSI GS MEC 011 clause 9.2.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get published APIs   ${MEC_SRV_INSTANCE_ID}   ${UNKNOWN_SERVICE_API_ID}
    Check HTTP Response Status Code Is    404



TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_005_OK
    [Documentation]
    ...    Check that the IUT acknowledges the update of a CAPIF subscription request 
    ...    when requested by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Replace existing CAPIF subscription   ${MEC_SRV_INSTANCE_ID}   ${SUBSCRIPTION_ID}      eventSubscriptionUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    EventSubscription


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_005_NF
    [Documentation]
    ...    Check that the IUT acknowledges the update of a CAPIF subscription request 
    ...    when requested by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Replace existing CAPIF subscription   ${MEC_SRV_INSTANCE_ID}   ${UNKNOWN_SUBSCRIPTION_ID}     eventSubscriptionUpdate
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_006_OK
    [Documentation]
    ...   Check that the IUT changes the publishing of a new API 
    ...   when queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.3
    ...   ETSI GS MEC 011 clause 9.2.5.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Replace published APIs  ${MEC_SRV_INSTANCE_ID}   ${SERVICE_API_ID}   serviceApiDescriptionUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceApiDescription
    ${MEC_SRV_SER_NAME}    Get value entry from JSON file   ServiceApiDescription     apiName  
    Check Response Contains    ${response['body']}    apiId    ${MEC_SRV_SER_INSTANCE_ID}
    

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_006_NF
    [Documentation]
    ...   Check that the IUT responds with an error 
    ...    when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.3
    ...   ETSI GS MEC 011 clause 9.2.5.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Replace published APIs  ${MEC_SRV_INSTANCE_ID}   ${UNKNOWN_SERVICE_API_ID}   serviceApiDescriptionUpdate
    Check HTTP Response Status Code Is    404
    


    
TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_007_OK
        [Documentation]
    ...  Check that the IUT acknowledges the removing of a published API 
    ...    when queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.2
    ...   ETSI GS MEC 011 clause 9.2.5.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove published APIs  ${MEC_SRV_INSTANCE_ID}   ${SERVICE_API_ID}
    Check HTTP Response Status Code Is    204


       
TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_007_NF
        [Documentation]
    ...  Check that the IUT responds with an error 
    ...  when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.2.2
    ...   ETSI GS MEC 011 clause 9.2.5.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove published APIs  ${MEC_SRV_INSTANCE_ID}   ${UNKNOWN_SERVICE_API_ID}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_008_OK
    [Documentation]
    ...    Check that the IUT acknowledges the publishing of a new API when 
    ...    queried by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create CAPIF subscription   ${MEC_SRV_INSTANCE_ID}   eventSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    EventSubscription

  
TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_008_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create CAPIF subscription   ${UNKNOWN_MEC_SRV_INSTANCE_ID}   eventSubscription
    Check HTTP Response Status Code Is    404


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_009_OK
    [Documentation]
    ...   Check that the IUT acknowledges the update of a CAPIF subscription request 
    ...   when requested by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Replace existing CAPIF subscription   ${MEC_SRV_INSTANCE_ID}    ${SUBSCRIPTION_ID}      eventSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    EventSubscription


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_009_NF
    [Documentation]
    ...   Check that the IUT acknowledges the changes of a CAPIF subscription request 
    ...   when requested by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Replace existing CAPIF subscription    ${MEC_SRV_INSTANCE_ID}   ${UNKNOWN_SUBSCRIPTION_ID}    eventSubscription
    Check HTTP Response Status Code Is    404
 
 
TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_010_OK
    [Documentation]
    ...   Check that the IUT acknowledges the changes of a CAPIF subscription request 
    ...   when requested by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update existing CAPIF subscription     ${MEC_SRV_INSTANCE_ID}    ${SUBSCRIPTION_ID}     eventSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    EventSubscription


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_010_NF
    [Documentation]
    ...   Check that the IUT responds with an error 
    ...    when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update existing CAPIF subscription     ${MEC_SRV_INSTANCE_ID}    ${UNKNOWN_SUBSCRIPTION_ID}    eventSubscription
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_011_OK
    [Documentation]
    ...   Check that the IUT acknowledges the cancellation of a CAPIF subscription 
    ...   when requested by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Delete existing CAPIF subscription   ${MEC_SRV_INSTANCE_ID}  ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TC_MEC_MEC011_SRV_MEC_PROFILE_FOR_CAPIF_011_NF
    [Documentation]
    ...   Check that the IUT responds with an error 
    ...   when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...
    ...   Reference ETSI GS MEC 011 clause 9.0
    ...   ETSI GS MEC 011 clause 9.1.3.1
    ...   ETSI GS MEC 011 clause 9.2.6.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Delete existing CAPIF subscription   ${MEC_SRV_INSTANCE_ID}  ${UNKNOWN_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
    
*** Keywords ***
Get all services APIs
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/allServiceAPIs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Get services APIs with query params
    [Arguments]     ${query_params}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/allServiceAPIs?${query_params}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


##Published APIs management Keywords
Get published services APIs
    [Arguments]     ${MEC_SRV_SER_INSTANCE_ID}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

    
Publish new APIs
    [Arguments]     ${MEC_SRV_SER_INSTANCE_ID}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    
    Post    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
    
Get published APIs
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}     ${SERVICE_API_ID}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Post    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis/${SERVICE_API_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Replace published APIs wrong HTTP method
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}     ${SERVICE_API_ID}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Put    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis/${SERVICE_API_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Replace published APIs
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}     ${SERVICE_API_ID}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    
    Put    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis/${SERVICE_API_ID}     ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Update published APIs
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}     ${SERVICE_API_ID}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    
    Patch    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis/${SERVICE_API_ID}     ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
   
Remove published APIs
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}     ${SERVICE_API_ID}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    
    Delete    ${apiRoot}/${publApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/service-apis/${SERVICE_API_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


##CAPIF Subscription management Keywords
Create CAPIF subscription
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}   ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${capifSubApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/subscriptions   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   

Replace existing CAPIF subscription
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}  ${SUBSCRIPTION_ID}  ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${capifSubApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/subscriptions/${SUBSCRIPTION_ID}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Update existing CAPIF subscription
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}  ${SUBSCRIPTION_ID}  ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Patch    ${apiRoot}/${capifSubApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/subscriptions/${SUBSCRIPTION_ID}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Delete existing CAPIF subscription
    [Arguments]    ${MEC_SRV_SER_INSTANCE_ID}  ${SUBSCRIPTION_ID}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Delete    ${apiRoot}/${capifSubApiName}/${apiVersion}/${MEC_SRV_SER_INSTANCE_ID}/subscriptions/${SUBSCRIPTION_ID} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}