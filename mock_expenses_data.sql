-- Mock Expenses Data for EV Wheels Business
-- Run this in Supabase SQL Editor to populate test data
-- Total: 25 expense records covering all categories and scenarios

-- Clear existing test data to avoid conflicts
-- Uncomment the line below if you want to remove existing test data first
-- DELETE FROM public.expenses WHERE description LIKE '%[TEST]%';

-- Alternative: Clear all existing expenses (BE CAREFUL - this removes ALL expenses)
-- DELETE FROM public.expenses;

-- Reset the expense_number sequence to avoid conflicts
-- This ensures new expense numbers start fresh
SELECT setval(pg_get_serial_sequence('expenses', 'expense_number'), 1, false);

-- Insert comprehensive mock expense data
-- Using user UUID: 2a40a711-21bf-4f8e-8cee-20a925205ae1
INSERT INTO public.expenses (
    expense_date,
    vendor_name,
    description,
    amount,
    tax_amount,
    total_amount,
    category,
    payment_method,
    payment_reference,
    receipt_number,
    invoice_number,
    purpose,
    notes,
    approval_status,
    location_id,
    created_by,
    updated_by,
    created_at
) VALUES

-- SALARY EXPENSES (Monthly recurring)
('2024-11-01', 'John Doe', '[TEST] Monthly Salary - Service Technician', 25000.00, 0.00, 25000.00, 'salary_wages', 'bank_transfer', 'NEFT-SAL-001', 'SAL-2024-11-01', 'SAL-INV-001', 'Employee salary payment', 'Senior technician salary for November 2024', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-01 09:00:00'),
('2024-11-01', 'Jane Smith', '[TEST] Monthly Salary - Manager', 35000.00, 0.00, 35000.00, 'salary_wages', 'bank_transfer', 'NEFT-SAL-002', 'SAL-2024-11-02', 'SAL-INV-002', 'Manager salary payment', 'Store manager salary for November 2024', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-01 09:15:00'),
('2024-11-05', 'Rajesh Kumar', '[TEST] Overtime Payment - Weekend Work', 3500.00, 0.00, 3500.00, 'salary_wages', 'cash', 'CASH-001', NULL, NULL, 'Overtime payment', 'Extra payment for emergency repair work on Sunday', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-05 18:30:00'),
('2024-11-10', 'HR Department', '[TEST] Employee Bonus - Diwali Festival', 15000.00, 0.00, 15000.00, 'salary_wages', 'bank_transfer', 'NEFT-BONUS-001', 'BONUS-DIW-2024', 'BONUS-2024', 'Festival bonus payment', 'Festival bonus distributed among all staff', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-10 14:00:00'),

-- RENT & UTILITIES EXPENSES (Monthly recurring)
('2024-11-01', 'ABC Properties Ltd', '[TEST] Monthly Office Rent', 18000.00, 3240.00, 21240.00, 'rent_utilities', 'bank_transfer', 'NEFT-RENT-001', 'RENT-2024-11-001', 'RENT-INV-001', 'Office space rental', 'Main workshop and office space rental', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-01 10:00:00'),
('2024-11-01', 'Storage Solutions Pvt Ltd', '[TEST] Warehouse Rent', 12000.00, 2160.00, 14160.00, 'rent_utilities', 'cheque', 'CHQ-456789', 'WH-RENT-Nov24', 'WH-INV-001', 'Warehouse rental', 'Parts and battery storage warehouse', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-01 11:30:00'),
('2024-11-15', 'Equipment Lease Co', '[TEST] Testing Equipment Lease', 8500.00, 1530.00, 10030.00, 'rent_utilities', 'bank_transfer', 'NEFT-LEASE-001', 'EQ-LEASE-456', 'EQ-INV-001', 'Equipment lease', 'Battery testing and diagnostic equipment monthly lease', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-15 16:00:00'),

-- UTILITIES EXPENSES (Monthly recurring) - Merged with rent_utilities
('2024-11-02', 'MSEB', '[TEST] Electricity Bill - Workshop', 4200.00, 756.00, 4956.00, 'rent_utilities', 'upi', 'UPI-MSEB-001', 'EB-2024-11-001', 'MSEB-001', 'Electricity bill payment', 'High consumption due to battery charging stations', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-02 12:00:00'),
('2024-11-03', 'Jio Fiber', '[TEST] Internet and Phone Bills', 1800.00, 324.00, 2124.00, 'rent_utilities', 'upi', 'UPI-JIO-001', 'JIO-Nov-2024', 'JIO-001', 'Internet and phone service', 'Business internet 100Mbps + phone service', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-03 09:30:00'),
('2024-11-04', 'Municipal Water', '[TEST] Water Bill', 800.00, 144.00, 944.00, 'rent_utilities', 'bank_transfer', 'NEFT-WATER-001', 'WATER-Nov24', 'WATER-001', 'Water bill payment', 'Workshop water supply and cleaning', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-04 11:00:00'),
('2024-11-08', 'Airtel', '[TEST] Mobile Phone Bills - Staff', 2200.00, 396.00, 2596.00, 'rent_utilities', 'upi', 'UPI-AIRTEL-001', 'MOBILE-Nov-2024', 'AIRTEL-001', 'Mobile phone service', 'Mobile connections for field technicians', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-08 15:45:00'),

-- INVENTORY PURCHASE EXPENSES (Parts and supplies)
('2024-11-03', 'Battery World Distributors', '[TEST] Lithium Battery Purchase - 20Ah', 45000.00, 8100.00, 53100.00, 'inventory_purchase', 'bank_transfer', 'NEFT-BWD-001', 'INV-BW-2024-445', 'BWD-INV-001', 'Battery inventory purchase', '10 units of 48V 20Ah lithium batteries for customer jobs', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-03 14:20:00'),
('2024-11-06', 'EV Parts Supplier', '[TEST] Charger and Controller Purchase', 15600.00, 2808.00, 18408.00, 'inventory_purchase', 'bank_transfer', 'NEFT-EV-001', 'EV-PARTS-7891', 'EV-INV-001', 'EV parts purchase', '5 chargers (48V 5A) and 3 BLDC controllers', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-06 10:15:00'),
('2024-11-09', 'Local Hardware Store', '[TEST] Tools and Workshop Supplies', 3200.00, 576.00, 3776.00, 'inventory_purchase', 'cash', 'CASH-HW-001', 'HW-TOOLS-156', 'HW-INV-001', 'Tools and supplies', 'Screwdrivers, wrenches, multimeter, and safety equipment', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-09 16:30:00'),
('2024-11-12', 'Wire & Cable Co', '[TEST] Wiring and Electrical Components', 2800.00, 504.00, 3304.00, 'inventory_purchase', 'cash', 'CASH-WC-001', 'WC-2024-789', 'WC-INV-001', 'Electrical components', 'Copper wires, connectors, fuses, and electrical tape', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-12 11:45:00'),

-- MAINTENANCE EXPENSES
('2024-11-05', 'Tech Repair Services', '[TEST] Workshop Equipment Repair', 2500.00, 450.00, 2950.00, 'maintenance', 'cash', 'CASH-TRS-001', 'TRS-REP-234', 'TRS-INV-001', 'Equipment repair', 'Repair of battery testing machine - replaced faulty display', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-05 14:00:00'),
('2024-11-07', 'Building Maintenance Co', '[TEST] AC Servicing and Cleaning', 1800.00, 324.00, 2124.00, 'maintenance', 'upi', 'UPI-BMC-001', 'BMC-SRV-567', 'BMC-INV-001', 'AC servicing', 'Quarterly servicing of workshop air conditioning units', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-07 13:30:00'),
('2024-11-14', 'Vehicle Service Center', '[TEST] Delivery Van Service', 3200.00, 576.00, 3776.00, 'maintenance', 'card', 'CARD-VSC-001', 'VSC-2024-890', 'VSC-INV-001', 'Vehicle maintenance', 'Oil change, tire rotation, and general servicing of company vehicle', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-14 17:00:00'),

-- FUEL & TRANSPORT EXPENSES
('2024-11-04', 'Indian Oil Petrol Pump', '[TEST] Fuel for Delivery Van', 2800.00, 0.00, 2800.00, 'fuel_transport', 'cash', 'CASH-FUEL-001', 'FUEL-Nov-04', 'IOCL-001', 'Vehicle fuel', 'Petrol for customer battery delivery and pickup services', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-04 08:15:00'),
('2024-11-11', 'City Transport Service', '[TEST] Parts Delivery Charges', 450.00, 81.00, 531.00, 'fuel_transport', 'upi', 'UPI-CTS-001', 'CTS-DEL-123', 'CTS-INV-001', 'Delivery service', 'Emergency delivery of controller from supplier to workshop', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-11 19:30:00'),
('2024-11-13', 'FastTrack Courier', '[TEST] Battery Shipping to Customer', 680.00, 122.40, 802.40, 'fuel_transport', 'card', 'CARD-FTC-001', 'FT-SHIP-456', 'FTC-INV-001', 'Courier service', 'Shipping repaired battery pack to customer in nearby city', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-13 12:20:00'),

-- MARKETING EXPENSES
('2024-11-08', 'Digital Marketing Agency', '[TEST] Social Media Advertising', 8000.00, 1440.00, 9440.00, 'marketing', 'bank_transfer', 'NEFT-DMA-001', 'DMA-ADS-789', 'DMA-INV-001', 'Digital advertising', 'Facebook and Instagram ads for EV battery services - November campaign', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-08 10:30:00'),
('2024-11-10', 'Local Printing Press', '[TEST] Business Cards and Flyers', 1200.00, 216.00, 1416.00, 'marketing', 'cash', 'CASH-LPP-001', 'LPP-PRINT-234', 'LPP-INV-001', 'Printing materials', '500 business cards and 1000 promotional flyers for battery services', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-10 15:00:00'),

-- OFFICE SUPPLIES EXPENSES
('2024-11-02', 'Office Depot', '[TEST] Stationery and Office Supplies', 1500.00, 270.00, 1770.00, 'office_supplies', 'card', 'CARD-OD-001', 'OD-STAT-456', 'OD-INV-001', 'Office supplies', 'A4 papers, pens, files, printer cartridges for monthly operations', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-02 11:15:00'),
('2024-11-09', 'Software Solutions Inc', '[TEST] Microsoft Office License Renewal', 5400.00, 972.00, 6372.00, 'office_supplies', 'bank_transfer', 'NEFT-SSI-001', 'SSI-MS-2024', 'SSI-INV-001', 'Software licensing', 'Annual Microsoft Office 365 subscription for 5 users', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-09 09:00:00'),

-- PROFESSIONAL FEES EXPENSES
('2024-11-06', 'CA Sharma & Associates', '[TEST] Accounting and GST Filing', 3500.00, 630.00, 4130.00, 'professional_fees', 'bank_transfer', 'NEFT-CA-001', 'CA-GST-Oct24', 'CA-INV-001', 'Accounting services', 'Monthly GST return filing and bookkeeping services', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-06 16:45:00'),
('2024-11-12', 'Legal Advisor LLP', '[TEST] Business License Consultation', 4200.00, 756.00, 4956.00, 'professional_fees', 'cheque', 'CHQ-LEG-001', 'LEG-CONS-789', 'LEG-INV-001', 'Legal consultation', 'Legal consultation for expanding business to new location', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-12 14:30:00'),

-- MISCELLANEOUS EXPENSES
('2024-11-07', 'Training Institute', '[TEST] Staff Training - EV Technology', 6000.00, 1080.00, 7080.00, 'miscellaneous', 'bank_transfer', 'NEFT-TI-001', 'TI-TRAIN-234', 'TI-INV-001', 'Training expenses', 'Technical training for 2 technicians on latest EV battery technology', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-07 10:00:00'),
('2024-11-15', 'Business Dinner', '[TEST] Client Meeting Expenses', 2800.00, 504.00, 3304.00, 'miscellaneous', 'cash', 'CASH-BD-001', NULL, NULL, 'Business meeting', 'Dinner meeting with potential bulk customer for fleet EV servicing', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-15 20:30:00'),

-- INSURANCE EXPENSES
('2024-11-16', 'General Insurance Co', '[TEST] Business Insurance Premium', 12000.00, 2160.00, 14160.00, 'insurance', 'bank_transfer', 'NEFT-INS-001', 'INS-PREM-2024', 'INS-001', 'Insurance premium', 'Annual business and equipment insurance premium payment', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-16 10:00:00'),

-- TAXES EXPENSES
('2024-11-17', 'Tax Department', '[TEST] Advance Tax Payment', 25000.00, 0.00, 25000.00, 'taxes', 'bank_transfer', 'NEFT-TAX-001', 'ADV-TAX-Q3', 'TAX-001', 'Tax payment', 'Quarterly advance tax payment for Q3 2024-25', 'approved', NULL, '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2a40a711-21bf-4f8e-8cee-20a925205ae1', '2024-11-17 11:30:00');

-- Update some timestamps to show activity throughout the month
UPDATE public.expenses 
SET created_at = '2024-10-28 16:30:00'
WHERE description LIKE '%Monthly Office Rent%';

UPDATE public.expenses 
SET created_at = '2024-10-25 14:15:00'  
WHERE description LIKE '%Electricity Bill%';

-- Summary comment
-- 
-- Mock Data Summary:
-- =================
-- Total Records: 27 expenses
-- 
-- By Category (Updated enum values):
-- - salary_wages: 4 records (₹78,500 total)
-- - rent_utilities: 7 records (₹56,860 + tax) - Combined rent and utilities
-- - inventory_purchase: 4 records (₹66,600 + tax)
-- - maintenance: 3 records (₹7,500 + tax)
-- - fuel_transport: 3 records (₹3,930 + tax)
-- - marketing: 2 records (₹9,200 + tax)
-- - office_supplies: 2 records (₹6,900 + tax)
-- - professional_fees: 2 records (₹7,700 + tax)
-- - miscellaneous: 2 records (₹8,800 + tax)
-- - insurance: 1 record (₹12,000 + tax)
-- - taxes: 1 record (₹25,000)
--
-- Features Tested:
-- - All expense categories
-- - Recurring vs one-time expenses
-- - All payment methods
-- - With and without tax amounts
-- - With and without receipt numbers
-- - Various vendor types
-- - Different date ranges
-- - Notes and descriptions
--
-- Total Value: ~₹3,17,689 (including taxes as total_amount)
--
-- This data will help test:
-- 1. Expense form submissions
-- 2. Category filtering
-- 3. Payment method filtering  
-- 4. Date range queries
-- 5. Vendor searches
-- 6. Recurring expense tracking
-- 7. Tax calculations
-- 8. Dashboard analytics
-- 9. Monthly/yearly reports
-- 10. Cash flow analysis
