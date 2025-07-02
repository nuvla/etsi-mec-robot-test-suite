*** Settings ***

Documentation
...    A test suite for validating Registration applications (REGAPPS) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables.txt
#Resource    environment/variables_sandbox.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false

Default Tags    TC_MEC_SRV_REGAPPS



*** Test Cases ***
TC_MEC_MEC011_SRV_REGAPPS_001_OK_01
    [Documentation]
    ...    Check that the IUT acknowledges the registration 
    ...    by a MEC Application to the MEC platform
    ...
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfo 
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location 
    Check HTTP Response Body Json Schema Is    AppInfo
    Check Response Contains    ${response['body']}    appName    ${APP_NAME}
    [TearDown]   Delete MEC application instance profile    ${response['body']['appInstanceId']}
    

TC_MEC_MEC011_SRV_REGAPPS_001_OK_02
    [Documentation]
    ...    Check that the IUT acknowledges the registration 
    ...    by a MEC Application to the MEC platform
    ...
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfo2 
    ${APP_INSTANCE_ID_REQ}    Get value entry from JSON file   AppInfo2     appInstanceId
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    AppInfo
    Check Response Contains    ${response['body']}    appName    ${APP_NAME}
    Check Response Contains    ${response['body']}    appInstanceId    ${APP_INSTANCE_ID_REQ}
   [TearDown]   Delete MEC application instance profile    ${APP_INSTANCE_ID_REQ}
    

    
TC_MEC_MEC011_SRV_REGAPPS_001_OK_03
    [Documentation]
    ...    Check that the IUT acknowledges the registration 
    ...    by a MEC Application to the MEC platform
    ...
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfo3 
    ${APP_INSTANCE_ID_REQ}    Get value entry from JSON file   AppInfo3     appInstanceId
    ${APPD_NAME_REQ}    Get value entry from JSON file   AppInfo3     appName
    ${APPD_ID_REQ}    Get value entry from JSON file   AppInfo3     appDId
    
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    AppInfo
    Check Response Contains    ${response['body']}    appName    ${APP_NAME}
    Check Response Contains    ${response['body']}    appInstanceId    ${APP_INSTANCE_ID_REQ}
    Check Response Contains    ${response['body']}    appDId    ${APPD_ID_REQ}
    [TearDown]   Delete MEC application instance profile    ${APP_INSTANCE_ID_REQ}
  

TC_MEC_MEC011_SRV_REGAPPS_001_BR_01
    [Documentation]
    ...    Check that the IUT responds with an error message when the IUT received a registration with
    ...    missing fields from a MEC Application instantiated by the MEC platform
    ...
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfoBR1 
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC011_SRV_REGAPPS_001_BR_02
    [Documentation]
    ...    Check that the IUT responds with an error message 
    ...    when the IUT received by a MEC Application registration with missing endpoint
    ...
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfoBR2 
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC011_SRV_REGAPPS_001_BR_03
    [Documentation]
    ...    Check that the IUT responds with an error message when the IUT received by a 
    ...    MEC Application registration with unexpected appServiceRequired
    ...    
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfoBR3 
    Check HTTP Response Status Code Is    400
    

TC_MEC_MEC011_SRV_REGAPPS_001_BR_04
    [Documentation]
    ...    Check that the IUT responds with an error message when the IUT received by a 
    ...    MEC Application registration with unexpected appServiceRequired
    ...    
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfoBR4
    Check HTTP Response Status Code Is    400


TC_MEC_MEC011_SRV_REGAPPS_001_BR_05
    [Documentation]
    ...    Check that the IUT responds with an error message when the IUT received by a 
    ...    MEC Application registration with unexpected appFeatureRequired
    ...    
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfoBR5
    Check HTTP Response Status Code Is    400


TC_MEC_MEC011_SRV_REGAPPS_001_BR_06
    [Documentation]
    ...    Check that the IUT responds with an error message when the IUT received by a 
    ...    MEC Application registration with unexpected appFeatureOptional
    ...    
    ...    Reference  "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...               "ETSI GS MEC 011 3.3.1, clause 7.1.2.6"
    ...               "ETSI GS MEC 011 3.3.1, clause 7.2.13.3.4"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create a new MEC application instance profile   AppInfoBR6
    Check HTTP Response Status Code Is    400
    


