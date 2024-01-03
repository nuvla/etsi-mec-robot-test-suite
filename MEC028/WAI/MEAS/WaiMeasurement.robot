''[Documentation]   robot --outputdir ../../outputs ./WaiMeasurement.robot
...    Test Suite to validate WLAN Measurement API (MEAS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     Collections
Library     String
Library     OperatingSystem
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false


*** Test Cases ***
TC_MEC_MEC028_SRV_WAI_012_OK
    [Documentation] 
    ...  Check that the IUT responds with a list of measurement 
    ...  configurations available from the WLAN Access Information Service
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.7.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList
    [Setup]  Create a new measurement configuration    ${MEAS_ID} 

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a list of list of measurement configurations
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MeasurementConfigLinkList

    [TearDown]  Delete a specified measurement configuration    ${MEAS_ID}
    
TC_MEC_MEC028_SRV_WAI_013_OK
    [Documentation] 
    ...  Check that the IUT responds with a new measurement configuration
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.7.3.4
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfig
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Create a new measurement configuration  ${MEAS_ID}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   MeasurementConfigLinkList
    Should Be Equal As Strings  ${response['body']['staIdentity']['staId']}     ${STA_ID}
    Should Be Equal As Strings  ${response['body']['measurementId']}    ${MEAS_ID}
    Should Be Equal As Strings  ${response['body']['measurementInfo']}    ${response['body']['measurementInfo']}

TC_MEC_MEC028_SRV_WAI_013_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when an invalid request is sent
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.7.3.4
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfig
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Create a new measurement configuration from file  MeasurementConfigError
    Check HTTP Response Status Code Is    400   

TC_MEC_MEC028_SRV_WAI_014_OK
    [Documentation] 
    ...  Check that the IUT responds with the specified measurement configuration
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.8.3.1
    ...  "https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList"
    
    [Setup]  Create a new measurement configuration    ${MEAS_ID} 

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1

    Retrieve a specified measurement configuration   ${MEAS_ID}
    Check HTTP Response Body Json Schema Is   MeasurementConfig
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings  ${response['body']['measurementId']}    ${MEAS_ID}

    [TearDown]  Delete a specified measurement configuration    ${MEAS_ID}
   
TC_MEC_MEC028_SRV_WAI_014_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when an invalid request is sent
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.8.3.1
    ...  "https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList"
    
    [Setup]  Delete a specified measurement configuration    ${INVALID_MEASUREMENT_CONFIG_ID}

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a specified measurement configuration   ${INVALID_MEASUREMENT_CONFIG_ID}
    Check HTTP Response Status Code Is    404
  

TC_MEC_MEC028_SRV_WAI_015_OK
    [Documentation] 
    ...  Check that the IUT responds with the modified measurement configuration
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.8.3.2
    ...  "https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList"
    
    [Setup]  Create a new measurement configuration    ${MEAS_ID} 

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1  
    ${path}    Catenate    SEPARATOR=      jsons/     MeasurementConfigUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json 
    Update a specified measurement configuration   ${MEAS_ID}   ${body}
    Check HTTP Response Status Code Is    200
    Should Be Equal As Strings  ${response['body']['staIdentity']['staId']}    ${json_object['staIdentity']['staId']}
    Should Be Equal As Strings  ${response['body']['measurementId']}    ${MEAS_ID}
    Should Be Equal As Strings  ${response['body']['measurementInfo']}    ${json_object['measurementInfo']}

    [TearDown]  Delete a specified measurement configuration    ${MEAS_ID}



TC_MEC_MEC028_SRV_WAI_015_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when an invalid request is sent
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.8.3.2
    ...  "https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList"
    
    [Setup]  Create a new measurement configuration    ${MEAS_ID} 

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Update a specified measurement configuration   ${INVALID_MEASUREMENT_CONFIG_ID}   MeasurementConfigUpdate.json
    Check HTTP Response Status Code Is    404

    [TearDown]  Delete a specified measurement configuration    ${MEAS_ID}
    

TC_MEC_MEC028_SRV_WAI_016_OK
    [Documentation] 
    ...  Check that the IUT responds with with 204 when requested to delete the specified measurement configuration
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.8.3.5
    ...  "https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList"
    
    [Setup]  Create a new measurement configuration    ${MEAS_ID} 

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Delete a specified measurement configuration   ${MEAS_ID} 
    Check HTTP Response Status Code Is    204
    

TC_MEC_MEC028_SRV_WAI_016_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when an invalid request is sent
    ...  Reference "ETSI GS MEC 028 2.3.1, clause 7.8.3.5
    ...  "https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.3.1/WlanInformationApi.yaml#/schemas/MeasurementConfigLinkList"
    
    [Setup]  Delete a specified measurement configuration    ${INVALID_MEASUREMENT_CONFIG_ID}

    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Delete a specified measurement configuration   ${INVALID_MEASUREMENT_CONFIG_ID} 
    Check HTTP Response Status Code Is    404
    
  
*** Keywords ***
Retrieve a list of list of measurement configurations
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/measurements
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Create a new measurement configuration
    [Arguments]   ${measurementId}
    
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     MeasurementConfig.json
    ${body}    Get File    ${path}
    ${json_data}=    Evaluate    json.loads('''${body}''')    json
    Set To Dictionary    ${json_data}    measurementId=${measurementId}
    ${modified_json_string}=    Evaluate    json.dumps(${json_data})
    POST     ${apiRoot}/${apiName}/${apiVersion}/measurements   ${modified_json_string}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Create a new measurement configuration from file
    [Arguments]   ${filename}
    
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${filename}    .json
    ${body}    Get File    ${path}
    ${json_data}=    Evaluate    json.loads('''${body}''')    json
    POST     ${apiRoot}/${apiName}/${apiVersion}/measurements   ${json_data}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Retrieve a specified measurement configuration
    [Arguments]   ${MEAS_CONF_ID}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/measurements/${MEAS_CONF_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Update a specified measurement configuration
    [Arguments]   ${MEAS_CONF_ID}  ${content}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    PUT     ${apiRoot}/${apiName}/${apiVersion}/measurements/${MEAS_CONF_ID}    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Delete a specified measurement configuration
    [Arguments]   ${MEAS_CONF_ID}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    DELETE     ${apiRoot}/${apiName}/${apiVersion}/measurements/${MEAS_CONF_ID} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
