USE sql_store;

# SELECT 
#     *
# FROM
#     customers
# #  WHERE
# #    customer_id = 1
# ORDER BY
#   first_name;
    
SELECT 
    *
FROM
    customers
ORDER BY first_name;

SELECT 
    first_name, last_name
FROM
    customers;
    
SELECT 
    last_name,
    first_name,
    (points + 10) * 100 AS 'discount factor'
FROM
    customers;


-- distinct keyword
SELECT DISTINCT
    state
FROM
    customers;
    
SELECT 
    name, unit_price, (unit_price * 1.1) AS 'new price'
FROM
    products;

-- where clause
SELECT 
    *
FROM
    customers
WHERE
    points > 3000;
    
SELECT 
    *
FROM
    customers
WHERE
    state = 'va';
-- not equal to -> (!=, <>) 
    -- any of the above symbols can be used


SELECT 
    *
FROM
    orders
WHERE
    order_date >= '2017-01-01';
    
-- and or and not operators.
SELECT 
    *
FROM
    customers
WHERE
    (birth_date > '1990-01-01'
        OR points > 1000)
        AND NOT state = 'va';


SELECT 
    *
FROM
    order_items
WHERE
    order_id = 6
        AND (unit_price * quantity) > 30;
        
-- the IN operator
SELECT 
    *
FROM
    customers
WHERE
    state IN ('va' , 'fl', 'ga');
    
SELECT 
    *
FROM
    products
WHERE
    quantity_in_stock IN (49 , 38, 72);

-- between operator -> it is inclusive of the range.
SELECT 
    *
FROM
    customers
WHERE
    points BETWEEN 1000 AND 3000;
    
SELECT 
    *
FROM
    customers
WHERE
    birth_date BETWEEN '1990-01-01' AND '2000-01-01';
  
-- LIKE operator
  -- match string pattern
  -- % -> any number of characters
  -- _ -> a single character

SELECT 
    *
FROM
    customers
WHERE
    last_name LIKE 'b%';
    
SELECT 
    *
FROM
    customers
WHERE
    last_name LIKE 'brush%';
    
SELECT 
    *
FROM
    customers
WHERE
    address LIKE '%trail%'
        OR address LIKE '%avenue%';
        

-- regexp operator
  -- ^ -> beginning of the string
  -- $ -> end of the string
  -- | -> or 
  -- [] -> set of characters to replace a single character
    -- [a-z] a single character from a to z inclusive 
SELECT 
    *
FROM
    customers
WHERE
    last_name REGEXP 'field$|mac|rose';
    
SELECT 
    *
FROM
    customers
WHERE
    last_name REGEXP '[fmq]';
    
SELECT 
    *
FROM
    customers
WHERE
    first_name REGEXP 'elka|ambur';
    
SELECT 
    *
FROM
    customers
WHERE
    last_name REGEXP 'ey$|on$';


SELECT 
    *
FROM
    customers
WHERE
    last_name REGEXP '^my|se';

select * from customers
where last_name regexp 'b[ru]';


-- IS NULL operator
SELECT 
    *
FROM
    customers
WHERE
    phone IS NULL;

SELECT 
    *
FROM
    customers
WHERE
    phone IS NOT NULL;
    
SELECT 
    order_id
FROM
    orders
WHERE
    shipped_date IS NULL;
    

-- order by clause
  -- ASC or DESC
  -- primary key is used by default
  -- the order by column need not be selected.
  -- even aliases can be used.
SELECT 
    *
FROM
    customers
ORDER BY last_name ASC;

SELECT 
    *
FROM
    customers
ORDER BY state ASC, last_name DESC;

-- not advisable to sort by column positions. 
SELECT 
    first_name AS fn, last_name AS ln
FROM
    customers
ORDER BY 1 , 2;


SELECT 
    *, quantity * unit_price AS total_price
FROM
    order_items
WHERE
    order_id = 2
ORDER BY total_price DESC;

