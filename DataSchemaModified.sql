-- Встановлення мови для коректного відображення українських символів
SET client_encoding TO 'UTF8';

-- 
-- 1. ТАБЛИЦЯ APP_USER
-- 
CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    age SMALLINT NOT NULL CHECK (age >= 18),
    income_level VARCHAR(50) NOT NULL,
    CHECK (
        income_level ~* '^(Середній|Вище середнього)$'
    )
);

-- 
-- 2. ТАБЛИЦЯ EXPERT_CATEGORY
-- 
CREATE TABLE expert_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 
-- 3. ТАБЛИЦЯ EXPERT
-- 
CREATE TABLE expert (
    expert_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    qualification_area TEXT,
    category_id INT,
    CHECK (
        full_name ~* '^[А-Яа-яA-Za-z\\s’.-]+$'
    ),
    FOREIGN KEY (category_id)
        REFERENCES expert_category (category_id)
        ON DELETE SET NULL
);

-- 
-- 4. ТАБЛИЦЯ FINANCIAL_PLAN
-- 
CREATE TABLE financial_plan (
    plan_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    creation_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Активний', 'Завершений', 'Архівний')
    ),
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE
);

-- 
-- 5. ТАБЛИЦЯ FINANCIAL_OPERATION
-- 
CREATE TABLE financial_operation (
    operation_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
    op_type VARCHAR(20) NOT NULL CHECK (
        op_type IN ('Дохід', 'Витрата', 'Актив')
    ),
    operation_date DATE NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (plan_id)
        REFERENCES financial_plan (plan_id)
        ON DELETE SET NULL
);

-- 
-- 6. ТАБЛИЦЯ FINANCIAL_STATUS
-- 
CREATE TABLE financial_status (
    status_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    accuracy_score REAL CHECK (
        accuracy_score >= 0 AND accuracy_score <= 100
    ),
    assessment_date DATE NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE
);

-- 
-- 7. ТАБЛИЦЯ CONSULTATION_REQUEST
-- 
CREATE TABLE consultation_request (
    request_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    expert_id INT,
    request_text TEXT NOT NULL,
    request_date TIMESTAMP NOT NULL DEFAULT NOW(),
    payment_status VARCHAR(50) NOT NULL CHECK (
        payment_status IN ('Оплачено', 'Очікує оплати', 'Скасовано')
    ),
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (expert_id)
        REFERENCES expert (expert_id)
        ON DELETE SET NULL
);

-- 
-- 8. ТАБЛИЦЯ CREATIVE_IDEA
-- 
CREATE TABLE creative_idea (
    idea_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    idea_text TEXT,
    fixation_date TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE
);

-- 
-- 9. ТАБЛИЦЯ WEATHER_INFO
-- 
CREATE TABLE weather_info (
    weather_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    temperature REAL,
    description VARCHAR(100),
    forecast_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE
);
