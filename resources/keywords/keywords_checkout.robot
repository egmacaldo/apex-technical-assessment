*** Keywords ***
Assert Item Brand And Quantity in Checkout
    [Documentation]    Validates if the item has the correct description.
    [Arguments]    ${item_name}    ${item_desc}    ${quantity}
    IF    'iPhone' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    Apple\n${quantity}
    ELSE IF    'Galaxy' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    Samsung\n${quantity}
    ELSE IF    'Pixel' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    Google\n${quantity}
    ELSE IF    'One Plus' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    OnePlus\n${quantity}
    END

Generate Random User Checkout Data
    [Documentation]    Generates input data for the user checkout process.
    ${first_name}    Faker.FirstName
    ${last_name}    Faker.LastName
    ${address}    Faker.Address
    ${province}    Faker.State
    ${postal_code}    Faker.PostalCode
    &{checkout_user_data}    Create Dictionary
    ...    first_name=${first_name}
    ...    last_name=${last_name}
    ...    address=${address}
    ...    province=${province}
    ...    postal_code=${postal_code}
    Set Test Variable    &{checkout_user_data}

Fillout User Data
    [Documentation]    Inputs all required information in the checkout page.
    [Arguments]    ${first_name}    ${last_name}    ${address}    ${province}    ${postal_code}
    Fill Text    ${page_checkout['input_first_name']}    ${first_name}
    Fill Text    ${page_checkout['input_last_name']}    ${last_name}
    Fill Text    ${page_checkout['input_address']}    ${address}
    Fill Text    ${page_checkout['input_province']}    ${province}
    Fill Text    ${page_checkout['input_postal_code']}    ${postal_code}
