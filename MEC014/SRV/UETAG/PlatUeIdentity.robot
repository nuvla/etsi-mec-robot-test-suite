''[Documentation]   robot --outputdir ../../outputs ./PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Resource    resources/UEidentityAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
TC_MEC_MEC014_SRV_UETAG_001_OK
    [Documentation]  
    ...  Check that the IUT responds with the information on a UE Identity tag
    ...  when queried by a MEC Application
	...
	...  Reference ETSI GS MEC 014 3.1.1, clause 6.2.2,
    ...            ETSI GS MEC 014 3.1.1, clause 7.3.3.1
    ...    
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Get UE Identity Tag information    ${APP_INSTANCE_ID}      ${UE_IDENTITY_TAG} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ueIdentityTagInfo
    FOR    ${identityTag}    IN    @{response['body']['ueIdentityTags']}   
          ${ueidentity_tag}    Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[ueIdentityTag]    ${UE_IDENTITY_TAG} 
          ${registered_flag}   Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[state]    REGISTERED
        Exit For Loop If    ${ueidentity_tag} and ${registered_flag}
    END
    Should Be True    ${ueidentity_tag}   
    Should Be True    ${registered_flag}
    [TearDown]    Delete APP Instance  ${APP_INSTANCE_ID} 



TC_MEC_MEC014_SRV_UETAG_001_BR
    [Documentation]   
    ...  Check that the IUT responds with an error 
    ...  when a request with incorrect parameters is sent by a MEC Application
    
    ...  Reference  ETSI GS MEC 013 3.1.1 Clause 5.3.4,
    ...             ETSI GS MEC 013 3.1.1 Clause 6.3.9,
    ...             ETSI GS MEC 013 3.1.1 Clause 6.4.9,
    ...             ETSI GS MEC 013 3.1.1 Clause 7.14.3.4
    
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Get UE Identity Tag information using bad parameters    ${APP_INSTANCE_ID}      ${UE_IDENTITY_TAG} 
    Check HTTP Response Status Code Is    400
    [TearDown]    Delete APP Instance  ${APP_INSTANCE_ID} 



TC_MEC_MEC014_SRV_UETAG_001_NF
    [Documentation]   Request UE Identity Tag information using non-existent application instance
    ...  Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V3.1.1, clause 7.3.3.1
    [Setup]    Delete APP Instance  ${NON_EXISTENT_APP_INSTANCE_ID}
    Get UE Identity Tag information    ${NON_EXISTENT_APP_INSTANCE_ID}      ${UE_IDENTITY_TAG}
    Check HTTP Response Status Code Is    404


TC_MEC_MEC014_SRV_UETAG_002_OK
    [Documentation]   Register an UE Identity Tag
    ...  Check that the IUT registers a tag (representing a UE) or a list of tags when commanded by a MEC Application
    
    ...  Reference ETSI GS MEC 014 3.1.1, clause 6.2.2
    ...            ETSI GS MEC 014 V3.1.1, clause 7.3.3.2
   
    [Setup]  Create new App Instance and Check User Identity Tag unregistered state   CreateAppInstanceRequest    ${APP_INSTANCE_ID}    UeIdentityTag 
    Update an UE Identity Tag     ${APP_INSTANCE_ID}   IdentityTag
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    UeIdentityTagInfo
    FOR    ${identityTag}    IN    @{response['body']['ueIdentityTags']}   
        ${ueidentity_tag}    Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[ueIdentityTag]    ${UE_IDENTITY_TAG} 
        ${registered_flag}   Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[state]    REGISTERED
  
        Exit For Loop If    ${ueidentity_tag} and ${registered_flag}
    END
    Should Be True    ${ueidentity_tag}   
    Should Be True    ${registered_flag}
    [TearDown]    Delete APP Instance  ${APP_INSTANCE_ID} 


TC_MEC_MEC014_SRV_UETAG_002_BR
    [Documentation]   Register an UE Identity Tag using invalid state
    ...  Check that the IUT responds with an error when an unauthorised request is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 3.1.1, clause 6.2.2,
    ...            ETSI GS MEC 014 3.1.1, clause 7.3.3.2
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Update an UE Identity Tag     ${APP_INSTANCE_ID}   IdentityTagBR  
    Check HTTP Response Status Code Is    400
    [TearDown]    Delete APP Instance  ${APP_INSTANCE_ID} 