-- limit clause
  -- LIMIT x, y,
  -- where x is offset or skip count
SELECT 
    *
FROM
    customers
LIMIT 3;

SELECT 
    *
FROM
    customers
LIMIT 6,3;

SELECT 
    *
FROM
    customers
ORDER BY points DESC
LIMIT 3;

-- INNER JOIN or JOIN
SELECT 
    *
FROM
    orders
        INNER JOIN
    customers ON orders.customer_id = customers.customer_id
WHERE
    shipped_date IS NOT NULL;

SELECT 
    *, customers.customer_id
FROM
    orders
        INNER JOIN
    customers ON orders.customer_id = customers.customer_id
WHERE
    shipped_date IS NOT NULL;
    

SELECT 
    *, c.customer_id
FROM
    orders AS o
        INNER JOIN
    customers AS c ON o.customer_id = c.customer_id
WHERE
    shipped_date IS NOT NULL;
    
    
SELECT 
    order_id, p.product_id, quantity, oi.unit_price
FROM
    order_items AS oi
        JOIN
    products AS p ON oi.product_id = p.product_id;

-- joining across databases
SELECT 
    *
FROM
    order_items AS o
        JOIN
    sql_inventory.products AS p;
    
-- self joins
USE sql_hr;
SELECT 
    e.employee_id, e.first_name fn, m.first_name manager_name
FROM
    employees e
        JOIN
    employees m ON e.reports_to = m.employee_id;


-- joining multiple tables
USE sql_store;

SELECT 
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    s.name status
FROM
    orders o
        JOIN
    customers c
        JOIN
    order_statuses s;
  
  
USE sql_invoicing;

SELECT 
    c.name, date, pm.name payment_method, p.amount
FROM
    payments p
        JOIN
    payment_methods pm
        JOIN
    clients c;
    
-- compound join.
USE sql_store;

SELECT 
    *
FROM
    order_items oi
        JOIN
    order_item_notes oin ON oi.order_id = oin.order_id
        AND oi.product_id = oin.product_id;
        
-- implicit join syntax
-- not advised as cross join will happen if where condition is not specified.
SELECT 
    *
FROM
    orders o,
    customers c
WHERE
    o.customer_id = c.customer_id;
    
-- outer join
SELECT 
    *
FROM
    customers c
        LEFT OUTER JOIN
    orders o ON c.customer_id = o.customer_id;

SELECT 
    *
FROM
    customers c
        RIGHT OUTER JOIN
    orders o ON c.customer_id = o.customer_id;


SELECT 
    p.product_id, p.name, o.quantity
FROM
    products p
        LEFT JOIN
    order_items o ON o.product_id = p.product_id;
    
-- outer join among multiple tables.
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id,
    sh.name shipper_name
FROM
    customers c
        LEFT JOIN
    orders o ON c.customer_id = o.customer_id
        LEFT JOIN
    shippers sh ON o.shipper_id = sh.shipper_id;

SELECT 
    o.order_date,
    o.order_id,
    c.first_name,
    sh.name shipper,
    os.name status
FROM
    orders o
        LEFT JOIN
    customers c ON o.customer_id = c.customer_id
        LEFT JOIN
    shippers sh ON o.shipper_id = sh.shipper_id
        LEFT JOIN
    order_statuses os ON o.status = os.order_status_id
ORDER BY status;


-- self outer joins
USE sql_hr;
SELECT 
    e.employee_id, e.first_name, m.first_name manager
FROM
    employees e
        LEFT JOIN
    employees m ON e.reports_to = m.employee_id;
    
-- Using clause
-- works only when the name of the column is the same.
USE sql_store;
SELECT 
    o.order_id, c.first_name
FROM
    orders o
        JOIN
    customers c USING (customer_id);
    
SELECT 
    o.order_id, c.first_name, sh.name shipper
FROM
    orders o
        LEFT JOIN
    customers c USING (customer_id)
        LEFT JOIN
    shippers sh USING (shipper_id);
    
