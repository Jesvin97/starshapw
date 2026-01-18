-- Test script to verify customer_bringing column functionality
-- Run this in your Supabase SQL editor to test

-- 1. Check if the column exists and enum is created
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'service_tickets' AND column_name = 'customer_bringing';

-- 2. Check enum values
SELECT unnest(enum_range(NULL::customer_bringing_type)) AS enum_values;

-- 3. Test inserting a ticket with customer_bringing = 'vehicle'
INSERT INTO service_tickets (
    customer_id, 
    symptom, 
    customer_complaint,
    vehicle_make,
    vehicle_model,
    customer_bringing,
    created_by,
    updated_by
) VALUES (
    (SELECT id FROM customers LIMIT 1), -- Use first available customer
    'Test vehicle issue',
    'Customer brought vehicle for service',
    'TVS',
    'iQube',
    'vehicle'::customer_bringing_type,
    (SELECT id FROM auth.users LIMIT 1), -- Use first available user
    (SELECT id FROM auth.users LIMIT 1)
) RETURNING id, ticket_number, customer_bringing;

-- 4. Test inserting a ticket with customer_bringing = 'battery'
INSERT INTO service_tickets (
    customer_id, 
    symptom, 
    customer_complaint,
    customer_bringing,
    created_by,
    updated_by
) VALUES (
    (SELECT id FROM customers LIMIT 1), -- Use first available customer
    'Test battery issue',
    'Customer brought battery packs for service',
    'battery'::customer_bringing_type,
    (SELECT id FROM auth.users LIMIT 1), -- Use first available user
    (SELECT id FROM auth.users LIMIT 1)
) RETURNING id, ticket_number, customer_bringing;

-- 5. Test inserting a ticket with customer_bringing = 'both'
INSERT INTO service_tickets (
    customer_id, 
    symptom, 
    customer_complaint,
    vehicle_make,
    vehicle_model,
    customer_bringing,
    created_by,
    updated_by
) VALUES (
    (SELECT id FROM customers LIMIT 1), -- Use first available customer
    'Test both vehicle and battery',
    'Customer brought both vehicle and separate batteries',
    'Bajaj',
    'Chetak',
    'both'::customer_bringing_type,
    (SELECT id FROM auth.users LIMIT 1), -- Use first available user
    (SELECT id FROM auth.users LIMIT 1)
) RETURNING id, ticket_number, customer_bringing;

-- 6. Query to see all tickets with their customer_bringing values
SELECT 
    ticket_number,
    customer_bringing,
    vehicle_make,
    battery_case_id,
    vehicle_case_id,
    created_at
FROM service_tickets 
WHERE customer_bringing IS NOT NULL
ORDER BY created_at DESC
LIMIT 10;
