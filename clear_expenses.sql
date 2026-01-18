-- Clear Expenses Table and Reset Sequence
-- This will delete all expense records and reset the expense_number sequence

-- Step 1: Delete all existing expense records
DELETE FROM public.expenses;

-- Step 2: Reset the expense_number sequence to start fresh
-- This ensures the next expense_number will be EXP-2025-0001
ALTER SEQUENCE expenses_expense_number_seq RESTART WITH 1;

-- Step 3: Show confirmation
SELECT 
    'All expense records deleted and sequence reset.' as status,
    'Next expense_number will be: EXP-2025-0001' as next_number;
