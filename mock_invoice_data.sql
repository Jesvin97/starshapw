-- Mock Invoice Data Generation
-- Usage: Run this in your Supabase SQL Editor

BEGIN;

-- 1. Create Tables if they don't exist (Based on schema analysis)

-- Inventory Items
CREATE TABLE IF NOT EXISTS public.inventory_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sku VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    item_type VARCHAR(50) NOT NULL, -- 'product' or 'service'
    category VARCHAR(100),
    sale_price DECIMAL(10,2),
    current_stock INTEGER DEFAULT 0,
    location_id UUID REFERENCES public.locations(id),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Invoices
CREATE TABLE IF NOT EXISTS public.invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(50) DEFAULT 'draft',
    customer JSONB, -- Storing full customer snapshot as per code analysis
    totals JSONB, -- Storing calculated totals
    currency VARCHAR(10) DEFAULT 'INR',
    balance_due DECIMAL(10,2),
    due_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    terms TEXT,
    location_id UUID REFERENCES public.locations(id),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Invoice Items
CREATE TABLE IF NOT EXISTS public.invoice_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    invoice_id UUID REFERENCES public.invoices(id) ON DELETE CASCADE,
    line_id VARCHAR(50),
    description TEXT,
    quantity DECIMAL(10,3),
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2) DEFAULT 0,
    tax_rate DECIMAL(5,2) DEFAULT 18,
    sgst_rate DECIMAL(5,2) DEFAULT 9,
    cgst_rate DECIMAL(5,2) DEFAULT 9,
    subtotal DECIMAL(10,2),
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    sgst_amount DECIMAL(10,2) DEFAULT 0,
    cgst_amount DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2),
    inventory_item_id UUID REFERENCES public.inventory_items(id),
    inventory_item_name TEXT,
    inventory_item_type VARCHAR(50),
    inventory_item_category TEXT
);

-- 2. Generate Data
DO $$
DECLARE
    v_user_id UUID;
    v_location_id UUID;
    v_customer_record RECORD;
    v_invoice_id UUID;
    v_inventory_product_id UUID;
    v_inventory_service_id UUID;
    v_invoice_number VARCHAR;
    i INTEGER;
BEGIN
    -- Get User and Location
    SELECT id INTO v_user_id FROM auth.users LIMIT 1;
    SELECT id INTO v_location_id FROM public.locations LIMIT 1;

    -- Create Mock Inventory Items (Products)
    INSERT INTO public.inventory_items (name, sku, item_type, category, sale_price, current_stock, location_id, created_by, updated_by)
    VALUES 
    ('Lithium Cell 18650', 'PROD-BAT-001', 'product', 'Battery', 250.00, 100, v_location_id, v_user_id, v_user_id),
    ('BMS 48V', 'PROD-BMS-001', 'product', 'Electronics', 1500.00, 20, v_location_id, v_user_id, v_user_id),
    ('Brake Pad Set', 'PROD-BRK-001', 'product', 'Spares', 450.00, 50, v_location_id, v_user_id, v_user_id)
    ON CONFLICT (sku) DO NOTHING;
    
    -- Create Mock Inventory Items (Services)
    INSERT INTO public.inventory_items (name, sku, item_type, category, sale_price, location_id, created_by, updated_by)
    VALUES 
    ('General Service', 'SERV-GEN-001', 'service', 'Service', 850.00, v_location_id, v_user_id, v_user_id),
    ('Battery Diagnostics', 'SERV-BAT-001', 'service', 'Diagnostics', 500.00, v_location_id, v_user_id, v_user_id),
    ('Wheel Alignment', 'SERV-WHL-001', 'service', 'Service', 300.00, v_location_id, v_user_id, v_user_id)
    ON CONFLICT (sku) DO NOTHING;

    -- Get IDs for later use
    SELECT id INTO v_inventory_product_id FROM public.inventory_items WHERE sku = 'PROD-BAT-001' LIMIT 1;
    SELECT id INTO v_inventory_service_id FROM public.inventory_items WHERE sku = 'SERV-GEN-001' LIMIT 1;

    -- Loop through recent customers to create invoices
    FOR v_customer_record IN SELECT * FROM public.customers ORDER BY created_at DESC LIMIT 5 LOOP
        
        v_invoice_id := uuid_generate_v4();
        v_invoice_number := 'INV-' || to_char(now(), 'YYYYMMDD') || '-' || substring(uuid_generate_v4()::text from 1 for 4);

        -- Create Invoice
        INSERT INTO public.invoices (
            id, number, status, customer, totals, balance_due, due_date, location_id, created_by, updated_by
        ) VALUES (
            v_invoice_id,
            v_invoice_number,
            'draft',
            jsonb_build_object(
                'id', v_customer_record.id,
                'name', v_customer_record.name,
                'email', v_customer_record.email,
                'phone', v_customer_record.phone,
                'address', v_customer_record.address
            ),
            jsonb_build_object(
                'subtotal', 1100.00,
                'taxTotal', 198.00,
                'grandTotal', 1298.00
            ),
            1298.00,
            NOW() + INTERVAL '30 days',
            v_location_id,
            v_user_id,
            v_user_id
        );

        -- Add Invoice Item 1 (Product)
        INSERT INTO public.invoice_items (
            invoice_id, line_id, description, quantity, unit_price, subtotal, tax_amount, total,
            inventory_item_id, inventory_item_name, inventory_item_type, inventory_item_category
        ) VALUES (
            v_invoice_id, uuid_generate_v4(), 'Lithium Cell 18650', 1, 250.00, 250.00, 45.00, 295.00,
            v_inventory_product_id, 'Lithium Cell 18650', 'product', 'Battery'
        );

        -- Add Invoice Item 2 (Service)
        INSERT INTO public.invoice_items (
            invoice_id, line_id, description, quantity, unit_price, subtotal, tax_amount, total,
            inventory_item_id, inventory_item_name, inventory_item_type, inventory_item_category
        ) VALUES (
            v_invoice_id, uuid_generate_v4(), 'General Service', 1, 850.00, 850.00, 153.00, 1003.00,
            v_inventory_service_id, 'General Service', 'service', 'Service'
        );
        
        RAISE NOTICE 'Created Invoice % for Customer %', v_invoice_number, v_customer_record.name;
        
    END LOOP;

END $$;
COMMIT;
