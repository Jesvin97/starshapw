-- Test query to check current enum values in database
-- Run this first in Supabase SQL Editor to see what enum values are available

-- Check expense_category enum values
SELECT unnest(enum_range(NULL::expense_category)) as expense_categories;

-- Check payment_method enum values  
SELECT unnest(enum_range(NULL::payment_method)) as payment_methods;

-- Alternative query to check enum values
SELECT 
    e.enumlabel as enum_value,
    t.typname as enum_name
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE t.typname IN ('expense_category', 'payment_method')
ORDER BY t.typname, e.enumsortorder;
