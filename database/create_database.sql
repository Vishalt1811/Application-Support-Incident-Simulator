-- ============================================================
-- APPLICATION SUPPORT INCIDENT SIMULATOR
-- Oracle Database 19c
-- Schema: APP_SUPPORT
-- ============================================================

SET SERVEROUTPUT ON;

-- ============================================================
-- CLEANUP
-- ============================================================
-- Drop child tables first because of foreign-key relationships.

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE payments CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE transactions CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE accounts CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- ============================================================
-- DROP SEQUENCES
-- ============================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE payment_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE account_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE customer_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE customers (
    customer_id NUMBER(10)
        CONSTRAINT pk_customers PRIMARY KEY,

    first_name VARCHAR2(50)
        CONSTRAINT nn_customers_first_name NOT NULL,

    last_name VARCHAR2(50)
        CONSTRAINT nn_customers_last_name NOT NULL,

    email VARCHAR2(100)
        CONSTRAINT nn_customers_email NOT NULL,

    status VARCHAR2(20)
        CONSTRAINT nn_customers_status NOT NULL
);

-- ============================================================
-- CUSTOMER SEQUENCE
-- ============================================================

CREATE SEQUENCE customer_seq
    START WITH 1001
    INCREMENT BY 1
    NOCACHE;

-- ============================================================
-- ACCOUNTS
-- ============================================================

CREATE TABLE accounts (
    account_id NUMBER(10)
        CONSTRAINT pk_accounts PRIMARY KEY,

    customer_id NUMBER(10)
        CONSTRAINT nn_accounts_customer_id NOT NULL,

    account_type VARCHAR2(20)
        CONSTRAINT nn_accounts_type NOT NULL,

    balance NUMBER(12,2)
        CONSTRAINT nn_accounts_balance NOT NULL,

    status VARCHAR2(20)
        CONSTRAINT nn_accounts_status NOT NULL,

    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ============================================================
-- ACCOUNT SEQUENCE
-- ============================================================

CREATE SEQUENCE account_seq
    START WITH 2001
    INCREMENT BY 1
    NOCACHE;

-- ============================================================
-- TRANSACTIONS
-- ============================================================

CREATE TABLE transactions (
    transaction_id NUMBER(10)
        CONSTRAINT pk_transactions PRIMARY KEY,

    account_id NUMBER(10)
        CONSTRAINT nn_transactions_account_id NOT NULL,

    transaction_type VARCHAR2(20)
        CONSTRAINT nn_transactions_type NOT NULL,

    amount NUMBER(12,2)
        CONSTRAINT nn_transactions_amount NOT NULL,

    transaction_status VARCHAR2(20)
        CONSTRAINT nn_transactions_status NOT NULL,

    transaction_date TIMESTAMP
        CONSTRAINT nn_transactions_date NOT NULL,

    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

-- ============================================================
-- TRANSACTION SEQUENCE
-- ============================================================

CREATE SEQUENCE transaction_seq
    START WITH 3001
    INCREMENT BY 1
    NOCACHE;

-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE payments (
    payment_id NUMBER(10)
        CONSTRAINT pk_payments PRIMARY KEY,

    transaction_id NUMBER(10)
        CONSTRAINT nn_payments_transaction_id NOT NULL,

    payment_method VARCHAR2(30)
        CONSTRAINT nn_payments_method NOT NULL,

    payment_status VARCHAR2(20)
        CONSTRAINT nn_payments_status NOT NULL,

    processed_date TIMESTAMP,

    CONSTRAINT fk_payments_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES transactions(transaction_id)
);

-- ============================================================
-- PAYMENT SEQUENCE
-- ============================================================

CREATE SEQUENCE payment_seq
    START WITH 4001
    INCREMENT BY 1
    NOCACHE;

-- ============================================================
-- INSERT CUSTOMERS
-- ============================================================

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    status
)
VALUES (
    customer_seq.NEXTVAL,
    'John',
    'Smith',
    'john.smith@email.com',
    'ACTIVE'
);

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    status
)
VALUES (
    customer_seq.NEXTVAL,
    'Sarah',
    'Wilson',
    'sarah.wilson@email.com',
    'ACTIVE'
);

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    status
)
VALUES (
    customer_seq.NEXTVAL,
    'Michael',
    'Brown',
    'michael.brown@email.com',
    'ACTIVE'
);

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    status
)
VALUES (
    customer_seq.NEXTVAL,
    'Emily',
    'Davis',
    'emily.davis@email.com',
    'ACTIVE'
);

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    status
)
VALUES (
    customer_seq.NEXTVAL,
    'David',
    'Taylor',
    'david.taylor@email.com',
    'INACTIVE'
);

