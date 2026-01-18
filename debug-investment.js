const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testCreateInvestment() {
  console.log('Testing investment creation...');

  const insertData = {
    date: new Date().toISOString().split('T')[0],
    amount: 1000,
    target_account: 'cash',
    investor_name: 'Test Investor',
    notes: 'Test Note',
    created_by: '00000000-0000-0000-0000-000000000000', // Dummy UUID
    updated_by: '00000000-0000-0000-0000-000000000000'
  };

  console.log('Inserting:', insertData);

  const { data, error } = await supabase
    .from('investments')
    .insert(insertData)
    .select('*')
    .single();

  if (error) {
    console.error('Insert Error Raw:', error);
    console.error('Insert Error JSON:', JSON.stringify(error, null, 2));
    console.error('Insert Error Message:', error.message);
    console.error('Insert Error Details:', error.details);
    console.error('Insert Error Hint:', error.hint);
  } else {
    console.log('Insert Success:', data);
  }
}

testCreateInvestment();
