-- Check what values are allowed in payment_method_enum
SELECT 
    t.typname AS enum_name,
    e.enumlabel AS enum_value
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid  
WHERE t.typname = 'payment_method_enum'
ORDER BY e.enumsortorder;
