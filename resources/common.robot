*** Settings ***
Library         Browser
Library         DateTime
Library         FakerLibrary    AS    Faker
Library         String
Variables       ${EXECDIR}${/}config${/}base_urls.py
Resource        ${EXECDIR}${/}config${/}browser_config.resource
Resource        ${EXECDIR}${/}config${/}urls.resource
Variables       ${EXECDIR}${/}data${/}expected${/}expected_home.py
Variables       ${EXECDIR}${/}data${/}inputs${/}inputs_login.py
Resource        ${EXECDIR}${/}resources${/}keywords${/}keywords_checkout.robot
Resource        ${EXECDIR}${/}resources${/}keywords${/}keywords_home.robot
Resource        ${EXECDIR}${/}resources${/}keywords${/}keywords_login.robot
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}components${/}component_headers.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}components${/}component_shopping_cart.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}pages${/}page_checkout.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}pages${/}page_confirmation.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}pages${/}page_favourites.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}pages${/}page_home.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}pages${/}page_orders.py
Variables       ${EXECDIR}${/}resources${/}pageobjects${/}pages${/}page_sign_in.py


*** Keywords ***
Navigate to the Home Page
    [Documentation]    Keyword to be used as setup for navigating to the home page.
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page    ${base_urls['prod']}

Sign In User
    [Documentation]    Setup keyword for logging in a user.
    [Arguments]    ${valid_username}    ${valid_password}
    Navigate to the Home Page
    Click    ${page_home['link_sign_in']}
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_SIGN_IN}
    Perform Login    ${valid_username}    ${valid_password}
    
Element Should Be Visible
    [Documentation]    Validates that the element is visible.
    [Arguments]    ${locator}    ${strict}=${True}
    IF    ${strict}==${True}
        Get Element States    ${locator}    contains    visible
        ...    message=Element with locator '${locator}' is not visible.
    ELSE IF    ${strict}==${False}
        Set Strict Mode    False
        Get Element States    ${locator}    contains    visible
        ...    message=Element with locator '${locator}' is not visible.
        Set Strict Mode    True
    END

Element Should Not Be Visible
    [Documentation]    Validates that the element is NOT visible.
    [Arguments]    ${locator}    ${strict}=${True}
    IF    ${strict}==${True}
        Get Element States    ${locator}    contains    detached
        ...    message=Element with locator '${locator}' is visible.
    ELSE IF    ${strict}==${False}
        Set Strict Mode    False
        Get Element States    ${locator}    contains    detached
        ...    message=Element with locator '${locator}' is visible.
        Set Strict Mode    True
    END

Dynamic Element Should Be Visible
    [Documentation]    Validates that the dynamic element is visible.
    [Arguments]    ${base_locator}    ${dynamic_value}    ${strict}=${True}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    IF    ${strict}==${True}
        Get Element States    ${element}    contains    visible
        ...    message=Element with locator '${element}' is not visible.
    ELSE IF    ${strict}==${False}
        Set Strict Mode    False
        Get Element States    ${element}    contains    visible
        ...    message=Element with locator '${element}' is not visible.
        Set Strict Mode    True
    END

Dynamic Element Should Not Be Visible
    [Documentation]    Validates that the dynamic element is NOT visible.
    [Arguments]    ${base_locator}    ${dynamic_value}    ${strict}=${True}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    IF    ${strict}==${True}
        Get Element States    ${element}    contains    detached
        ...    message=Element with locator '${element}' is visible.
    ELSE IF    ${strict}==${False}
        Set Strict Mode    False
        Get Element States    ${element}    contains    detached
        ...    message=Element with locator '${element}' is visible.
        Set Strict Mode    True
    END

Generate Random Number From Range
    [Documentation]    Returns a random number from the given range.
    [Arguments]    ${start}    ${end}
    ${random_number}    Evaluate    random.randrange(${start}, ${end})
    RETURN    ${random_number}

Remove Whitespaces from String
    [Documentation]    Removes all whitespaces from the given string.
    [Arguments]    ${string}
    ${removed_whitespaces}    Evaluate    '${string}'.replace(" ", "")
    RETURN    ${removed_whitespaces}

Remove Non-numeric Characters from String
    [Documentation]    Removes all non-numeric characters from the given string.
    [Arguments]    ${string}
    ${removed_non-numeric_characters}    Remove String Using Regexp    ${string}    [^0-9]
    RETURN    ${removed_non-numeric_characters}

Click Dynamic Element
    [Documentation]    Creates a new locator based on a dynamic locator and then clicks the element.
    [Arguments]    ${base_locator}    ${dynamic_value}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    Click    ${element}

Element Text Should Be
    [Documentation]    Validates the text of the element
    [Arguments]    ${locator}    ${text}
    Get Text    ${locator}    ==    ${text}

Get Dynamic Element Text
    [Documentation]    Returns the text of the dynamic element.
    [Arguments]    ${base_locator}    ${dynamic_value}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    ${text}    Get Text    ${element}
    RETURN    ${text}

Dynamic Element Text Should Be
    [Documentation]    Assert the text of the dynamic element.
    [Arguments]    ${base_locator}    ${dynamic_value}    ${text}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    Get Text    ${element}    ==    ${text}

Dynamic Element Text Should Contain
    [Documentation]    Assert the text of the dynamic element.
    [Arguments]    ${base_locator}    ${dynamic_value}    ${text}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    Get Text    ${element}    contains    ${text}

Get Dynamic Element Attribute
    [Documentation]    Returns the attribute of the dynamic element
    [Arguments]    ${base_locator}    ${dynamic_value}    ${attribute}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    ${attribute}    Get Attribute    ${element}    ${attribute}
    RETURN    ${attribute}

Dynamic Element Attribute Value Should Be
    [Documentation]    Validates the attribute of the dynamic element
    [Arguments]    ${base_locator}    ${dynamic_value}    ${attribute}    ${expected_attribute_value}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    Get Attribute    ${element}    ${attribute}    ==    ${expected_attribute_value}

Page URL Should Be
    [Documentation]    Asserts the current URL.
    [Arguments]    ${expected_url}
    Get Url    ==    ${expected_url}

Click Dynamic Element Multiple Times
    [Documentation]    Creates a new locator based on a dynamic locator and then clicks the element according to count.
    [Arguments]    ${base_locator}    ${dynamic_value}    ${count}
    ${element}    Format String    ${base_locator}    ${dynamic_value}
    Click With Options    ${element}    clickCount=${count}

Element Count Should Be
    [Documentation]    Asserts the number of elements matched by the locator in the page.
    [Arguments]    ${locator}    ${count}
    Get Element Count    ${locator}    ==    ${count}