USE sql_store;

SELECT 
    *
FROM
    order_items oi
        JOIN
    order_item_notes oin USING (order_id , product_id);
    
USE sql_invoicing;
SELECT 
    p.date, c.name client, p.amount, pm.name method
FROM
    payments p
        JOIN
    payment_methods pm ON p.payment_method = pm.payment_method_id
        JOIN
    clients c USING (client_id);
    
-- natural join
    -- not recommended becuase of unexpected results.
USE sql_store;
SELECT 
    o.order_id, c.first_name
FROM
    orders o
        NATURAL JOIN
    customers c;
    
SELECT 
    *
FROM
    customers c
        CROSS JOIN
    products p;
    
-- implicit cross join
SELECT 
    *
FROM
    customers,
    products;
    
SELECT 
    *
FROM
    shippers
        CROSS JOIN
    products;
    
-- unions
SELECT 
    order_id, order_date, 'Active' AS status
FROM
    orders
WHERE
    order_date >= '2019-01-01' 
UNION SELECT 
    order_id, order_date, 'Archived' AS status
FROM
    orders
WHERE
    order_date < '2019-01-01';
    
    
SELECT 
    first_name AS name
FROM
    customers 
UNION SELECT 
    name
FROM
    shippers;
    
SELECT 
    customer_id, first_name, points, 'Bronze' AS 'type'
FROM
    customers
WHERE
    points <= 1999 
UNION SELECT 
    customer_id, first_name, points, 'Silver'
FROM
    customers
WHERE
    points BETWEEN 2000 AND 2999 
UNION SELECT 
    customer_id, first_name, points, 'Gold'
FROM
    customers
WHERE
    points >= 3000
ORDER BY first_name;


-- INSERT, UPDATE, DELETE operations.
-- Inserting a row into a table.
-- insert into statement

INSERT INTO customers
VALUES (
    DEFAULT, -- preferred approach for primary keys.
    'John',
    'Smith',
    '1990-10-11', -- we can also use null for this field because it is nullable.
    NULL, -- this will be null
    'address',
    'city',
    'ca',
    DEFAULT
);

-- to specify the columns that will receive a value.
-- we can specify the columns in any order. However, the order of column and its value needs to match.
INSERT INTO customers (
    first_name, 
    last_name, 
    birth_date, 
    address, 
    city, 
    state
)
VALUES (
    'John',
    'Smith',
    '1990-10-11', -- we can also use null for this field because it is nullable.
    'address',
    'city',
    'ca'
);

SELECT 
    *
FROM
    customers;


-- inserting multiple rows at once
INSERT INTO shippers (
    name
)
VALUES  ('Shipper1'),
        ('Shipper2'),
        ('Shipper3');
        
SELECT 
    *
FROM
    shippers;

INSERT INTO products(
    name, unit_price, quantity_in_stock
)
VALUES  ('forg', 69, 420),
        ('doge', 71, 58),
        ('monke', 92, 68);
        
SELECT 
    *
FROM
    products;
    

-- inserting hierarchical rows
INSERT INTO orders (
    customer_id, 
    order_date,
    status
)
VALUES (
    1,
    '2019-01-02',
    1
);

INSERT INTO order_items
VALUES  (LAST_INSERT_ID(),1,3,2.95),
        (LAST_INSERT_ID(),2,3,3.95);

SELECT 
    *
FROM
    order_items;
    
-- creating a copy of a table.
CREATE TABLE orders_archived AS (SELECT * FROM
    orders
WHERE
    order_date < '2019-01-01');

-- subqueries in insert statement
INSERT into orders_archived
SELECT * FROM
    orders
WHERE
    order_date < '2019-01-01';
    
USE sql_invoicing;

CREATE TABLE invoices_archived AS SELECT i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.invoice_date,
    i.payment_date,
    i.due_date FROM
    invoices i
        JOIN
    clients c USING (client_id)
