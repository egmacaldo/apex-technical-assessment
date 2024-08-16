*** Keywords ***
Assert Item Brand And Quantity in Shopping Cart
    [Documentation]    Validates if the item in the shopping cart has the correct brand or vendor.
    [Arguments]    ${item_name}    ${item_desc}    ${item_quantity}
    IF    'iPhone' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    Apple\nQuantity: ${item_quantity}
    ELSE IF    'Galaxy' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    Samsung\nQuantity: ${item_quantity}
    ELSE IF    'Pixel' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    Google\nQuantity: ${item_quantity}
    ELSE IF    'One Plus' in '${item_name}'
        Should Be Equal As Strings    ${item_desc}    OnePlus\nQuantity: ${item_quantity}
    END

Assert Item Installment Price in Shopping Cart
    [Documentation]    Validates if the installment price is correct for an item in the shopping cart.
    [Arguments]    ${item_installment_price}    ${shopping_cart_item_installment_price}
    ${item_installment_price}    Get Substring    ${item_installment_price}    3
    Should Be Equal    OR UP TO ${item_installment_price}    ${shopping_cart_item_installment_price}

Compute Checkout Total Of Item With Multiple Quantities
    [Documentation]    Computes for the total amount of the item with multiple quantities.
    [Arguments]    ${item_price}    ${quantity}
    ${total}    Evaluate    "{:.2f}".format(${item_price}*${quantity})
    RETURN    ${total}