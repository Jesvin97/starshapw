// Simple test to check repository and integration
const path = require('path');

// Mock Next.js environment
global.process = process;
process.env.NODE_ENV = 'development';

async function testRepositoryType() {
  console.log('🔍 Testing which repository is being used...\n');

  try {
    // Import the repository
    const { billingRepository } = require('./src/lib/billing/repository.ts');

    console.log('Repository instance:', billingRepository.constructor.name);

    if (typeof billingRepository.getStats === 'function') {
      const stats = billingRepository.getStats();
      console.log('Repository stats:', stats);
    }

    // Test creating an invoice
    console.log('\n📋 Testing invoice creation...');

    const invoiceInput = {
      customer: {
        name: 'Test Customer',
        email: 'test@example.com'
      },
      items: [
        {
          description: 'Test service',
          quantity: 1,
          unitPrice: 100,
          taxRate: 18
        }
      ],
      dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
    };

    console.log('Creating test invoice...');
    const invoice = await billingRepository.createInvoice(
      invoiceInput,
      'test-user'
    );
    console.log('✅ Invoice created:', invoice.id, invoice.number);

    // Test marking as paid
    console.log('\n💰 Testing marking invoice as paid...');
    await billingRepository.updateInvoice(invoice.id, {
      status: 'paid'
    });
    console.log('✅ Invoice marked as paid');

    // Check sales
    console.log('\n📊 Checking sales records...');
    const { financesApi } = require('./src/lib/api/finances.ts');
    const salesResult = await financesApi.sales.list({ limit: 10 });

    if (salesResult.success) {
      const relatedSales = salesResult.data.filter(
        (sale) => sale.invoice_id === invoice.id
      );
      console.log(`Total sales: ${salesResult.data.length}`);
      console.log(`Sales for this invoice: ${relatedSales.length}`);

      if (relatedSales.length > 0) {
        console.log(
          '✅ Integration working! Sale created:',
          relatedSales[0].id
        );
        console.log('   Sale details:', {
          amount: relatedSales[0].amount,
          description: relatedSales[0].description,
          status: relatedSales[0].status
        });
      } else {
        console.log('❌ Integration not working - no sale record created');
      }
    } else {
      console.log('❌ Failed to fetch sales:', salesResult.error);
    }
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error('Stack trace:', error.stack);
  }
}

// Run the test
testRepositoryType();
