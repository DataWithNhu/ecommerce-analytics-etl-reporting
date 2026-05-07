# Data Catalog for Processed Data

## Overview
The Processed Data is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **processed.dim_user**
- **Description:** Snapshot of user profile.
- **Columns:**

| Column Name                      | Data Type     | Description                                                                   |
|----------------------------------|---------------|-------------------------------------------------------------------------------|
| user_id                          | INT           | Unique user_id for each user                                                  |
| user_name                        | STRING        | User's username                                                               |
| gender                           | STRING        | User's gender: 1 is Male, 2 is Female, Null is Unknown                        |
| birthday                         | DATE          | User's birthday                                                               |
| last_login_datetime              | TIMESTAMP     | last login time to app/web of platform                                        |
| last_login_date                  | DATE          | last login date to app/web of platform                                        |
| registration_datetime            | TIMESTAMP     | use registration time - time at which account was created                     |
| default_delivery_address_state   | STRING        | default delivery address that is set                                          |
| default_delivery_address_city    | STRING        | default delivery address that is set                                          |


---

### 2. **processed.dwd_login_event**
- **Description:** Table records all login events onto App/Web.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                |
|---------------------|---------------|--------------------------------------------------------------------------------------------|
| user_id             | INT           | user_id login                                                                              |
| grass_date          | INT           | date of login event                                                                        |
| login_datetime      | TIMESTAMP     | Time of login event                                                                        |
| login_platform      | STRING        | Platform of login: App/Web                                                                 |

---

### 3. **processed.order_item_mart**
- **Description:** Table records all orders/transactions at product variation level from beginning of time.
- **Columns:**

| Column Name                         | Data Type     | Description                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| order_id                            | INT           | order id of the order                                                         |
| item_id                             | INT           | item id of the items purchased in the order Note: for bundle deal, the bundle is split into the actual item, and the actual itemid of the physical item is recorded                                                          |
| model_id                            | INT           | model id of the models purchased in the order Note: for bundle deal, the bundle is split into the actual item, and the actual model id of the physical item is recorded                                                        |
| buyer_id                            | INT           | unique userid of the buyer                                                    |
| checkout_channel                    | STRING        | Indicates which platform is the checkout performed on                         |
| is_web_checkout                     | STRING        | Whether the order was checked out from web portal (web include PC and Mobile Web) |
| create_date                         | DATE          | Date of the order when its created (epoch time)                               |        
| complete_date                       | DATE          | Date of the order when its completed / accepted by the buyer after receiving all the parcels for the order (local time in string)                                                                                          |
| release_date                        | DATE          | Date when the order should already be completed and escrow started            |
| cancel_date                         | DATE          | Date of the order when its canceled by the buyer (local time in string)       |
| is_net_order                        | STRING        | net or cancelled                                                              |  
| shop_id                             | INT           | unique id of the shop                                                         |
| shop_name                           | STRING        | name of the shop                                                              |
| is_official_shop                    | INT           | whether the order is from official shop shop                                  |
| is_cb_shop                          | STRING        | Whether the order is from a cross border shop                                 |
| seller_id                           | INT           | unique userid of the seller                                                   |
| seller_name                         | STRING        | username of the seller                                                        |  
| seller_shipping_address_state       | STRING        | State of the shipping address of the seller                                   |
| seller_shipping_address_city        | STRING        | City of the shipping address of the seller                                    |
| buyer_shipping_address_state        | STRING        | State of the shipping address of the seller                                   |
| buyer_shipping_address_city         | STRING        | City of the shipping address of the seller                                    |
| gmv_usd                             | FLOAT         | Gross mechandise value of the order in USD                                    |
| item_amount                         | INT           | quantity of an item in order                                                  |
| main_category                       | STRING        | category name of the item                                                     |
| estimate_shipping_fee_usd           | FLOAT         | The shipping fee calculated by Shopee system based on the buyer and seller location, parcel size                                                                                                                           |
| buyer_paid_shipping_fee_usd         | FLOAT         | Buyer paid shipping fee in USD                                                |
| estimate_shipping_rebate_amt_usd    | FLOAT         | Platform subsidy shipping fee in USD                                          |
| voucher_rebate_usd                  | FLOAT         | Platform subsidy product price by voucher in USD                              |
| fsv_promotion_id                    | FLOAT         | Freeship voucher ID, null if not using                                        |
| pv_promotion_id                     | FLOAT         | Platform product discount voucher ID, null if not using                       |
