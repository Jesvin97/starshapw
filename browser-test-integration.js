// Test script to help debug the invoice-sales integration
// Run this in the browser console on your app

console.log(
  '🧪 Invoice-Sales Integration Test Script - Updated with Debug Logs'
);
console.log('Follow these steps to test the integration:');
console.log('');
console.log('1. Open the browser developer tools (F12)');
console.log('2. Go to the Invoices page (/dashboard/invoices)');
console.log('3. Find an invoice that is NOT paid');
console.log('4. Click the green "Mark as Paid" button (💳 icon)');
console.log('5. Watch the console for debug messages');
console.log('6. Go to the Sales page (/dashboard/finances/sales)');
console.log('7. Check if a new sale record was created');
console.log('');
console.log('Expected console output when marking as paid:');
console.log('- 🔍 [Supabase] Checking for sales integration needs...');
console.log('- 💳 [Supabase] Invoice XXX marked as PAID...');
console.log('- 💰 [Supabase] Found 0 existing payments...');
console.log('- 🎯 [Supabase] No payments found, creating sale record...');
console.log('- 🔄 Creating sale from invoice XXX...');
console.log('- 📝 Sale input data: {...}');
console.log('- 📊 Sales API create result: {...}');
console.log('- ✅ Successfully created sale record...');
console.log('');
console.log('If you see these messages but no sales appear:');
console.log('- Check that the sales page is refreshing correctly');
console.log('- Try manually refreshing the sales page');
console.log('- Check if there are any filters applied on the sales page');
console.log(
  '- The sales data might be stored in memory and need a page refresh'
);
console.log('');
console.log("If you don't see any messages:");
console.log('- The integration might not be triggered');
console.log('- Check if the repository is correctly configured');
console.log('- Verify the invoice status is actually changing');
console.log('- Check network tab for API calls');
console.log('');
console.log('Quick Debug Commands:');
console.log('// Check current sales data (run on sales page):');
console.log('// financesApi.sales.list().then(console.log)');
console.log('');
console.log(
  '// Check invoice status after marking paid (run on invoices page):'
);
console.log('// billingRepository.getInvoice("invoice-id").then(console.log)');
console.log('');
console.log('// Force refresh sales data (run on sales page):');
console.log('// window.location.reload()');
