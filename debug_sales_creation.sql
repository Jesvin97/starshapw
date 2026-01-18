-- =============================================================================
-- DEBUG SALES CREATION FROM INVOICES
-- =============================================================================
-- Run these queries to debug why sales aren't being created from paid invoices

-- 1. Check recent invoices and their status
SELECT 
    id,
    number,
    status,
    customer->>'name' as customer_name,
    (totals->>'grandTotal')::decimal as amount,
    created_at,
    updated_at
FROM public.invoices 
WHERE status = 'paid'
ORDER BY updated_at DESC 
LIMIT 5;

-- 2. Check if sales table exists and recent sales
SELECT 
    id,
    sale_date,
    customer_name,
    invoice_id,
    description,
    total_amount,
    payment_status,
    created_at
FROM public.sales 
ORDER BY created_at DESC 
LIMIT 10;

-- 3. Check for sales linked to specific invoices (replace with actual invoice ID)
SELECT 
    s.id as sale_id,
    s.customer_name,
    s.total_amount,
    s.payment_status,
    i.number as invoice_number,
    i.status as invoice_status
FROM public.sales s
RIGHT JOIN public.invoices i ON s.invoice_id = i.id
WHERE i.status = 'paid'
ORDER BY i.updated_at DESC
LIMIT 5;

-- 4. Check table structure to ensure fields match
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sales' 
AND table_schema = 'public'
ORDER BY ordinal_position;
