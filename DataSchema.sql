-- Встановлення мови для коректного відображення українських символів
SET client_encoding TO 'UTF8';

-- =================================================================================
-- 1. ТАБЛИЦЯ USER
-- =================================================================================
CREATE TABLE "USER" (
    user_id           SERIAL PRIMARY KEY,
    age               SMALLINT NOT NULL CHECK (age >= 18),
    income_level      VARCHAR(50) NOT NULL,
    
    -- Обмеження на рівень доходу, використовуючи REGEXP (Українські значення)
    CHECK (income_level ~* '^(Середній|Вище середнього)$')
);

-- =================================================================================
-- 2. ТАБЛИЦЯ EXPERT_CATEGORY
-- =================================================================================
CREATE TABLE EXPERT_CATEGORY (
    category_id       SERIAL PRIMARY KEY,
    category_name     VARCHAR(100) NOT NULL
);

-- =================================================================================
-- 3. ТАБЛИЦЯ EXPERT
-- =================================================================================
CREATE TABLE EXPERT (
    expert_id         SERIAL PRIMARY KEY,
    name              VARCHAR(100) NOT NULL,
    qualification_area TEXT,
    category_id       INT,
    
    -- Обмеження на ім'я, використовуючи REGEXP (Дозволяє українські/латинські літери та символи)
    CHECK (name ~* '^[А-Яа-яA-Za-z\s’.-]+$'),
    
    FOREIGN KEY (category_id) REFERENCES EXPERT_CATEGORY (category_id) ON DELETE SET NULL
);

-- =================================================================================
-- 4. ТАБЛИЦЯ FINANCIAL_PLAN
-- =================================================================================
CREATE TABLE FINANCIAL_PLAN (
    plan_id           SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    creation_date     DATE NOT NULL,
    status            VARCHAR(20) NOT NULL CHECK (status IN ('Активний', 'Завершений', 'Архівний')),
    
    FOREIGN KEY (user_id) REFERENCES "USER" (user_id) ON DELETE CASCADE
);

-- =================================================================================
-- 5. ТАБЛИЦЯ FINANCIAL_OPERATION (Income, Expense, Asset)
-- =================================================================================
CREATE TABLE FINANCIAL_OPERATION (
    operation_id      SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    plan_id           INT,
    amount            NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
    type              VARCHAR(20) NOT NULL CHECK (type IN ('Дохід', 'Витрата', 'Актив')),
    operation_date    DATE NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES "USER" (user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES FINANCIAL_PLAN (plan_id) ON DELETE SET NULL
);

-- =================================================================================
-- 6. ТАБЛИЦЯ FINANCIAL_STATUS (Assessment of Accuracy)
-- =================================================================================
CREATE TABLE FINANCIAL_STATUS (
    status_id         SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    accuracy_score    REAL CHECK (accuracy_score >= 0 AND accuracy_score <= 100),
    assessment_date   DATE NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES "USER" (user_id) ON DELETE CASCADE
);

-- =================================================================================
-- 7. ТАБЛИЦЯ CONSULTATION_REQUEST
-- =================================================================================
CREATE TABLE CONSULTATION_REQUEST (
    request_id        SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    expert_id         INT,
    request_text      TEXT NOT NULL,
    request_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    payment_status    VARCHAR(50) NOT NULL CHECK (payment_status IN ('Оплачено', 'Очікує оплати', 'Скасовано')),
    
    FOREIGN KEY (user_id) REFERENCES "USER" (user_id) ON DELETE CASCADE,
    FOREIGN KEY (expert_id) REFERENCES EXPERT (expert_id) ON DELETE SET NULL
);

-- =================================================================================
-- 8. ТАБЛИЦЯ CREATIVE_IDEA
-- =================================================================================
CREATE TABLE CREATIVE_IDEA (
    idea_id           SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    idea_text         TEXT,
    fixation_date     TIMESTAMP NOT NULL DEFAULT NOW(),
    
    FOREIGN KEY (user_id) REFERENCES "USER" (user_id) ON DELETE CASCADE
);

-- =================================================================================
-- 9. ТАБЛИЦЯ WEATHER_INFO
-- =================================================================================
CREATE TABLE WEATHER_INFO (
    weather_id        SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    temperature       REAL,
    description       VARCHAR(100),
    forecast_date     TIMESTAMP NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES "USER" (user_id) ON DELETE CASCADE
);