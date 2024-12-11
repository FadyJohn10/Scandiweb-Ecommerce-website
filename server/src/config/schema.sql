DROP DATABASE IF EXISTS scandiweb_ecommerce_task;
CREATE DATABASE scandiweb_ecommerce_task;
USE scandiweb_ecommerce_task;

CREATE TABLE categories (
    name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE products (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    inStock BOOLEAN DEFAULT TRUE,
    gallery JSON,
    description TEXT,
    category VARCHAR(255),
    brand VARCHAR(255),
    FOREIGN KEY (category) REFERENCES categories(name) ON DELETE SET NULL
);

CREATE TABLE attributes (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    CONSTRAINT unique_attribute UNIQUE (name, type)
);

CREATE TABLE product_attributes (
    id VARCHAR(255) PRIMARY KEY,
    product_id VARCHAR(255) NOT NULL,
    attribute_id VARCHAR(255),
    displayValue VARCHAR(255) NOT NULL,
    value VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES attributes(id) ON DELETE SET NULL,
    CONSTRAINT unique_product_attribute_value UNIQUE (product_id, attribute_id, value)
);

CREATE TABLE currencies (
    label VARCHAR(50) PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL
);

CREATE TABLE prices (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10, 2),
    currency VARCHAR(50) NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (currency) REFERENCES currencies(label) ON DELETE CASCADE,
    CONSTRAINT unique_product_price_currency UNIQUE (product_id, currency)
);

CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    total_amount DECIMAL(10, 2) NOT NULL,
    total_currency VARCHAR(50) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id VARCHAR(255),
    product_name VARCHAR(255) NOT NULL,
    attribute_values JSON NOT NULL,
    quantity INT UNSIGNED DEFAULT 1,
    paid_amount DECIMAL(10, 2) NOT NULL,
    paid_currency VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

INSERT INTO categories (name) 
VALUES ('all'), ('clothes'), ('tech');

INSERT INTO products (id, name, inStock, gallery, description, category, brand)
VALUES
    ('huarache-x-stussy-le', 'Nike Air Huarache Le', TRUE, 
    '["https://cdn.shopify.com/s/files/1/0087/6193/3920/products/DD1381200_DEOA_2_720x.jpg?v=1612816087","https://cdn.shopify.com/s/files/1/0087/6193/3920/products/DD1381200_DEOA_1_720x.jpg?v=1612816087"]', 
    '<p>Great sneakers for everyday use!</p>', 'clothes', 'Nike x Stussy'),
    ('jacket-canada-goosee', 'Jacket', TRUE, 
    '["https://images.canadagoose.com/image/upload/w_480,c_scale,f_auto,q_auto:best/v1576016105/product-image/2409L_61.jpg"]', 
    '<p>Awesome winter jacket</p>', 'clothes', 'Canada Goose'),
    ('ps-5', 'PlayStation 5', TRUE, 
    '["https://images-na.ssl-images-amazon.com/images/I/510VSJ9mWDL._SL1262_.jpg"]', 
    '<p>A good gaming console. Plays games of PS4!</p>', 'tech', 'Sony');

INSERT INTO attributes (id, name, type) 
VALUES 
    ('size', 'size', 'text'), 
    ('color', 'color', 'swatch'), 
    ('capacity', 'capacity', 'text');

INSERT INTO product_attributes (id, product_id, attribute_id, displayValue, value) 
VALUES
    ('huarache-x-stussy-le-size-40', 'huarache-x-stussy-le', 'size', '40', '40'),
    ('ps-5-color-Green', 'ps-5', 'color', 'Green', '#44FF03');

INSERT INTO currencies (label, symbol) 
VALUES 
    ('USD', '$'), 
    ('EUR', '€');

INSERT INTO prices (amount, currency, product_id) 
VALUES 
    (144.69, 'USD', 'huarache-x-stussy-le'),
    (518.47, 'USD', 'jacket-canada-goosee'),
    (844.02, 'USD', 'ps-5');

INSERT INTO orders (total_amount, total_currency) 
VALUES (2000.00, 'USD');

SET @order_id = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, product_name, attribute_values, quantity, paid_amount, paid_currency) 
VALUES
    (@order_id, 'huarache-x-stussy-le', 'Nike Air Huarache Le', '{"size": "42", "color": "Black"}', 2, 289.38, 'USD');
