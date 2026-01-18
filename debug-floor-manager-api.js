// Debug Floor Manager API Connection
// Run this script to test if your API is working

const API_BASE_URL = 'https://ev-wheels.vercel.app';

async function debugFloorManagerAPI() {
  console.log('🔍 Debugging Floor Manager API...\n');

  // Test 1: Check if the API endpoint exists
  console.log('1. Testing API endpoint accessibility...');
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/floor-manager/technicians`,
      {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );

    console.log(`   Status: ${response.status}`);
    console.log(`   Status Text: ${response.statusText}`);

    if (response.status === 401) {
      console.log(
        '   ✅ API endpoint exists (401 Unauthorized expected without auth)'
      );
    } else {
      const text = await response.text();
      console.log(`   Response: ${text}`);
    }
  } catch (error) {
    console.log(`   ❌ Network Error: ${error.message}`);
    console.log('   This suggests the API is not reachable');
  }

  console.log('\n2. Testing with mock Authorization header...');
  try {
    const response = await fetch(
      `${API_BASE_URL}/api/floor-manager/technicians`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer fake-token-for-testing'
        },
        body: JSON.stringify({
          email: 'test@example.com',
          password: 'testpassword',
          username: 'testuser'
        })
      }
    );

    console.log(`   Status: ${response.status}`);
    const result = await response.json();
    console.log(`   Response:`, result);

    if (response.status === 401) {
      console.log('   ✅ API is working (401 expected with fake token)');
    }
  } catch (error) {
    console.log(`   ❌ Error: ${error.message}`);
  }

  console.log('\n3. Testing simple test API route...');
  try {
    const response = await fetch(`${API_BASE_URL}/api/test`);
    console.log(`   Test API status: ${response.status}`);
    if (response.ok) {
      const result = await response.json();
      console.log(`   Test API response:`, result);
    } else {
      const text = await response.text();
      console.log(`   Test API error:`, text.substring(0, 100) + '...');
    }
  } catch (error) {
    console.log(`   Test API failed: ${error.message}`);
  }

  console.log('\n📋 Possible Issues:');
  console.log('   1. Vercel deployment not working');
  console.log('   2. Environment variables missing on Vercel');
  console.log('   3. CORS issues between mobile app and API');
  console.log('   4. Authentication token issues');
  console.log('   5. Mobile app network timeout');

  console.log('\n🔧 Next Steps:');
  console.log('   1. Check Vercel deployment logs');
  console.log('   2. Verify Supabase env vars are set on Vercel');
  console.log(
    '   3. Test API in browser: https://ev-wheels.vercel.app/api/floor-manager/technicians'
  );
  console.log('   4. Check mobile app logs for detailed error');
}

// Run the debug
debugFloorManagerAPI();
