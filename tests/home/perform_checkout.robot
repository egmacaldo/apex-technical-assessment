*** Settings ***
Resource        ${EXECDIR}${/}resources${/}common.robot

Suite Setup     New Browser   ${BROWSER}    headless=${HEADLESS}
Test Setup      Navigate to the Home Page


*** Test Cases ***
Perform Checkout as a Non-Signed-In user
    [Documentation]    Validates that a non-signed-in user can add items to their cart and complete the checkout process.
    # Validate that the user is not signed in
    Element Should Be Visible    ${page_home['link_sign_in']}
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
    # The product information should be reflected correctly in the shopping cart component
    Dynamic Element Should Be Visible    ${component_shopping_cart['img_product']}    ${product_img_src}
    Dynamic Element Should Be Visible    ${component_shopping_cart['label_item_name']}    ${product_name}
    ${shopping_cart_item_price}    Get Text    ${component_shopping_cart['label_item_price']}
    ${shopping_cart_item_price}    Remove Whitespaces from String    ${shopping_cart_item_price}
    Should Be Equal    ${product_price}    ${shopping_cart_item_price}
    ${shopping_cart_desc}    Get Dynamic Element Text
    ...    ${component_shopping_cart['label_item_desc']}
    ...    ${product_name}
    Assert Item Brand And Quantity in Shopping Cart
    ...    ${product_name}
    ...    ${shopping_cart_desc}
    ...    ${expected_home['non-signed-in_user']['bag_quantity_text']}
    ${shopping_cart_subtotal}    Get Text    ${component_shopping_cart['label_subtotal_price']}
    ${shopping_cart_subtotal}    Remove Whitespaces from String    ${shopping_cart_subtotal}
    Should Be Equal    ${product_price}    ${shopping_cart_subtotal}
    ${shopping_cart_subtotal_installment}    Get Text    ${component_shopping_cart['label_subtotal_installment']}
    Assert Item Installment Price in Shopping Cart
    ...    ${product_installment_price}
    ...    ${shopping_cart_subtotal_installment}
    Click    ${component_shopping_cart['btn_checkout']}
    # User should be required to login
    Page URL Should Be
    ...    ${base_urls['prod']}${SUT_PATH_SIGN_IN}${expected_home['non-signed-in_user']['checkout_url_params']}
    Element Should Be Visible    ${page_sign_in['btn_login']}
    Perform Login
    ...    ${inputs_login['valid_credentials']['username']}
    ...    ${inputs_login['valid_credentials']['password']}
    # Validate order summary information
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_CHECKOUT}
    Dynamic Element Should Be Visible    ${page_checkout['img_item']}    ${product_id}
    Dynamic Element Should Be Visible    ${page_checkout['label_item_name']}    ${product_id}
    Dynamic Element Should Be Visible    ${page_checkout['label_item_price']}    ${product_id}
    ${checkout_item_desc}    Get Dynamic Element Text    ${page_checkout['label_item_desc']}    ${product_id}
    Assert Item Brand And Quantity in Checkout
    ...    ${product_name}
    ...    ${checkout_item_desc}
    ...    ${expected_home['non-signed-in_user']['bag_quantity_text']}
    Element Text Should Be    ${page_checkout['label_total_price']}    ${product_price}
    Generate Random User Checkout Data
    Fillout User Data    ${checkout_user_data['first_name']}
    ...    ${checkout_user_data['last_name']}
    ...    ${checkout_user_data['address']}
    ...    ${checkout_user_data['province']}
    ...    ${checkout_user_data['postal_code']}
    Click    ${page_checkout['btn_submit']}
    # Validate order confirmation
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_CONFIRMATION}
    Element Should Be Visible    ${page_confirmation['label_order_confirmed']}
    Click    ${page_confirmation['btn_continue_shopping']}
    # Navigate to orders page and validate order information
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

