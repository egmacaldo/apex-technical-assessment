*** Settings ***
Resource        ${EXECDIR}${/}resources${/}common.robot

Suite Setup     New Browser   ${BROWSER}    headless=${HEADLESS}
Test Setup      Sign In User    ${inputs_login['valid_credentials']['username']}
...            ${inputs_login['valid_credentials']['password']}


*** Test Cases ***
Verify Order History for Signed-In User
    [Documentation]    Confirm that a signed-in user can view their order history and see
    ...    details of previous orders.
    # Verify user has no order history
    Click    ${component_headers['link_orders']}
    Element Should Be Visible    "No orders found"
    # Navigate to the homepage to add a new order
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
    Click Dynamic Element    ${page_home['btn_add_to_cart']}    ${product_id}
    Click    ${component_shopping_cart['btn_checkout']}
    Generate Random User Checkout Data
    Fillout User Data    ${checkout_user_data['first_name']}
    ...    ${checkout_user_data['last_name']}
    ...    ${checkout_user_data['address']}
    ...    ${checkout_user_data['province']}
    ...    ${checkout_user_data['postal_code']}
    Click    ${page_checkout['btn_submit']}
    Click    ${page_confirmation['btn_continue_shopping']}
    # Navigate to orders page and validate that the order is now reflected
    Click    ${component_headers['link_orders']}
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_ORDERS}
    Dynamic Element Should Be Visible    ${page_orders['div_order_container']}    ${product_name}
    ${order_div_id}    Get Dynamic Element Attribute    ${page_orders['div_order_container']}    ${product_name}    id
    ${current_date}    Get Current Date    result_format=%B %d, %Y
    Dynamic Element Text Should Be    ${page_orders['label_order_placed_date']}    ${order_div_id}    ${current_date}
    Dynamic Element Text Should Be
    ...    ${page_orders['label_order_total']}
    ...    ${order_div_id}
    ...    ${{'${product_price}'[:-3]}}
    Dynamic Element Text Should Be
    ...    ${page_orders['label_order_user']}
    ...    ${order_div_id}
    ...    ${inputs_login['valid_credentials']['username']}
    ${item_div_id}    Get Dynamic Element Attribute    ${page_orders['div_item_container']}    ${product_name}    id
    Dynamic Element Text Should Be    ${page_orders['label_item_title']}    ${item_div_id}    Title: ${product_name}
    Dynamic Element Text Should Be
    ...    ${page_orders['label_item_description']}
    ...    ${item_div_id}
    ...    Description: ${product_name}
    Dynamic Element Text Should Be    ${page_orders['label_item_price']}    ${item_div_id}    ${product_price}