WHERE
    payment_date IS NOT NULL;
    

-- updating a single row
UPDATE invoices 
SET 
    payment_total = 10,
    payment_date = '2019-03-01'
WHERE
    invoice_id = 1; 
    
UPDATE invoices 
SET 
    payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE
    invoice_id = 2;
    
-- updating multiple tuples
-- all the records
UPDATE invoices 
SET 
    payment_total = invoice_total * 0.5,
    payment_date = due_date;
    
-- select few
UPDATE invoices 
SET 
    payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE
    invoice_id IN (3 , 4, 5);
    
USE sql_store;
UPDATE customers 
SET 
    points = points + 50
WHERE
    birth_date < '1990-01-01';
    
-- subqueries in update statement
USE sql_invoicing;
UPDATE invoices 
SET 
    payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE
    client_id = (SELECT 
            client_id
        FROM
            clients
        WHERE
            name = 'Myworks');

UPDATE invoices 
SET 
    payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE
    client_id IN (SELECT 
            client_id
        FROM
            clients
        WHERE
            state IN ('ca' , 'ny'));
            
UPDATE invoices 
SET 
    payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE
    payment_date IS NULL;

USE sql_store;
UPDATE orders 
SET 
    comments = 'Gold customer'
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            customers
        WHERE
            points > 3000);
            
-- deleting rows
USE sql_invoicing;
DELETE FROM invoices 
WHERE
    invoice_id = (SELECT 
        client_id
    FROM
        clients
    
    WHERE
        name = 'Myworks');
        
-- ---------------------------------------
-- aggregate functions -------------------
-- MAX(), MIN(), AVG(), SUM(), COUNT(), etc.
-- only operate on non null values. Null values are ignored.

USE sql_invoicing;

SELECT 
    MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total) AS total,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(*) AS total_records
FROM
    invoices;
    
SELECT 
    MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total) AS total,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(DISTINCT client_id) AS total_clients
FROM
    invoices
WHERE
    invoice_date > '2019-07-01';
    
SELECT 
    'First half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_exapected
FROM
    invoices
WHERE
    invoice_date BETWEEN '2019-01-01' AND '2019-06-30' 
UNION SELECT 
    'Second half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_exapected
FROM
    invoices
WHERE
    invoice_date BETWEEN '2019-06-30' AND '2019-12-31' 
UNION SELECT 
    'total' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_exapected
FROM
    invoices
WHERE
    invoice_date BETWEEN '2019-01-01' AND '2019-12-31';

-- group by clause
SELECT 
    client_id, SUM(invoice_total) AS total_sales
FROM
    invoices
where invoice_date >= '2019-06-01'
GROUP BY client_id 
ORDER BY total_sales DESC;

SELECT 
    state, city, SUM(invoice_total) AS total_sales
FROM
    invoices i
        JOIN
    clients c USING (client_id)
GROUP BY state , city;

SELECT 
    date,
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM
    payments p
        JOIN
    payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY date , payment_method
ORDER BY date;


-- having clause filters after grouping.
SELECT 
    client_id, SUM(invoice_total) AS total_sales
FROM
    invoices
GROUP BY client_id
HAVING total_sales > 500;

SELECT 
    client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM
    invoices
GROUP BY client_id
HAVING total_sales > 500
    AND number_of_invoices > 2;

USE sql_store;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(unit_price * quantity) AS total_amount_spent
FROM
    customers c
        JOIN
    orders o USING (customer_id)
        JOIN
    order_items oi USING (order_id)
WHERE
    c.state = 'va'
GROUP BY c.customer_id , c.first_name , c.last_name
HAVING total_amount_spent > 100
ORDER BY total_amount_spent;


USE sql_invoicing;
-- rollup operator
    -- summarises the aggreagated columns for each group and all the groups at the end.
SELECT 
    state, city, SUM(invoice_total) AS total_sales
