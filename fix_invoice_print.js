// =============================================================================
// FIX INVOICE PRINT FUNCTIONALITY
// =============================================================================
// This file contains the updated functions to fix the print issue

// Updated downloadInvoiceAsPDF function that automatically triggers print dialog
export async function downloadInvoiceAsPDF(invoice, htmlContent) {
  try {
    // Create a new window for printing
    const printWindow = window.open('', '_blank');
    if (!printWindow) {
      throw new Error(
        'Unable to open print window. Please check your popup blocker.'
      );
    }

    // Write the HTML content to the new window
    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Invoice ${invoice.number}</title>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
            * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
            }
            
            body {
              font-family: 'Inter', system-ui, -apple-system, sans-serif;
              line-height: 1.5;
              color: #374151;
              background: white;
            }
            
            @media print {
              body {
                print-color-adjust: exact;
                -webkit-print-color-adjust: exact;
              }
              
              .no-print {
                display: none !important;
              }
              
              .page-break {
                page-break-after: always;
              }
              
              @page {
                margin: 0.5in;
                size: A4;
              }
            }
            
            /* Include all the existing Tailwind CSS classes here */
            .max-w-4xl { max-width: 56rem; }
            .mx-auto { margin-left: auto; margin-right: auto; }
            .bg-white { background-color: white; }
            .text-gray-900 { color: #111827; }
            .text-gray-800 { color: #1f2937; }
            .text-gray-700 { color: #374151; }
            .text-gray-600 { color: #4b5563; }
            .text-gray-500 { color: #6b7280; }
            .text-green-600 { color: #059669; }
            .text-blue-600 { color: #2563eb; }
            .text-red-600 { color: #dc2626; }
            .text-green-100 { color: #dcfce7; }
            
            /* Add all other CSS styles from the original file... */
            .p-8 { padding: 2rem; }
            .p-6 { padding: 1.5rem; }
            .p-4 { padding: 1rem; }
            .mb-8 { margin-bottom: 2rem; }
            .mb-6 { margin-bottom: 1.5rem; }
            .mb-4 { margin-bottom: 1rem; }
            .flex { display: flex; }
            .grid { display: grid; }
            .items-center { align-items: center; }
            .justify-between { justify-content: space-between; }
            .text-4xl { font-size: 2.25rem; line-height: 2.5rem; }
            .text-3xl { font-size: 1.875rem; line-height: 2.25rem; }
            .text-2xl { font-size: 1.5rem; line-height: 2rem; }
            .text-xl { font-size: 1.25rem; line-height: 1.75rem; }
            .text-lg { font-size: 1.125rem; line-height: 1.75rem; }
            .text-sm { font-size: 0.875rem; line-height: 1.25rem; }
            .font-bold { font-weight: 700; }
            .font-semibold { font-weight: 600; }
            .font-medium { font-weight: 500; }
            .rounded-lg { border-radius: 0.5rem; }
            .border { border-width: 1px; border-color: #d1d5db; }
            .bg-gray-50 { background-color: #f9fafb; }
            .bg-green-600 { background-color: #059669; }
            .w-full { width: 100%; }
            .text-center { text-align: center; }
            .text-right { text-align: right; }
            table { border-collapse: collapse; }
            th, td { text-align: left; vertical-align: top; }
            
            /* Better PDF image handling */
            img {
              max-width: 100%;
              height: auto;
              display: block;
            }
          </style>
        </head>
        <body>
          ${htmlContent}
          <div class="no-print" style="position: fixed; top: 20px; right: 20px; z-index: 1000;">
            <button onclick="window.close()" style="background: #6b7280; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">Close</button>
          </div>
          
          <script>
            // Auto-trigger print dialog when page loads
            window.onload = function() {
              setTimeout(function() {
                window.print();
              }, 1000); // Small delay to ensure content is fully loaded
            };
            
            // Close window after printing or canceling
            window.onafterprint = function() {
              window.close();
            };
          </script>
        </body>
      </html>
    `);

    printWindow.document.close();

    // Focus the window
    setTimeout(() => {
      printWindow.focus();
    }, 500);

    return true;
  } catch (error) {
    console.error('Error generating PDF:', error);
    throw error;
  }
}

// Alternative function for direct print without opening new window
export function printInvoiceDirect(invoice, htmlContent) {
  try {
    // Create a hidden iframe for printing
    const printFrame = document.createElement('iframe');
    printFrame.style.position = 'absolute';
    printFrame.style.left = '-9999px';
    printFrame.style.top = '-9999px';
    printFrame.style.width = '1px';
    printFrame.style.height = '1px';

    document.body.appendChild(printFrame);

    const printDocument =
      printFrame.contentDocument || printFrame.contentWindow.document;

    printDocument.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Invoice ${invoice.number}</title>
          <meta charset="utf-8">
          <style>
            /* Add all the same styles as above */
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body { font-family: 'Inter', system-ui, sans-serif; line-height: 1.5; color: #374151; background: white; }
            @media print {
              body { print-color-adjust: exact; -webkit-print-color-adjust: exact; }
              @page { margin: 0.5in; size: A4; }
            }
            /* Add all other necessary CSS classes */
          </style>
        </head>
        <body>
          ${htmlContent}
        </body>
      </html>
    `);

    printDocument.close();

    // Wait for content to load then print
    setTimeout(() => {
      printFrame.contentWindow.focus();
      printFrame.contentWindow.print();

      // Clean up after printing
      setTimeout(() => {
        document.body.removeChild(printFrame);
      }, 1000);
    }, 1000);

    return true;
  } catch (error) {
    console.error('Error printing invoice:', error);
    throw error;
  }
}
