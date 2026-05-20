*** Settings ***
Library    JSONLibrary
Library    BuiltIn
Library    OperatingSystem

*** Variables ***
${response}
${SCHEMA_BASE_DIR}    ${CURDIR}/schemas
${JSON_BASE_DIR}      ${CURDIR}/jsons


*** Keywords ***
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}
    Should Be Equal    ${response['status']}    ${status}
    Log    Status code validated

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${SCHEMA_BASE_DIR}${/}    ${input}    .schema.json
    Validate Json By Schema File    ${response['body']}    ${schema}
    Log    Json Schema Validation OK

Should Be Present In Json List
    [Arguments]     ${expr}   ${json_field}   ${json_value}
    Log    Check if ${json_field} is present in ${expr} with the value ${json_value}
    FOR  ${item}  IN  @{expr}
      ${are_equal}=    Should Be Equal As Strings    ${item["${json_field}"]}    ${json_value}
      Exit For Loop If    ${are_equal}
    END
    Log    Item found ${item}
    RETURN    ${item}
    
Should Be Present In Json
    [Arguments]     ${expr}   ${json_field}   ${json_value}
    Log    Check if ${json_field} is present in ${expr} with the value ${json_value}
    Should Be Equal As Strings    ${expr}[${json_field}]    ${json_value}

Check Response Contains
    [Arguments]    ${source}    ${parameter}    ${value}
    Should Be Present In Json    ${source}    ${parameter}    ${value}
    
Check Result Contains
    [Arguments]    ${source}    ${parameter}    ${value}
    Should Be Present In Json List    ${source}    ${parameter}    ${value}

Check ProblemDetails
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}
    Should Be Equal    ${response['body']['problemDetails']['status']}    ${status}
    Log    ProblemDetails Status code validated
    
Check HTTP Response Header Contains
    [Arguments]    ${HEADER_TOCHECK}
    Should Contain     ${response['headers']}    ${HEADER_TOCHECK}
    Log    Header is present

Check HTTP Response Body is Empty
    Should Be Empty    ${response['body']}   
    Log    Body is empty
    
Check HTTP Response Contain Header with value
    [Arguments]    ${HEADER_TOCHECK}    ${VALUE}
    Check HTTP Response Header Contains    ${HEADER_TOCHECK}
    Should Be Equal As Strings    ${value}    ${response['headers']['Content-Type']}    

Get value entry from JSON file 
    [Arguments]       ${filename}   ${key}
    ${file}=    Catenate    SEPARATOR=    ${JSON_BASE_DIR}${/}    ${filename}    .json
    ${body}=    Get File    ${file}
    ${data}=   Evaluate    ${body}
    ${value_key}    Set Variable   ${data}[${key}]
    RETURN   ${value_key}

        