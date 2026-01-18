-- Mock Data Generation SQL (5 Sets)
-- Usage: Run this in your Supabase SQL Editor

BEGIN;

DO $$
DECLARE
    v_user_id UUID;
    v_location_id UUID;
    v_customer_id UUID;
    v_vehicle_record_id UUID;
    v_battery_record_id UUID;
    v_job_card_id UUID;
    v_ticket_number VARCHAR;
    v_specific_uid UUID := '3ef1190d-91f5-4bf1-96cf-81f4ab9d485d';
    i INTEGER;
BEGIN
    -- 1. Get User and Location (Same as before)
    SELECT id INTO v_user_id FROM auth.users LIMIT 1;
    IF v_user_id IS NULL THEN
         RAISE NOTICE 'No users found in auth.users. Please create a user first.';
         RETURN;
    END IF;

    SELECT id INTO v_location_id FROM public.locations LIMIT 1;
    IF v_location_id IS NULL THEN
        v_location_id := '00000000-0000-0000-0000-000000000001';
        INSERT INTO public.locations (id, name, address, city, state, country, phone, email, is_active, timezone)
        VALUES (v_location_id, 'Main Workshop', '123 Main St', 'Bangalore', 'Karnataka', 'India', '+91 9876543210', 'main@evwheels.com', true, 'Asia/Kolkata')
        ON CONFLICT (id) DO NOTHING;
    END IF;

    -- 2. Loop to create 5 sets of data
    FOR i IN 1..5 LOOP
        
        -- Generate IDs
        v_customer_id := uuid_generate_v4();
        v_vehicle_record_id := uuid_generate_v4();
        v_battery_record_id := uuid_generate_v4();
        
        -- Use specific UID for the first iteration, random for others
        IF i = 1 THEN
            v_job_card_id := v_specific_uid;
        ELSE
            v_job_card_id := uuid_generate_v4();
        END IF;

        -- Generate Ticket Number
        v_ticket_number := 'JC-' || to_char(now(), 'YYYYMMDD') || '-' || substring(uuid_generate_v4()::text from 1 for 4);

        -- Create Customer
        INSERT INTO public.customers (
            id, name, phone, email, address, city, state, postal_code, created_by, updated_by
        ) VALUES (
            v_customer_id,
            'Mock Customer ' || i,
            '98765' || lpad(i::text, 5, '0'), -- Unique phone
            'mock.customer.' || i || '@example.com', -- Unique email
            '123 Mock Lane ' || i,
            'Mock City',
            'Mock State',
            '123456',
            v_user_id,
            v_user_id
        );

        -- Create Vehicle Record
        INSERT INTO public.vehicle_records (
            id,
            vehicle_make,
            vehicle_model,
            vehicle_reg_no,
            vehicle_year,
            customer_id,
            status,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            v_vehicle_record_id,
            CASE (i % 3) WHEN 0 THEN 'Ather' WHEN 1 THEN 'Ola' ELSE 'TVS' END, -- Varied make
            CASE (i % 3) WHEN 0 THEN '450X' WHEN 1 THEN 'S1 Pro' ELSE 'iQube' END, -- Varied model
            'KA0' || i || 'MOCK' || substring(uuid_generate_v4()::text from 1 for 4),
            2020 + (i % 4),
            v_customer_id,
            'received',
            v_location_id,
            v_user_id,
            v_user_id
        );

        -- Create Battery Record
        INSERT INTO public.battery_records (
            id,
            customer_id,
            battery_serial,
            battery_model,
            battery_make,
            status,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            v_battery_record_id,
            v_customer_id,
            'BATT-MOCK-' || i || '-' || substring(uuid_generate_v4()::text from 1 for 4),
            'Standard Pack',
            CASE (i % 3) WHEN 0 THEN 'Ather' WHEN 1 THEN 'Ola' ELSE 'TVS' END,
            'received',
            v_location_id,
            v_user_id,
            v_user_id
        );

        -- Create Job Card (Service Ticket)
        -- Using ON CONFLICT DO NOTHING to handle the case where the specific UID already exists
        INSERT INTO public.service_tickets (
            id,
            ticket_number,
            customer_id,
            symptom,
            description,
            vehicle_record_id,
            status,
            priority,
            location_id,
            created_by,
            updated_by
        ) VALUES (
            v_job_card_id,
            v_ticket_number,
            v_customer_id,
            'Issue description for job card ' || i,
            'Detailed notes for job card ' || i,
            v_vehicle_record_id,
            'reported',
            (i % 3) + 1, -- Varied priority 1-3
            v_location_id,
            v_user_id,
            v_user_id
        )
        ON CONFLICT (id) DO NOTHING;
        
        RAISE NOTICE 'Processed Job Card %: %', i, v_job_card_id;
        
    END LOOP;

END $$;
COMMIT;