FROM
    invoices i
        JOIN
    clients c USING (client_id)
GROUP BY state, city WITH ROLLUP;


SELECT 
    pm.name AS payment_method, SUM(p.amount)
FROM
    payments p
        JOIN
    payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;


USE sql_store;
-- -------------------
-- subqueries --------
SELECT 
    *
FROM
    products
WHERE
    unit_price > (SELECT 
            unit_price
        FROM
            products
        WHERE
            product_id = 3);
            
USE sql_hr;

SELECT 
    *
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);
            
-- in operator
USE sql_store;

SELECT 
    *
FROM
    products
WHERE
    product_id NOT IN (SELECT DISTINCT
            product_id
        FROM
            order_items);

USE sql_invoicing;
SELECT 
    *
FROM
    clients
WHERE
    client_id NOT IN (SELECT DISTINCT
            client_id
        FROM
            invoices);
            
-- all keyword.
USE sql_invoicing;

SELECT 
    *
FROM
    invoices
WHERE
    invoice_total > (SELECT 
            MAX(invoice_total)
        FROM
            invoices
        WHERE
            client_id = 3);
            
-- alternatively
SELECT 
    *
FROM
    invoices
WHERE
    invoice_total > ALL (SELECT 
            invoice_total
        FROM
            invoices
        WHERE
            client_id = 3);
            
-- the any keyword
SELECT 
    *
FROM
    clients
WHERE
    client_id = ANY (SELECT 
            client_id
        FROM
            invoices
        GROUP BY client_id
        HAVING COUNT(*) >= 2);
-- the = any is similar to IN operator.



-- correlated subqueries
USE sql_hr;


-- for each employee
    -- calculate the average salary for employee.office
    -- return the employee if salary > avg
SELECT 
    *
FROM
    employees e
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees
        WHERE
            office_id = e.office_id);

-- get invoices that are larger than the client's average invoice amount.
USE sql_invoicing;
SELECT 
    *
FROM
    invoices i
WHERE
    invoice_total > (SELECT 
            AVG(invoice_total)
        FROM
            invoices
        WHERE
            client_id = i.client_id);
            
-- exists operator

-- select clients that have an invoice
SELECT 
    *
FROM
    clients
WHERE
    client_id IN (SELECT DISTINCT
            client_id
        FROM
            invoices);
-- or
SELECT 
    distinct name
FROM
    clients
        JOIN
    invoices USING (client_id);
    
-- or using the exists operator
SELECT 
    *
FROM
    clients c
WHERE
    EXISTS( SELECT 
            client_id
        FROM
            invoices
        WHERE
            client_id = c.client_id);
-- the one with in operator returns a result set to the outer query while the exists one sends a boolean. 
-- find the products that have never been ordered
USE sql_store;
SELECT 
    *
FROM
    products p
WHERE
    NOT EXISTS( SELECT 
            product_id
        FROM
            orders
        WHERE
            product_id = p.product_id);
            
            
-- subqueries in the select clause.
USE sql_invoicing;

SELECT 
    invoice_id,
    invoice_total,
    (SELECT 
            AVG(invoice_total)
        FROM
            invoices) AS invoice_average,
    (invoice_total - (SELECT invoice_average)) AS difference
FROM
    invoices;
    
SELECT 
    c.client_id,
    c.name,
    (SELECT 
            SUM(invoice_total)
        FROM
            invoices
        WHERE
            client_id = c.client_id) AS total_sales,
    (SELECT 
            AVG(invoice_total)
        FROM
            invoices) AS average,
    (SELECT total_sales - average) AS difference
FROM
    clients c;


-- subqueries in from clause
        
SELECT 
    *
FROM
    (SELECT 
        client_id,
            name,
            (SELECT 
                    SUM(invoice_total)
                FROM
                    invoices
                WHERE
                    client_id = c.client_id) AS total_sales,
            (SELECT 
                    AVG(invoice_total)
                FROM
                    invoices) AS average,
            (SELECT total_sales - average) AS difference
    FROM
        clients c) AS sales_summary
