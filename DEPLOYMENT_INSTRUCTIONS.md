# Deployment Instructions - Job Card Details Enhancement

## Overview
Enhanced the job card creation and display system to properly show all entered battery and vehicle details in the job card details page using the new intake vs service architecture.

## Changes Made

### 1. Job Card Creation Form (`tickets/new/page.tsx`)
- **Added vehicle record creation**: Now creates proper `vehicle_records` when vehicle details are entered
- **Enhanced data flow**: Vehicle details (make, model, reg, year, type) are now stored as proper intake records
- **Improved linking**: Both vehicles and batteries are properly linked to the ticket

### 2. Job Card Details Display (`JobCardDetailClient.tsx`)
- **Added IntakeVsServiceDisplay component**: Shows clear distinction between intake records and service cases
- **Enhanced API data fetching**: Now fetches vehicle records, vehicle cases, battery records, and battery cases
- **Improved UI**: Customer bringing badge and comprehensive service overview

### 3. Battery & Vehicle Detail Display (`intake-vs-service-display.tsx`)
- **Enhanced battery display**: Shows serial, brand, model, type, voltage, capacity, cell type, condition notes
- **Enhanced vehicle display**: Shows make, model, reg, year, type, status, condition notes
- **Better organization**: Clear visual separation between intake records and service cases

### 4. Database Migration
- **Created migration**: `20241117_remove_old_battery_case_id.sql` for final cleanup
- **Field consolidation**: Removes old `battery_case_id` and renames `battery_case_id_new` to `battery_case_id`

## Deployment Steps

### 1. Deploy Code Changes
```bash
cd "E:\All Softwares\Ev"
npm run build
# Deploy to production
```

### 2. Run Database Migration (AFTER code deployment)
```sql
-- First, verify all tickets have been migrated
SELECT COUNT(*) FROM service_tickets 
WHERE battery_case_id IS NOT NULL AND battery_case_id_new IS NULL;
-- Should return 0

-- Then run the migration
\i src/lib/database/migrations/20241117_remove_old_battery_case_id.sql
```

### 3. Verify Functionality
- [ ] Create a new job card with vehicle details
- [ ] Create a new job card with battery details  
- [ ] Create a new job card with both vehicle and battery
- [ ] Verify all details show in job card details page
- [ ] Test the IntakeVsServiceDisplay component shows correct information
- [ ] Verify triage process creates proper service cases

## What Users Will See

### Job Card Creation
- Vehicle details (make, model, reg, year) are properly captured
- Battery details (serial, brand, model, type, voltage, capacity, cell type, condition) are properly captured
- Clear indication of what customer is bringing

### Job Card Details Page  
- **Service Overview section** showing:
  - What customer brought (intake records)
  - Current service status (service cases)
  - Clear workflow progression indicators

### Enhanced Information Display
- **Vehicle Intake Records**: Make, model, registration, year, type, condition notes
- **Battery Intake Records**: Serial number, brand, model, type, voltage/capacity specs, cell type, condition notes
- **Service Cases**: Proper tracking of vehicle and battery service progress

## Benefits
1. **Complete data capture**: No more missing details from job card creation
2. **Clear architecture**: Proper separation between intake and service layers
3. **Better tracking**: Full visibility into what was brought vs what's being serviced
4. **Consistent workflow**: Same pattern for both vehicles and batteries
5. **Enhanced UX**: Rich detail display with all entered information preserved

## Notes
- Old tickets will continue to work during transition period
- New tickets will use the enhanced architecture immediately  
- Database migration should only be run after confirming code deployment works correctly
- The migration is irreversible, so test thoroughly first
