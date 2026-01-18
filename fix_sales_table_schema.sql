-- =============================================================================
-- FIX SALES TABLE SCHEMA - ADD MISSING CUSTOMER_NAME COLUMN
-- =============================================================================

-- First check current table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sales' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Add the missing customer_name column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'sales' 
        AND table_schema = 'public' 
        AND column_name = 'customer_name'
    ) THEN
        ALTER TABLE public.sales ADD COLUMN customer_name VARCHAR(255);
        RAISE NOTICE 'Added customer_name column to sales table';
    ELSE
        RAISE NOTICE 'customer_name column already exists';
    END IF;
END $$;

-- Check the updated structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sales' 
AND table_schema = 'public'
ORDER BY ordinal_position;