WHERE
    total_sales IS NOT NULL;
    
-- -------------------------------
-- numeric functions
    -- round(num, precision), 
    -- truncate(x, precision)
    -- ceiling(x)
    -- floor(x)
    -- abs(x)
    -- rand() -> random values between 0 and 1
SELECT ROUND(5.73323, 2);
SELECT CEILING(5.2);
SELECT FLOOR(5.2);
SELECT ABS(- 5);
SELECT RAND();

-- string functions
SELECT LENGTH('sky');
SELECT UPPER('sky');
SELECT LOWER('sky');
SELECT LTRIM('   sky');
SELECT RTRIM('sky    ');
SELECT TRIM('    sky    ');
SELECT LEFT('kindergarten', 4);
SELECT RIGHT('kindergarten', 4);
-- 1 based indexing
SELECT SUBSTRING('kindergarten', 3, 5);
SELECT LOCATE('q', 'Kindergarten'); -- returns 0 if not found.
SELECT 
    REPLACE('Kindergarten',
        'garten',
        'garden');
SELECT CONCAT('first', 'last');

-- date and time functions
SELECT NOW(), CURDATE(), CURTIME();
-- extract components. these functions return integers.
SELECT 
    YEAR(NOW()),
    MONTH(NOW()),
    DAY(NOW()),
    HOUR(NOW()),
    MINUTE(NOW()),
    SECOND(NOW()); 
    
SELECT DAYNAME(NOW()), MONTHNAME(NOW());

-- portable extract function
SELECT EXTRACT(DAY FROM NOW()), EXTRACT(MONTH FROM NOW());

USE sql_store;
SELECT 
    *
FROM
    orders
WHERE
    EXTRACT(YEAR FROM order_date) >= EXTRACT(YEAR FROM NOW());
    
-- date and time formatting functions
SELECT DATE_FORMAT(NOW(), '%M %D %Y');
SELECT TIME_FORMAT(NOW(), '%H:%i %p');

-- date and time calculations
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);
SELECT DATEDIFF(NOW(), '2019-01-1'); -- returns the difference in days.
SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02');

-- ifnull and coalesce functions
USE sql_store;

SELECT 
    order_id, IFNULL(shipper_id, 'not assigned')
FROM
    orders;

SELECT 
    order_id, COALESCE(shipper_id, comments, 'not assigned')
FROM
    orders;
    
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer,
    IFNULL(phone, 'Unknown') AS phone
FROM
    customers;
    
-- if function
SELECT 
    order_id,
    order_date,
    IF(EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM NOW()),
        'Active',
        'Archived') AS category
FROM
    orders;
    
SELECT 
    p.product_id,
    p.name,
    COUNT(*) AS orders,
    IF(COUNT(*) > 1, 'Many times', 'Once') AS frequency
FROM
    products p
        JOIN
    order_items oi USING (product_id)
GROUP BY p.product_id , p.name;


-- the case operator
SELECT 
    order_id,
    CASE
        WHEN EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM NOW()) THEN 'Active'
        WHEN EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM (DATE_SUB(NOW(), INTERVAL 1 YEAR))) THEN 'Last Year'
        WHEN EXTRACT(YEAR FROM order_date) < EXTRACT(YEAR FROM (DATE_SUB(NOW(), INTERVAL 1 YEAR))) THEN 'Archived'
        ELSE 'future'
    END AS category
FROM
    orders;
    
    
-- ------------------------------------
-- create views
USE sql_invoicing;

SELECT 
    c.client_id, c.name, SUM(invoice_total) AS total_sales
FROM
    clients c
        JOIN
    invoices i USING (client_id)
GROUP BY c.client_id , c.name;

CREATE OR REPLACE VIEW sales_by_client AS
    SELECT 
        c.client_id, c.name, SUM(invoice_total) AS total_sales
    FROM
        clients c
            JOIN
        invoices i USING (client_id)
    GROUP BY c.client_id , c.name;