TC_MEC_MEC014_SRV_UETAG_002_NF
    [Documentation]   Register an UE Identity Tag using invalid state
    ...  Check that the IUT responds with an error when an unauthorised request is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 3.1.1, clause 7.3.3.2
    [Setup]  Delete APP Instance  ${NON_EXISTENT_APP_INSTANCE_ID} 
    Update an UE Identity Tag     ${NON_EXISTENT_APP_INSTANCE_ID}   IdentityTag  
    Check HTTP Response Status Code Is    404
    

TC_MEC_MEC014_SRV_UETAG_002_PF
    [Documentation]   Unregister an UE Identity Tag already in unregistered state
    ...  Check that the IUT responds with an error when
    ...  a request sent by a MEC Application doesn't comply with a required condition
    ...  Reference ETSI GS MEC 014 V3.1.1, clause 7.3.3.2
    [Setup]  Create new App Instance  CreateAppInstanceRequest
    Update an UE Identity Tag     ${APP_INSTANCE_ID}   IdentityTagPF  
    Check HTTP Response Status Code Is    412
    [TearDown]    Delete APP Instance  ${APP_INSTANCE_ID} 



*** Keywords ***
Create new App Instance
    [Arguments]    ${content}
    Log    Creating a new app package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    POST    http://${APP_INST_HOST}:${APP_INST_PORT}/${apiRoot_APP_INST}/${apiName_APP_INST}/${apiVersion_APP_INST}/app_instances    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable    ${APP_INSTANCE_ID}    ${response['body']['id']} 


Create new App Instance and Check User Identity Tag unregistered state 
   [Arguments]    ${content}    ${app_instance_id}      ${ue_identity_tag}  
    Create new App Instance   ${content}
    Get UE Identity Tag information    ${APP_INSTANCE_ID}     ${ue_identity_tag}  
    FOR    ${identityTag}    IN    @{response['body']['ueIdentityTags']}   
         ${ueidentity_tag}    Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[ueIdentityTag]    ${ue_identity_tag} 
         ${registered_flag}   Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[state]    UNREGISTERED
        Exit For Loop If    ${ueidentity_tag} and ${registered_flag}
    END
    Should Be True    ${ueidentity_tag}   
    Should Be True    ${registered_flag}
        
Delete APP Instance
    [Arguments]    ${app_instance_id}
    Log    Get single App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE    http://${APP_INST_HOST}:${APP_INST_PORT}/${apiRoot_APP_INST}/${apiName_APP_INST}/${apiVersion_APP_INST}/app_instances${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

   
Get UE Identity Tag information
    [Arguments]    ${app_instance_id}     ${ue_identity_tag}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /${apiName}/${apiVersion}/${app_instance_id}/ue_identity_tag_info?ueIdentityTag=${ue_identity_tag}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get UE Identity Tag information using bad parameters
    [Arguments]    ${app_instance_id}    ${ue_identity_tag}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /${apiName}/${apiVersion}/${app_instance_id}/ue_identity_tag_info?ueIdentityTagERROR=${ue_identity_tag}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check User Identity Tag unregistered state    
    [Arguments]    ${app_instance_id}     ${ue_identity_tag}  
    Get UE Identity Tag information    ${app_instance_id}     ${ue_identity_tag}  
    FOR    ${identityTag}    IN    @{response['body']['ueIdentityTags']}   
         ${ueidentity_tag}    Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[ueIdentityTag]    ${ue_identity_tag} 
         ${registered_flag}   Run Keyword And Return Status  Should Be Equal As Strings  ${identityTag}[state]    UNREGISTERED
        Exit For Loop If    ${ueidentity_tag} and ${registered_flag}
    END
    Should Be True    ${ueidentity_tag}   
    Should Be True    ${registered_flag}
      


Update an UE Identity Tag
    [Arguments]    ${app_instance_id}     ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}    
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    /${apiName}/${apiVersion}/${app_instance_id}/ue_identity_tag_info    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


