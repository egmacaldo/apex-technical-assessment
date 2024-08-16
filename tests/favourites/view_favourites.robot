*** Settings ***
Resource        ${EXECDIR}${/}resources${/}common.robot

Suite Setup     New Browser   ${BROWSER}    headless=${HEADLESS}
Test Setup      Sign In User    ${inputs_login['valid_credentials']['username']}
...            ${inputs_login['valid_credentials']['password']}


*** Test Cases ***
Add Phone to Favourites and View Favourites List
    [Documentation]    Verify that a signed-in user can add a phone to their favorites list
    ...    and view the list correctly.
    # Verify user has no favourites
    Click    ${component_headers['link_favourites']}
    Element Should Be Visible    "0 Product(s) found."
    # Navigate to the homepage to add a favourite item
    Go To    ${base_urls['prod']}
    Element Should Be Visible    ${page_home['div_all_items']}    strict=${False}
    ${products_number}    Get Element Count    ${page_home['div_all_items']}
    # Select a random product from the available items
    ${product_id}    Generate Random Number From Range    1    ${products_number}
    # Obtain the selected product's information
    ${product_img_src}    Get Dynamic Element Attribute    ${page_home['img_product']}    ${product_id}    src
    ${product_name}    Get Dynamic Element Text    ${page_home['label_product_name']}    ${product_id}
    ${product_price}    Get Dynamic Element Text    ${page_home['div_product_price']}    ${product_id}
    ${product_price}    Remove Whitespaces from String    ${product_price}
    ${product_installment_price}    Get Dynamic Element Text
    ...    ${page_home['div_product_installment_price']}
    ...    ${product_id}
    # Add the item to favourites list
    Click Dynamic Element    ${page_home['btn_add_to_favourites']}    ${product_id}
    # Navigate to the favourites page to assert that the item is in the favorites list
    Click    ${component_headers['link_favourites']}
    Element Should Be Visible    "1 Product(s) found."
    Element Should Be Visible    ${page_home['div_all_items']}    strict=${False}
    ${products_number}    Get Element Count    ${page_home['div_all_items']}
    Should Be Equal As Numbers    ${products_number}    1
    Dynamic Element Should Be Visible    ${page_favourites['btn_add_to_favourites']}    ${product_id}
    Dynamic Element Should Be Visible    ${page_favourites['btn_add_to_cart']}    ${product_id}
    Dynamic Element Should Be Visible    ${page_favourites['label_product_name']}    ${product_id}
    Dynamic Element Text Should Be    ${page_favourites['label_product_name']}    ${product_id}    ${product_name}
    Dynamic Element Should Be Visible    ${page_favourites['img_product']}    ${product_id}
    Dynamic Element Attribute Value Should Be    ${page_favourites['img_product']}    ${product_id}    src    ${product_img_src}
    Dynamic Element Should Be Visible    ${page_favourites['div_product_price']}    ${product_id}
    Dynamic Element Text Should Be    ${page_favourites['div_product_price']}    ${product_id}    ${product_price}
    Dynamic Element Should Be Visible    ${page_favourites['div_product_installment_price']}    ${product_id}
    Dynamic Element Text Should Be    ${page_favourites['div_product_installment_price']}    ${product_id}    ${product_installment_price}
    # Remove the item from the favourites list
    Click Dynamic Element    ${page_home['btn_add_to_favourites']}    ${product_id}
    # Assert that the item is no longer in the favourites list
    Element Should Be Visible    "0 Product(s) found."
    Element Should Not Be Visible    ${page_favourites['div_all_items']}
    Dynamic Element Should Not Be Visible    ${page_favourites['btn_add_to_favourites']}    ${product_id}
    Dynamic Element Should Not Be Visible    ${page_favourites['btn_add_to_cart']}    ${product_id}
    Dynamic Element Should Not Be Visible    ${page_favourites['label_product_name']}    ${product_id}
    Dynamic Element Should Not Be Visible    ${page_favourites['img_product']}    ${product_id}
    Dynamic Element Should Not Be Visible    ${page_favourites['div_product_price']}    ${product_id}
    Dynamic Element Should Not Be Visible    ${page_favourites['div_product_installment_price']}    ${product_id}