SELECT 
    *
FROM
    sales_by_client;
    
-- a view can be treated as a table.
-- a veiw does not store data.
-- it just provides a high level view of the table.


-- dropping or altering a view
DROP VIEW sales_by_client;

-- we can also use view in update statements if
-- the view does not have the following
    -- distinct
    -- aggregate functions
    -- group by / having
    -- union
-- such a view is called an updatable view

CREATE OR REPLACE VIEW invoices_with_balance AS
    SELECT 
        invoice_id,
        number,
        client_id,
        invoice_total,
        payment_total,
        invoice_date,
        due_date,
        payment_date,
        invoice_total - payment_total AS balance
    FROM
        invoices
    WHERE
        (invoice_total - payment_total) > 0 WITH CHECK OPTION;
    -- with check option does not let a row invalidate the condition.
        
DELETE FROM invoices_with_balance 
WHERE
    invoice_id = 1;
UPDATE invoices_with_balance 
SET 
    due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE
    invoice_id = 2;
    
    
-- with option check clause
UPDATE invoices_with_balance 
SET 
    payment_total = invoice_total
WHERE
    invoice_id = 3;
    
-- views provide abstraction
-- reduce the impact of changes in the underlying table
-- enhanced security by restricting access to data.

-- -----------------------------------
-- stored procedures -----------------
-- simply call the procedure from the application
-- optimization by the dbms
-- data security

-- creating a stored procedure
DELIMITER $$
CREATE PROCEDURE get_clients() 
BEGIN
    SELECT * FROM clients;
END$$
DELIMITER ;


CALL get_clients();


-- creaete a stored procedure
    -- called get_invoices_with_balance
    -- to return all the invoices with balance > 0
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
    SELECT * FROM invoices_with_balance 
    WHERE balance > 0;
END$$
DELIMITER ;

CALL get_invoices_with_balance();

-- dropping a stored procedure
DROP PROCEDURE IF EXISTS  get_clients;

-- parameters in procedures
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
    state CHAR(2) -- multiple are separated by a comma
)
BEGIN
-- default values for params
IF state IS NULL THEN
        SET state = 'ca';
    END IF;
SELECT 
    *
FROM
    clients c
WHERE
    c.state = state;
END $$

DELIMITER ;

CALL get_clients_by_state('ca');

DROP PROCEDURE IF EXISTS get_invoices_by_client;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client
(
    client_id INT
)
BEGIN
    
SELECT 
    *
FROM
    invoices i
WHERE
    i.client_id = client_id;
END $$

DELIMITER ;

CALL get_invoices_by_client(5);


DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments
(
    client_id INT,
    payment_method_id TINYINT
)
BEGIN
    
SELECT 
    *
FROM
    payments p
WHERE
    p.client_id = IFNULL(client_id, p.client_id) 
    AND
    p.payment_method = IFNULL(payment_method_id, p.payment_method);
END $$

DELIMITER ;

CALL get_payments(NULL, NULL);


-- updation using procedures
DROP PROCEDURE IF EXISTS make_payment;
DELIMITER $$
CREATE PROCEDURE make_payment
(
    invoice_id INT,
    payment_amount DECIMAL(9, 2),
    payment_date DATE
)
BEGIN
IF payment_amount <= 0 THEN
    SIGNAL SQLSTATE '22003' 
    SET MESSAGE_TEXT = 'Inavlid payment amount';
END IF;
UPDATE invoices i 
SET 
    i.payment_total = payment_amount,
    i.payment_date = payment_date
WHERE
    i.invoice_id = invoice_id;
END $$

DELIMITER ;

CALL make_payment(2, 100, NOW());

-- output parameters
DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client;
DELIMITER $$
CREATE PROCEDURE get_unpaid_invoices_for_client
(
    client_id INT,
    OUT invoices_count INT,
    OUT invoices_total DECIMAL(9, 2)
)
BEGIN
SELECT 
    COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
