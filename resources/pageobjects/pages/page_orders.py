page_orders = {
    "div_order_container": "//div[contains(.,'{}')][@class='a-row']/ancestor::div[contains(@class,'a-box-group')]",
    "label_order_placed_date": "//div[@id='{}']//span[text()='Order placed']/parent::div/following-sibling::div/span",
    "label_order_total": "//div[@id='{}']//span[text()='Total']/parent::div/following-sibling::div/span",
    "label_order_user": "//div[@id='{}']//span[text()='Ship to']/parent::div/following-sibling::div/span",
    "div_item_container": "//div[contains(.,'{}')]/ancestor::div[contains(@class,'shipment')]//div[@id]",
    "label_item_title": "//div[@id='{}']//strong[text()='Title:']/parent::div",
    "label_item_description": "//div[@id='{}']//strong[text()='Description:']/parent::div",
    "label_item_price": "//div[@id='{}']//span",
}