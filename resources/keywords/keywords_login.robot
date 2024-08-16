*** Keywords ***
Perform Login
    [Documentation]    Login the user using the credentials provided.
    [Arguments]    ${username}    ${password}
    Click    ${page_sign_in['div_username']}
    Click    "${username}"
    Click    ${page_sign_in['div_password']}
    Click    "${password}"
    Click    ${page_sign_in['btn_login']}
