// Debug script to test invoice-sales integration
const { runIntegrationDemo } = require('./src/lib/integration/demo');

async function runDebugTest() {
  console.log('🔍 Starting Integration Debug Test...\n');

  try {
    await runIntegrationDemo();
  } catch (error) {
    console.error('❌ Debug test failed:', error);
  }
}

// Run the test
runDebugTest();
