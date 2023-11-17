Y''[Documentation]   robot --outputdir ../../../outputs ./RegisteredIoTPlatform.robot
...    Test Suite to validate the Registered IOT Platform (IOTPLAT) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../../pics.txt
Resource    ../../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    

*** Test Cases ***
TP_MEC_MEC033_MEX_IOTS_IOTPLAT_001_OK
    [Documentation]
    ...  Check that the IUT responds with the list of registered IoT platforms
    ...  when queried by a Service Consumer
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve all registered IOT Platform information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  IotPlatformInfoList


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_002_OK
    [Documentation]
    ...  Check that the IUT registers the information of a new IoT platform
	...  when requested by a Service Consumer
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.4
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Register IOT Platform information     IotPlatformInfo
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   IotPlatformInfo


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_002_BR
    [Documentation]
    ...  Check that the IUT returns an error
	...  when Service Consumer request to register an IoT device with incorrect parameters
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.4
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Register IOT Platform information    IotPlatformInfoBR
    Check HTTP Response Status Code Is    400


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_003_OK
    [Documentation]
    ...  Check that the IUT returns the IoT platform information
    ...  when requested by Service Consumer specifying the IoT platform identifier
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve specific registered IOT Platform information    ${IOT_PLATFORM_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  IotPlatformInfo


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_003_NF
    [Documentation]
    ...  Check that the IUT returns the IoT platform information
    ...  when requested by Service Consumer specifying the IoT platform identifier
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve specific registered IOT Platform information    ${NOT_EXISTING_IOT_PLATFORM_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_004_OK
    [Documentation]
    ...  Check that the IUT updates the information about a registered IoT platform
	...  when requested by a Service Consumer
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.2
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Update registered IOT Platform information   ${IOT_PLATFORM_ID}  IotPlatformInfoUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   IotPlatformInfo

TP_MEC_MEC033_MEX_IOTS_IOTPLAT_004_NF
    [Documentation]
    ...  Check that the IUT returns an error
	...  when a Service Consumer requests to update a not registered IoT platform
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.2
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Update registered IOT Platform information   ${NOT_EXISTING_IOT_PLATFORM_ID}  IotPlatformInfoUpdate
    Check HTTP Response Status Code Is    404


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_005_OK
    [Documentation]
    ...  Check that the IUT deregisters an IoT platform information
	...  when requested by a Service Consumer specifying the registered IoT platform identifier
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.5
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Deregister IOT Platform information   ${IOT_PLATFORM_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_MEC033_MEX_IOTS_IOTPLAT_005_NF
    [Documentation]
    ...  Check that the IUT returns an error
	...  when a Service Consumer request to deregister an IoT platform using incorrect parameters
    ...  ETSI GS MEC 033 V3.1.1, clause 7.5.3.5
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Deregister IOT Platform information   ${NOT_EXISTING_IOT_PLATFORM_ID}
    Check HTTP Response Status Code Is    404
    
                    
############################################################################
      
*** Keywords ***
Retrieve all registered IOT Platform information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/registered_iot_platforms
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Retrieve specific registered IOT Platform information
    [Arguments]     ${registeredPlatformId}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/registered_iot_platforms/${registeredPlatformId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Update registered IOT Platform information
    [Arguments]     ${registeredPlatformId}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    PUT   ${apiRoot}/${apiName}/${apiVersion}/registered_iot_platforms/${registeredPlatformId}     ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Register IOT Platform information
    [Arguments]     ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    POST   ${apiRoot}/${apiName}/${apiVersion}/registered_iot_platforms   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   


 Deregister IOT Platform information
    [Arguments]     ${registeredPlatformId}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE   ${apiRoot}/${apiName}/${apiVersion}/registered_iot_platforms/${registeredPlatformId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    
