-- ============================================================
-- APPLICATION SUPPORT INCIDENT SIMULATOR
-- INCIDENT INVESTIGATION QUERIES
-- Oracle Database 19c
-- ============================================================


-- ============================================================
-- 1. CHECK CUSTOMER STATUS
-- ============================================================

SELECT
    customer_id,
    first_name,
    last_name,
    status
FROM customers
WHERE customer_id = 1002;


-- ============================================================
-- 2. CHECK ACCOUNT STATUS AND BALANCE
-- ============================================================

SELECT
    account_id,
    customer_id,
    account_type,
    balance,
    status
FROM accounts
WHERE account_id = 2002;


-- ============================================================
-- 3. CHECK ALL TRANSACTIONS FOR THE ACCOUNT
-- ============================================================

SELECT
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
FROM transactions
WHERE account_id = 2002
ORDER BY transaction_date;


-- ============================================================
-- 4. CHECK THE FAILED TRANSACTION
-- ============================================================

SELECT
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
FROM transactions
WHERE transaction_id = 3006;


-- ============================================================
-- 5. CHECK PAYMENT ASSOCIATED WITH TRANSACTION
-- ============================================================

SELECT
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
FROM payments
WHERE transaction_id = 3006;


-- ============================================================
-- 6. FULL INCIDENT INVESTIGATION
-- CUSTOMER → ACCOUNT → TRANSACTION → PAYMENT
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.status AS customer_status,

    a.account_id,
    a.account_type,
    a.balance,
    a.status AS account_status,

    t.transaction_id,
    t.transaction_type,
    t.amount,
    t.transaction_status,
    t.transaction_date,

    p.payment_id,
    p.payment_method,
    p.payment_status,
    p.processed_date

FROM customers c

JOIN accounts a
    ON c.customer_id = a.customer_id

JOIN transactions t
    ON a.account_id = t.account_id

JOIN payments p
    ON t.transaction_id = p.transaction_id

WHERE t.transaction_id = 3006;


-- ============================================================
-- 7. FIND ALL FAILED TRANSACTIONS
-- ============================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_status,
    transaction_date
FROM transactions
WHERE transaction_status = 'FAILED'
ORDER BY transaction_date;


-- ============================================================
-- 8. FIND ALL FAILED PAYMENTS
-- ============================================================

SELECT
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
FROM payments
WHERE payment_status = 'FAILED';


-- ============================================================
-- 9. CHECK FOR CLOSED ACCOUNTS WITH TRANSACTIONS
-- ============================================================

SELECT
    a.account_id,
    a.customer_id,
    a.status AS account_status,
    t.transaction_id,
    t.amount,
    t.transaction_status
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
WHERE a.status = 'CLOSED';


-- ============================================================
-- 10. CHECK FAILED TRANSACTIONS BY ACCOUNT
-- ============================================================

SELECT
    a.account_id,
    a.customer_id,
    COUNT(t.transaction_id) AS failed_transactions
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
WHERE t.transaction_status = 'FAILED'
GROUP BY
    a.account_id,
    a.customer_id
ORDER BY failed_transactions DESC;