FROM
    invoices i
WHERE
    i.client_id = client_id
        AND payment_total = 0;
END $$

DELIMITER ;

-- user variables
-- stay in memory for the entire session
SET @invoices_count = 0;
SET @invocies_total = 0;
CALL get_unpaid_invoices_for_client(3,@invoices_count,@invoices_total);

-- local variable
-- defined in procedures or functions.
-- these are freed up after the procedure is called.
DROP PROCEDURE IF EXISTS get_risk_factor;

DELIMITER $$ CREATE PROCEDURE get_risk_factor()
BEGIN
    DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
    DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices;
    
    SET risk_factor = invoices_total / invoices_count * 5;
    
    SELECT risk_factor;
END $$ DELIMITER ;

CALL get_risk_factor();


-- user defined functions
-- a function can only return a single value 
DROP FUNCTION IF EXISTS get_risk_factor_for_client;
DELIMITER $$ 
CREATE FUNCTION get_risk_factor_for_client 
(
    client_id INT
)
RETURNS INTEGER -- attributes of the function
-- DETERMINISTIC
READS SQL DATA
-- MODIFIES SQL DATA
BEGIN
    DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
    DECLARE invoices_count INT;
    
SELECT 
    COUNT(*), SUM(invoice_total)
INTO invoices_count , invoices_total FROM
    invoices i
WHERE
    i.client_id = client_id;
    
    SET risk_factor = invoices_total / invoices_count * 5;
    
    
RETURN IFNULL(risk_factor, 0);
END $$ 
DELIMITER ;

SELECT GET_RISK_FACTOR_FOR_CLIENT(3);


-- triggers
-- a block of sql code that automatically gets executed before or after an insert, update, or delete statement.
DELIMITER $$
CREATE TRIGGER payments_after_insert
    AFTER INSERT ON payments
    FOR EACH ROW
    -- BEFORE INSERT ON payments
    -- BEFORE/AFTER UPDATE/DELETE ON payments
    -- triggers are row level
BEGIN
    UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    -- we can also use the OLD keyword to access the old row.
    -- we can modify any table except the table the trigger is for.
END $$

DELIMITER ;

INSERT INTO payments 
VALUES(DEFAULT, 5, 3, NOW(), 10, 1);

DELIMITER $$
CREATE TRIGGER payments_after_delete
    AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
    UPDATE invoices 
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END $$
DELIMITER ;

DELETE FROM payments 
WHERE
    payment_id IN (10 , 11);
    
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'payments%';

DROP TRIGGER IF EXISTS payments_after_delete;

-- we can also log data in a trigger
USE sql_invoicing;
CREATE TABLE payments_audit (
    client_id INT NOT NULL,
    date DATE NOT NULL,
    amount DECIMAL(9 , 2 ) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL
);

DROP TRIGGER IF EXISTS payments_after_insert;
DELIMITER $$
CREATE TRIGGER payments_after_insert
    AFTER INSERT ON payments
    FOR EACH ROW
    -- BEFORE INSERT ON payments
    -- BEFORE/AFTER UPDATE/DELETE ON payments
    -- triggers are row level
BEGIN
    UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
END $$

DELIMITER ;
INSERT INTO payments 
VALUES(DEFAULT, 5, 3, CURDATE(), 10, 1);



-- events
-- a task that gets executed according to a schedule.
SHOW VARIABLES LIKE 'event%';
SET GLOBAL event_scheduler = ON; -- or OFF

DELIMITER $$
CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE 
    -- AT '2019-05-01'
    -- EVERY 1 HOUR 
        -- optionally we can specify
        -- start and end times
    EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01'
DO BEGIN
    DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;

SHOW EVENTS;
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;

-- temporarily enable or disable an event
ALTER EVENT yearly_delete_stale_audit_rows DISABLE;