-- =============================================================================
-- FIX SALES TABLE SCHEMA - ADD MISSING ADJUSTMENT_AMOUNT & FIX COLUMN NAMES
-- =============================================================================

DO $$
BEGIN
    -- 1. Add adjustment_amount column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'sales' 
        AND table_schema = 'public' 
        AND column_name = 'adjustment_amount'
    ) THEN
        ALTER TABLE public.sales ADD COLUMN adjustment_amount DECIMAL(10,2) DEFAULT 0 CHECK (adjustment_amount >= 0);
        RAISE NOTICE 'Added adjustment_amount column to sales table';
    ELSE
        RAISE NOTICE 'adjustment_amount column already exists';
    END IF;

    -- 2. Handle job_card_id -> service_ticket_id rename
    -- Check if job_card_id exists and service_ticket_id does NOT exist
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'sales' 
        AND column_name = 'job_card_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'sales' 
        AND column_name = 'service_ticket_id'
    ) THEN
        ALTER TABLE public.sales RENAME COLUMN job_card_id TO service_ticket_id;
        RAISE NOTICE 'Renamed job_card_id to service_ticket_id';
    ELSIF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'sales' 
        AND column_name = 'service_ticket_id'
    ) THEN
        -- If neither exists (unlikely given previous create script), add it
        ALTER TABLE public.sales ADD COLUMN service_ticket_id UUID; -- References service tickets
        RAISE NOTICE 'Added service_ticket_id column';
    ELSE
        RAISE NOTICE 'service_ticket_id column already exists';
    END IF;

END $$;

-- Verify the final structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sales' 
AND table_schema = 'public'
ORDER BY ordinal_position;