TC_MEC_MEC011_SRV_REGAPPS_002_OK
    [Documentation]
    ...    Check that the IUT responds with the AppInfo description
    ...     when queried by a MEC Application
    ...    
    ...    Reference   "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...                "ETSI GS MEC 011 3.3.1, clause 7.1.2.6",
    ...                "ETSI GS MEC 011 3.3.1, clause 7.2.14.3.1"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a new MEC application instance profile   AppInfo 
    Set Suite Variable  ${APP_INSTANCE_ID}    ${response['body']['appInstanceId']} 
    Get MEC application instance profile   ${APP_INSTANCE_ID} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppInfo
    Check Response Contains    ${response['body']}    appInstanceId    ${APP_INSTANCE_ID}
    [TearDown]   Delete MEC application instance profile   ${APP_INSTANCE_ID}

TC_MEC_MEC011_SRV_REGAPPS_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error 
    ...    when it receives a request for returning an AppInfo with a wrong ID
    ...    
    ...    Reference   "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...                "ETSI GS MEC 011 3.3.1, clause 7.1.2.6",
    ...                "ETSI GS MEC 011 3.3.1, clause 7.2.14.3.1"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Delete MEC application instance profile   ${NOT_EXISTING_APP_INSTANCE_ID}
    Get MEC application instance profile   ${NOT_EXISTING_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    404
        
            

TC_MEC_MEC011_SRV_REGAPPS_003_OK
    [Documentation]
    ...    Check that the IUT responds with 204 No Content 
    ...    when queried to update MEC Application registration
    ...
    ...    Reference    "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...                 "ETSI GS MEC 011 3.3.1, clause 7.1.2.6",
    ...                 "ETSI GS MEC 011 3.3.1, clause 7.2.14.3.2"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a new MEC application instance profile   AppInfo 
    Set Suite Variable  ${APP_INSTANCE_ID}    ${response['body']['appInstanceId']} 
    Update MEC application registration  ${APP_INSTANCE_ID}    AppInfoUpdate
    Check HTTP Response Status Code Is    204
    [TearDown]   Delete MEC application instance profile   ${APP_INSTANCE_ID}
    


TC_MEC_MEC011_SRV_REGAPPS_003_NF
    [Documentation]
    ...    Check that the IUT responds with 204 No Content 
    ...    when queried to update MEC Application registration
    ...
    ...    Reference  ETSI GS MEC 011 3.3.1, clause 7.2.14.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Delete MEC application instance profile   ${NOT_EXISTING_APP_INSTANCE_ID}
    Update MEC application registration  ${NOT_EXISTING_APP_INSTANCE_ID}    AppInfoUpdate
    Check HTTP Response Status Code Is    404



TC_MEC_MEC011_SRV_REGAPPS_004_OK
    [Documentation]
    ...    Check that the IUT responds with 204 No Content
    ...    when queried to delete an existing MEC Application registration
    ...    
    ...    Reference        "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...                     "ETSI GS MEC 011 3.3.1, clause 7.1.2.6",
    ...                     "ETSI GS MEC 011 3.3.1, clause 7.2.14.3.5"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Create a new MEC application instance profile   AppInfo 
    Set Suite Variable  ${APP_INSTANCE_ID}    ${response['body']['appInstanceId']} 
    Delete MEC application instance profile   ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    204
    


TC_MEC_MEC011_SRV_REGAPPS_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when queried to 
    ...    delete an unknown MEC Application registration
    ...    
    ...    Reference        "ETSI GS MEC 011 3.3.1, clause 5.2.13",
    ...                     "ETSI GS MEC 011 3.3.1, clause 7.1.2.6",
    ...                     "ETSI GS MEC 011 3.3.1, clause 7.2.14.3.5"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    [Setup]   Delete MEC application instance profile   ${NOT_EXISTING_APP_INSTANCE_ID}
    Delete MEC application instance profile   ${NOT_EXISTING_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    404
    



*** Keywords ***
Create a new MEC application instance profile
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/registrations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get MEC application instance profile
    [Arguments]    ${app_instance_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/registrations/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    



Update MEC application registration
    [Arguments]    ${app_instance_id}    ${content}  
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/registrations/${app_instance_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Delete MEC application instance profile
    [Arguments]    ${app_instance_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/registrations/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    