Perform Checkout as a Signed-In user
    [Documentation]    Verify that a signed-in user can add a phone with varying quantities to their cart
    ...     and that the total amount is calculated correctly.
    [Setup]    Sign In User    ${inputs_login['valid_credentials']['username']}
    ...    ${inputs_login['valid_credentials']['password']}
    # Assert user is signed in
    Element Text Should Be    ${component_headers['label_current_user']}    ${inputs_login['valid_credentials']['username']}
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
    # Randomize the quantity of the product to be ordered and increase the item quantity
    ${item_quantity}    Generate Random Number From Range    2    11
    Click Dynamic Element Multiple Times    ${component_shopping_cart['btn_increase_quantity']}    ${product_name}    ${{${item_quantity}-1}}
    # The product information should be reflected correctly in the shopping cart component
    Dynamic Element Should Be Visible    ${component_shopping_cart['img_product']}    ${product_img_src}
    Dynamic Element Should Be Visible    ${component_shopping_cart['label_item_name']}    ${product_name}
    ${shopping_cart_item_price}    Get Text    ${component_shopping_cart['label_item_price']}
    ${shopping_cart_item_price}    Remove Whitespaces from String    ${shopping_cart_item_price}
    Should Be Equal    ${product_price}    ${shopping_cart_item_price}
    ${shopping_cart_desc}    Get Dynamic Element Text
    ...    ${component_shopping_cart['label_item_desc']}
    ...    ${product_name}
    Assert Item Brand And Quantity in Shopping Cart
    ...    ${product_name}
    ...    ${shopping_cart_desc}
    ...    ${item_quantity}
    ${shopping_cart_subtotal}    Get Text    ${component_shopping_cart['label_subtotal_price']}
    ${shopping_cart_subtotal}    Remove Whitespaces from String    ${shopping_cart_subtotal}
    ${product_subtotal}    Compute Checkout Total Of Item With Multiple Quantities    ${{${product_price}[1:]}}    ${item_quantity}
    Should Be Equal    $${product_subtotal}    ${shopping_cart_subtotal}
    Click    ${component_shopping_cart['btn_checkout']}
    # Validate order summary information
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_CHECKOUT}
    Dynamic Element Should Be Visible    ${page_checkout['img_item']}    ${product_id}
    Dynamic Element Should Be Visible    ${page_checkout['label_item_name']}    ${product_id}
    Dynamic Element Should Be Visible    ${page_checkout['label_item_price']}    ${product_id}
    Dynamic Element Text Should Be    ${page_checkout['label_item_price']}    ${product_id}    $${{${product_subtotal}[:-3]}}
    ${checkout_item_desc}    Get Dynamic Element Text    ${page_checkout['label_item_desc']}    ${product_id}
    Assert Item Brand And Quantity in Checkout
    ...    ${product_name}
    ...    ${checkout_item_desc}
    ...    ${item_quantity}
    Element Text Should Be    ${page_checkout['label_total_price']}    $${product_subtotal}
    Generate Random User Checkout Data
    Fillout User Data    ${checkout_user_data['first_name']}
    ...    ${checkout_user_data['last_name']}
    ...    ${checkout_user_data['address']}
    ...    ${checkout_user_data['province']}
    ...    ${checkout_user_data['postal_code']}
    Click    ${page_checkout['btn_submit']}
    # Validate order confirmation
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_CONFIRMATION}
    Element Should Be Visible    ${page_confirmation['label_order_confirmed']}
    Click    ${page_confirmation['btn_continue_shopping']}
    # Navigate to orders page and validate order information
    Click    ${component_headers['link_orders']}
    Page URL Should Be    ${base_urls['prod']}${SUT_PATH_ORDERS}
    Dynamic Element Should Be Visible    ${page_orders['div_order_container']}    ${product_name}
    ${order_div_id}    Get Dynamic Element Attribute    ${page_orders['div_order_container']}    ${product_name}    id
    ${current_date}    Get Current Date    result_format=%B %d, %Y
    Dynamic Element Text Should Be    ${page_orders['label_order_placed_date']}    ${order_div_id}    ${current_date}
    Dynamic Element Text Should Be
    ...    ${page_orders['label_order_total']}
    ...    ${order_div_id}
    ...    $${{'${product_subtotal}'[:-3]}}
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
    Dynamic Element Text Should Be    ${page_orders['label_item_price']}    ${item_div_id}    $${product_subtotal}