-- ============================================================
-- INSERT ACCOUNTS
-- ============================================================

INSERT INTO accounts (
    account_id,
    customer_id,
    account_type,
    balance,
    status
)
VALUES (
    account_seq.NEXTVAL,
    1001,
    'CHEQUING',
    5000.00,
    'ACTIVE'
);

INSERT INTO accounts (
    account_id,
    customer_id,
    account_type,
    balance,
    status
)
VALUES (
    account_seq.NEXTVAL,
    1002,
    'CHEQUING',
    7500.00,
    'ACTIVE'
);

INSERT INTO accounts (
    account_id,
    customer_id,
    account_type,
    balance,
    status
)
VALUES (
    account_seq.NEXTVAL,
    1003,
    'SAVINGS',
    12000.00,
    'ACTIVE'
);

INSERT INTO accounts (
    account_id,
    customer_id,
    account_type,
    balance,
    status
)
VALUES (
    account_seq.NEXTVAL,
    1004,
    'CHEQUING',
    3500.00,
    'ACTIVE'
);

INSERT INTO accounts (
    account_id,
    customer_id,
    account_type,
    balance,
    status
)
VALUES (
    account_seq.NEXTVAL,
    1005,
    'SAVINGS',
    1000.00,
    'CLOSED'
);

-- ============================================================
-- INSERT TRANSACTIONS
-- ============================================================

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
)
VALUES (
    transaction_seq.NEXTVAL,
    2001,
    'DEBIT',
    250.00,
    'COMPLETED',
    TIMESTAMP '2026-08-15 09:15:00'
);

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
)
VALUES (
    transaction_seq.NEXTVAL,
    2001,
    'CREDIT',
    1000.00,
    'COMPLETED',
    TIMESTAMP '2026-08-15 10:00:00'
);

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
)
VALUES (
    transaction_seq.NEXTVAL,
    2002,
    'DEBIT',
    500.00,
    'COMPLETED',
    TIMESTAMP '2026-08-15 10:30:00'
);

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
)
VALUES (
    transaction_seq.NEXTVAL,
    2003,
    'DEBIT',
    1200.00,
    'COMPLETED',
    TIMESTAMP '2026-08-15 11:00:00'
);

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
)
VALUES (
    transaction_seq.NEXTVAL,
    2004,
    'DEBIT',
    300.00,
    'PENDING',
    TIMESTAMP '2026-08-15 11:15:00'
);

INSERT INTO transactions (
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_status,
    transaction_date
)
VALUES (
    transaction_seq.NEXTVAL,
    2002,
    'DEBIT',
    750.00,
    'FAILED',
    TIMESTAMP '2026-08-15 11:30:00'
);

-- ============================================================
-- INSERT PAYMENTS
-- ============================================================

INSERT INTO payments (
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
)
VALUES (
    payment_seq.NEXTVAL,
    3001,
    'DEBIT_CARD',
    'SUCCESS',
    TIMESTAMP '2026-08-15 09:16:00'
);

INSERT INTO payments (
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
)
VALUES (
    payment_seq.NEXTVAL,
    3002,
    'ONLINE_BANKING',
    'SUCCESS',
    TIMESTAMP '2026-08-15 10:01:00'
);

INSERT INTO payments (
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
)
VALUES (
    payment_seq.NEXTVAL,
    3003,
    'DEBIT_CARD',
    'SUCCESS',
    TIMESTAMP '2026-08-15 10:31:00'
);

INSERT INTO payments (
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
)
VALUES (
    payment_seq.NEXTVAL,
    3004,
    'ONLINE_BANKING',
    'SUCCESS',
    TIMESTAMP '2026-08-15 11:01:00'
);

INSERT INTO payments (
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
)
VALUES (
    payment_seq.NEXTVAL,
    3005,
    'DEBIT_CARD',
    'PENDING',
    NULL
);

INSERT INTO payments (
    payment_id,
    transaction_id,
    payment_method,
    payment_status,
    processed_date
)
VALUES (
    payment_seq.NEXTVAL,
    3006,
    'DEBIT_CARD',
    'FAILED',
    NULL
);

COMMIT;

-- ============================================================
-- VERIFICATION
-- ============================================================

SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS record_count
FROM customers
UNION ALL
SELECT 'ACCOUNTS', COUNT(*)
FROM accounts
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*)
FROM transactions
UNION ALL
SELECT 'PAYMENTS', COUNT(*)
FROM payments;

PROMPT ============================================
PROMPT Database setup completed successfully.
PROMPT ============================================