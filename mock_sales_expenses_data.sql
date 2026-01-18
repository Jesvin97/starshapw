-- Mock Sales and Expenses Data Generation
-- Usage: Run this in your Supabase SQL Editor
-- Prerequisites: Run mock_data_generation.sql and mock_invoice_data.sql first

BEGIN;

DO $$
DECLARE
    v_user_id UUID;
    v_location_id UUID;
    v_customer_record RECORD;
    v_invoice_record RECORD;
    v_job_card_record RECORD;
    i INTEGER;
BEGIN
    -- Get User and Location
    SELECT id INTO v_user_id FROM auth.users LIMIT 1;
    IF v_user_id IS NULL THEN
         RAISE NOTICE 'No users found in auth.users. Please create a user first.';
         RETURN;
    END IF;

    SELECT id INTO v_location_id FROM public.locations LIMIT 1;
    IF v_location_id IS NULL THEN
        v_location_id := '00000000-0000-0000-0000-000000000001';
    END IF;

    -- ========================================
    -- SALES DATA
    -- ========================================
    
    RAISE NOTICE 'Creating Sales records...';
    
    -- Sales linked to invoices (5 records)
    FOR v_invoice_record IN 
        SELECT i.id, i.number, i.customer, i.totals 
        FROM public.invoices i 
        ORDER BY i.created_at DESC 
        LIMIT 5 
    LOOP
        INSERT INTO public.sales (
            date,
            customer_id,
            customer_name,
            invoice_id,
            description,
            amount,
            tax_amount,
            payment_method,
            status,
            category,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - (random() * 30)::integer, -- Random date within last 30 days
            (v_invoice_record.customer->>'id')::UUID,
            v_invoice_record.customer->>'name',
            v_invoice_record.id::TEXT,
            'Payment for Invoice ' || v_invoice_record.number,
            (v_invoice_record.totals->>'grandTotal')::DECIMAL,
            ((v_invoice_record.totals->>'grandTotal')::DECIMAL * 0.18), -- 18% tax
            CASE (random() * 4)::integer
                WHEN 0 THEN 'cash'
                WHEN 1 THEN 'card'
                WHEN 2 THEN 'upi'
                ELSE 'bank_transfer'
            END,
            'completed',
            CASE (random() * 3)::integer
                WHEN 0 THEN 'service'
                WHEN 1 THEN 'parts'
                ELSE 'battery'
            END,
            'Invoice payment received',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    -- Sales linked to job cards (5 records)
    FOR v_job_card_record IN 
        SELECT st.id, st.ticket_number, st.customer_id, c.name as customer_name
        FROM public.service_tickets st
        LEFT JOIN public.customers c ON c.id = st.customer_id
        ORDER BY st.created_at DESC 
        LIMIT 5 
    LOOP
        INSERT INTO public.sales (
            date,
            customer_id,
            customer_name,
            job_card_id,
            description,
            amount,
            tax_amount,
            payment_method,
            status,
            category,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - (random() * 30)::integer,
            v_job_card_record.customer_id,
            v_job_card_record.customer_name,
            v_job_card_record.id,
            'Service payment for Job Card ' || v_job_card_record.ticket_number,
            500 + (random() * 2000)::DECIMAL(10,2), -- Random amount between 500-2500
            (500 + (random() * 2000)::DECIMAL(10,2)) * 0.18,
            CASE (random() * 4)::integer
                WHEN 0 THEN 'cash'
                WHEN 1 THEN 'card'
                WHEN 2 THEN 'upi'
                ELSE 'bank_transfer'
            END,
            'completed',
            'service',
            'Job card service payment',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    -- Standalone sales (10 records - walk-in customers)
    FOR i IN 1..10 LOOP
        INSERT INTO public.sales (
            date,
            customer_name,
            description,
            amount,
            tax_amount,
            discount,
            payment_method,
            status,
            category,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - (random() * 60)::integer, -- Random date within last 60 days
            'Walk-in Customer ' || i,
            CASE (random() * 5)::integer
                WHEN 0 THEN 'Battery replacement service'
                WHEN 1 THEN 'Brake pad replacement'
                WHEN 2 THEN 'General vehicle service'
                WHEN 3 THEN 'Battery diagnostics'
                ELSE 'Spare parts sale'
            END,
            300 + (random() * 1500)::DECIMAL(10,2), -- Random amount 300-1800
            (300 + (random() * 1500)::DECIMAL(10,2)) * 0.18,
            CASE WHEN random() > 0.7 THEN (random() * 100)::DECIMAL(10,2) ELSE 0 END, -- 30% chance of discount
            CASE (random() * 4)::integer
                WHEN 0 THEN 'cash'
                WHEN 1 THEN 'card'
                WHEN 2 THEN 'upi'
                ELSE 'bank_transfer'
            END,
            CASE 
                WHEN random() > 0.9 THEN 'pending'
                WHEN random() > 0.95 THEN 'cancelled'
                ELSE 'completed'
            END,
            CASE (random() * 4)::integer
                WHEN 0 THEN 'service'
                WHEN 1 THEN 'parts'
                WHEN 2 THEN 'battery'
                ELSE 'other'
            END,
            'Walk-in sale',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    RAISE NOTICE 'Created 20 Sales records';

    -- ========================================
    -- EXPENSES DATA
    -- ========================================
    
    RAISE NOTICE 'Creating Expenses records...';

    -- Inventory purchases (5 records)
    FOR i IN 1..5 LOOP
        INSERT INTO public.expenses (
            date,
            vendor_name,
            description,
            amount,
            tax_amount,
            category,
            subcategory,
            payment_method,
            receipt_number,
            is_recurring,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - (random() * 45)::integer,
            CASE (random() * 3)::integer
                WHEN 0 THEN 'Battery Suppliers Ltd'
                WHEN 1 THEN 'EV Parts Wholesale'
                ELSE 'Auto Components Inc'
            END,
            CASE (random() * 4)::integer
                WHEN 0 THEN 'Lithium cells bulk purchase'
                WHEN 1 THEN 'BMS units procurement'
                WHEN 2 THEN 'Brake pads stock'
                ELSE 'General spare parts'
            END,
            5000 + (random() * 20000)::DECIMAL(10,2), -- 5000-25000
            (5000 + (random() * 20000)::DECIMAL(10,2)) * 0.18,
            'inventory',
            'Parts',
            CASE (random() * 2)::integer
                WHEN 0 THEN 'bank_transfer'
                ELSE 'cheque'
            END,
            'INV-' || to_char(now(), 'YYYYMMDD') || '-' || i,
            false,
            'Inventory purchase for stock',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    -- Utilities (3 recurring)
    INSERT INTO public.expenses (date, vendor_name, description, amount, tax_amount, category, payment_method, receipt_number, is_recurring, recurring_frequency, notes, location_id, created_by, updated_by)
    VALUES 
    (CURRENT_DATE - 5, 'City Power Company', 'Monthly electricity bill', 3500.00, 630.00, 'utilities', 'bank_transfer', 'ELEC-' || to_char(now(), 'YYYYMM'), true, 'monthly', 'Workshop electricity', v_location_id, v_user_id, v_user_id),
    (CURRENT_DATE - 3, 'Water Department', 'Monthly water bill', 800.00, 144.00, 'utilities', 'bank_transfer', 'WATER-' || to_char(now(), 'YYYYMM'), true, 'monthly', 'Workshop water supply', v_location_id, v_user_id, v_user_id),
    (CURRENT_DATE - 7, 'Telecom Services', 'Internet and phone', 1500.00, 270.00, 'utilities', 'bank_transfer', 'TEL-' || to_char(now(), 'YYYYMM'), true, 'monthly', 'Office connectivity', v_location_id, v_user_id, v_user_id);

    -- Rent (1 recurring)
    INSERT INTO public.expenses (date, vendor_name, description, amount, category, payment_method, is_recurring, recurring_frequency, notes, location_id, created_by, updated_by)
    VALUES (CURRENT_DATE - 1, 'Property Management Co', 'Workshop rent', 25000.00, 'rent', 'bank_transfer', true, 'monthly', 'Monthly workshop rent', v_location_id, v_user_id, v_user_id);

    -- Salaries (3 records)
    FOR i IN 1..3 LOOP
        INSERT INTO public.expenses (
            date,
            vendor_name,
            description,
            amount,
            category,
            payment_method,
            is_recurring,
            recurring_frequency,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - 2,
            'Employee ' || i,
            CASE i
                WHEN 1 THEN 'Senior Technician salary'
                WHEN 2 THEN 'Junior Technician salary'
                ELSE 'Front desk staff salary'
            END,
            CASE i
                WHEN 1 THEN 35000.00
                WHEN 2 THEN 22000.00
                ELSE 18000.00
            END,
            'salary',
            'bank_transfer',
            true,
            'monthly',
            'Monthly salary payment',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    -- Maintenance (4 records)
    FOR i IN 1..4 LOOP
        INSERT INTO public.expenses (
            date,
            vendor_name,
            description,
            amount,
            tax_amount,
            category,
            payment_method,
            receipt_number,
            is_recurring,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - (random() * 30)::integer,
            CASE (random() * 2)::integer
                WHEN 0 THEN 'Workshop Maintenance Services'
                ELSE 'Equipment Repair Co'
            END,
            CASE (random() * 3)::integer
                WHEN 0 THEN 'Tool maintenance and calibration'
                WHEN 1 THEN 'Workshop equipment repair'
                ELSE 'Building maintenance'
            END,
            1000 + (random() * 4000)::DECIMAL(10,2),
            (1000 + (random() * 4000)::DECIMAL(10,2)) * 0.18,
            'maintenance',
            CASE (random() * 2)::integer WHEN 0 THEN 'cash' ELSE 'card' END,
            'MAINT-' || i,
            false,
            'Workshop maintenance',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    -- Marketing (2 records)
    INSERT INTO public.expenses (date, vendor_name, description, amount, tax_amount, category, payment_method, is_recurring, notes, location_id, created_by, updated_by)
    VALUES 
    (CURRENT_DATE - 10, 'Digital Marketing Agency', 'Social media advertising', 8000.00, 1440.00, 'marketing', 'bank_transfer', false, 'Monthly social media campaign', v_location_id, v_user_id, v_user_id),
    (CURRENT_DATE - 15, 'Print Media Co', 'Flyers and brochures', 3500.00, 630.00, 'marketing', 'card', false, 'Marketing materials', v_location_id, v_user_id, v_user_id);

    -- Office supplies (3 records)
    FOR i IN 1..3 LOOP
        INSERT INTO public.expenses (
            date,
            vendor_name,
            description,
            amount,
            tax_amount,
            category,
            payment_method,
            is_recurring,
            notes,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            CURRENT_DATE - (random() * 20)::integer,
            'Office Supplies Store',
            CASE (random() * 3)::integer
                WHEN 0 THEN 'Stationery and office supplies'
                WHEN 1 THEN 'Printer ink and paper'
                ELSE 'Cleaning supplies'
            END,
            500 + (random() * 1500)::DECIMAL(10,2),
            (500 + (random() * 1500)::DECIMAL(10,2)) * 0.18,
            'office_supplies',
            'cash',
            false,
            'Office supplies purchase',
            v_location_id,
            v_user_id,
            v_user_id
        );
    END LOOP;

    -- Transport (2 records)
    INSERT INTO public.expenses (date, vendor_name, description, amount, tax_amount, category, payment_method, is_recurring, notes, location_id, created_by, updated_by)
    VALUES 
    (CURRENT_DATE - 5, 'Fuel Station', 'Vehicle fuel', 2500.00, 450.00, 'transport', 'card', false, 'Service vehicle fuel', v_location_id, v_user_id, v_user_id),
    (CURRENT_DATE - 12, 'Logistics Company', 'Parts delivery charges', 1200.00, 216.00, 'transport', 'cash', false, 'Delivery of spare parts', v_location_id, v_user_id, v_user_id);

    -- Professional services (2 records)
    INSERT INTO public.expenses (date, vendor_name, description, amount, tax_amount, category, payment_method, is_recurring, notes, location_id, created_by, updated_by)
    VALUES 
    (CURRENT_DATE - 8, 'Accounting Services Ltd', 'Monthly bookkeeping', 5000.00, 900.00, 'professional_services', 'bank_transfer', true, 'Accounting and bookkeeping', v_location_id, v_user_id, v_user_id),
    (CURRENT_DATE - 20, 'Legal Consultants', 'Legal consultation', 8000.00, 1440.00, 'professional_services', 'bank_transfer', false, 'Business legal advice', v_location_id, v_user_id, v_user_id);

    RAISE NOTICE 'Created 30+ Expenses records';

    RAISE NOTICE '========================================';
    RAISE NOTICE 'Mock data generation completed successfully!';
    RAISE NOTICE 'Sales: ~20 records';
    RAISE NOTICE 'Expenses: ~30 records';
    RAISE NOTICE '========================================';

END $$;

COMMIT;
