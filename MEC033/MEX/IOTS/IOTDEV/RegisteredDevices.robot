Y''[Documentation]   robot --outputdir ../../../outputs ./RegisteredDevices.robot
...    Test Suite to validate the Registered IOT Device (IOTDEV) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    

*** Test Cases ***
TP_MEC_MEC033_IOTS_IOTDEV_001_OK_01
    [Documentation]
    ...  Check that the IUT responds with the list of registered IoT devices when queried by a Service Consumer
    ...  ETSI GS MEC 033 V3.1.1, clause 7.3.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve all registered IOT Device information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  DeviceInfoList
    FOR  ${element}  IN  @{response['body']}
      Log  ${element}
      Should Be Equal As Strings    ${element}[imsi]     ${EXPECTED_IMSI}
      Should Be Equal As Strings    ${element}[supi]     ${EXPECTED_SUPI}
      Should Be Equal As Strings    ${element}[enabled]    ${False}
   END


TP_MEC_MEC033_IOTS_IOTDEV_001_OK_02
    [Documentation]
    ...  "Check that the IUT responds with the list of registered IoT devices when queried using a filter by a Service Consumer
    ...  ETSI GS MEC 033 V3.1.1, clause 7.3.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve all registered IOT Device information with filter or query param   ${FILTER_ON_ENABLE}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  DeviceInfoList
    FOR  ${element}  IN  @{response['body']}
      Should Be Equal As Strings    ${element}[enabled]    ${False}
   END


TP_MEC_MEC033_IOTS_IOTDEV_001_OK_03
    [Documentation]
    ...  "Check that the IUT responds with the list of registered IoT devices when queried by a Service Consumer filtering one field
    ...  ETSI GS MEC 033 V3.1.1, clause 7.3.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve all registered IOT Device information with filter or query param   ${DEVICE_ID_FIELDS}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  DeviceInfoList

TP_MEC_MEC033_IOTS_IOTDEV_001_OK_04
    [Documentation]
    ...  "Check that the IUT responds with the list of registered IoT devices when queried by a Service Consumer filtering one field
    ...  ETSI GS MEC 033 V3.1.1, clause 7.3.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve all registered IOT Device information with filter or query param   ${FIELDS_AND_FILTER}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  DeviceInfoList


TP_MEC_MEC033_IOTS_IOTDEV_001_OK_02
    [Documentation]
    ...  Check that the IUT registers the information of an IoT device when requested by a Service Consumer
    ...  ETSI GS MEC 033 V3.1.1, clause 7.3.3.4
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Register IOT Device information     DeviceInfo
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is  DeviceInfo
    ${file}=    Catenate    SEPARATOR=    jsons/    DeviceInfo    .json
    ${body}=    Get File    ${file}
    ${json}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal As Strings    ${response['body']['deviceId']}   ${json}[deviceId]
    Should Be Equal As Strings    ${response['body']['imsi']}         ${json}[imsi]
    Should Be Equal As Strings    ${response['body']['supi']}         ${json}[supi]
    Should Be Equal As Strings    ${response['body']['enabled']}      ${False}
    

       
TP_MEC_MEC033_IOTS_IOTDEV_001_BR_02
    [Documentation]
    ...  Check that the IUT returns an error when Service Consumer request to register an IoT device with incorrect parameters
    ...  ETSI GS MEC 033 V3.1.1, clause 7.3.3.4
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Register IOT Device information     DeviceInfoBR
    Check HTTP Response Status Code Is    400
                     

TP_MEC_MEC033_IOTS_IOTDEV_003_OK
    [Documentation]
    ...  Check that the IUT returns the IoT device information when requested by Service Consumer specifying the device identifier
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve specific registered IOT Device information  ${DEVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  DeviceInfo
    Should Be Equal As Strings    ${response['body']['deviceId']}  ${DEVICE_ID}
    

TP_MEC_MEC033_IOTS_IOTDEV_003_NF
    [Documentation]
    ...  Check that the IUT returns error when Service Consumer request to retrieve a not registered IoT device
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.1
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Retrieve specific registered IOT Device information  ${NOT_EXISTING_DEVICE_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_MEC033_IOTS_IOTDEV_004_OK
    [Documentation]
    ...  Check that the IUT returns an error when Service Consumer request to register an IoT device with incorrect parameters
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.2
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Update IOT Device information     ${DEVICE_ID}   DeviceInfoUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  DeviceInfo

TP_MEC_MEC033_IOTS_IOTDEV_004_NF
    [Documentation]
    ...  Check that the IUT returns an error when a Service Consumer requests to update a not registered IoT device
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.2
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Update IOT Device information     ${NOT_EXISTING_DEVICE_ID}   DeviceInfoUpdate
    Check HTTP Response Status Code Is    404


TP_MEC_MEC033_IOTS_IOTDEV_004_BR
    [Documentation]
    ...  Check that the IUT returns an error when a Service Consumer requests to update an existing IoT device with incorrect parameters
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.2
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Update IOT Device information     ${NOT_EXISTING_DEVICE_ID}   DeviceInfoUpdateBR
    Check HTTP Response Status Code Is    400


TP_MEC_MEC033_IOTS_IOTDEV_005_OK
    [Documentation]
    ...  Check that the IUT deregisters an IoT device information when requested by a Service Consumer specifying the IoT registered device identifier
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.5
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Deregister IOT Device information   ${DEVICE_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_MEC033_IOTS_IOTDEV_005_NF
    [Documentation]
    ...  "Check that the IUT returns an error when a Service Consumer requests to deregisters an IoT device using incorrect parameters
    ...  ETSI GS MEC 033 V3.1.1, clause 7.4.3.5
    ...  https://www.etsi.org/deliver/etsi_gs/MEC/001_099/033/03.01.01_60/gs_MEC033v030101p.pdf
    Deregister IOT Device information   ${NOT_EXISTING_DEVICE_ID}
    Check HTTP Response Status Code Is    404
                
############################################################################
############################################################################
############################################################################
      
*** Keywords ***
Retrieve all registered IOT Device information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/registered_devices
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Retrieve all registered IOT Device information with filter or query param
    [Arguments]     ${filter_and_query_param}  
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/registered_devices?${filter_and_query_param}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Retrieve specific registered IOT Device information  
    [Arguments]     ${deviceId}  
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/registered_devices/${deviceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Register IOT Device information
    [Arguments]     ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    POST   ${apiRoot}/${apiName}/${apiVersion}/registered_devices   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Update IOT Device information
    [Arguments]     ${deviceId}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    PUT   ${apiRoot}/${apiName}/${apiVersion}/registered_devices/${deviceId}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    

Deregister IOT Device information  
    [Arguments]     ${deviceId}  
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE   ${apiRoot}/${apiName}/${apiVersion}/registered_devices/${deviceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
#####