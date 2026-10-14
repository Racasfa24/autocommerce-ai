
CREATE TABLE suppliers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    country_code VARCHAR(2),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    supplier_id BIGINT NOT NULL
        REFERENCES suppliers(id),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    sku VARCHAR(100) NOT NULL UNIQUE,
    currency VARCHAR(3) NOT NULL DEFAULT 'MXN',
    supplier_cost NUMERIC(12,2) NOT NULL
        CHECK (supplier_cost >= 0),
    sale_price NUMERIC(12,2) NOT NULL
        CHECK (sale_price >= 0),
    status VARCHAR(30) NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    external_payment_id VARCHAR(150) UNIQUE,
    currency VARCHAR(3) NOT NULL DEFAULT 'MXN',
    total NUMERIC(12,2) NOT NULL
        CHECK (total >= 0),
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL
        REFERENCES orders(id),
    product_id BIGINT NOT NULL
        REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL
        CHECK (unit_price >= 0)
);

CREATE TABLE agent_executions (
    id BIGSERIAL PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    status VARCHAR(30) NOT NULL,
    result JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_supplier
    ON products(supplier_id);

CREATE INDEX idx_orders_status
    ON orders(status);

CREATE INDEX idx_agent_executions_created
    ON agent_executions(created_at);
