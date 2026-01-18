// Mock types
type DailyCash = {
  id: string;
  date: string;
  opening_cash: number;
  closing_cash: number;
  cash_balance: number;
  hdfc_balance: number;
  indian_bank_balance: number;
  is_verified: boolean;
};

type Sale = {
  id: string;
  amount: number;
  payment_method: string;
  created_at: string;
};

type Expense = {
  id: string;
  amount: number;
  payment_method: string;
  created_at: string;
};

type Investment = {
  id: string;
  amount: number;
  target_account: string;
  created_at: string;
  investor_name: string;
};

type Drawing = {
  id: string;
  amount: number;
  source: string;
  type: 'deposit' | 'withdrawal';
  created_at: string;
  partner_name: string;
};

// Mock Data
const dailyCash: DailyCash = {
  id: '1',
  date: '2025-12-01',
  opening_cash: 50000, // Total
  closing_cash: 60000,
  cash_balance: 10000,
  hdfc_balance: 30000,
  indian_bank_balance: 10000,
  is_verified: false
};

const sales: Sale[] = [
  {
    id: 's1',
    amount: 5000,
    payment_method: 'indian_bank',
    created_at: '2025-12-01T10:00:00Z'
  },
  {
    id: 's2',
    amount: 2000,
    payment_method: 'cash',
    created_at: '2025-12-01T11:00:00Z'
  }
];

const expenses: Expense[] = [
  {
    id: 'e1',
    amount: 1000,
    payment_method: 'indian_bank',
    created_at: '2025-12-01T12:00:00Z'
  }
];

const investments: Investment[] = [];
const drawings: Drawing[] = [];

// KPI Calculation
const indianBankSales = sales
  .filter((s) => s.payment_method === 'indian_bank')
  .reduce((sum, s) => sum + s.amount, 0);

const indianBankExpenses = expenses
  .filter((e) => e.payment_method === 'indian_bank')
  .reduce((sum, e) => sum + e.amount, 0);

const indianBankInvestments = investments
  .filter((i) => i.target_account === 'indian_bank')
  .reduce((sum, i) => sum + i.amount, 0);

const calculateDrawingsImpact = (source: string) => {
  return drawings
    .filter((d) => d.source === source)
    .reduce((sum, d) => {
      return sum + (d.type === 'deposit' ? d.amount : -d.amount);
    }, 0);
};
const indianBankDrawingsImpact = calculateDrawingsImpact('indian_bank');

const currentIndianBankBalanceKPI =
  (dailyCash.indian_bank_balance || 0) +
  indianBankSales -
  indianBankExpenses +
  indianBankInvestments +
  indianBankDrawingsImpact;

console.log('KPI Indian Bank Balance:', currentIndianBankBalanceKPI);

// Timeline Calculation
const transactions = [
  ...sales.map((s) => ({
    ...s,
    type: 'sale' as const,
    date: new Date(s.created_at)
  })),
  ...expenses.map((e) => ({
    ...e,
    type: 'expense' as const,
    date: new Date(e.created_at)
  })),
  ...investments.map((i) => ({
    ...i,
    type: 'investment' as const,
    description: `Investment from ${i.investor_name}`,
    payment_method: i.target_account,
    date: new Date(i.created_at)
  })),
  ...drawings.map((d) => ({
    ...d,
    type: 'drawing' as const,
    description: `${d.type === 'withdrawal' ? 'Withdrawal' : 'Deposit'} - ${d.partner_name}`,
    payment_method: d.source,
    date: new Date(d.created_at),
    drawing_type: d.type
  }))
].sort((a, b) => a.date.getTime() - b.date.getTime());

const balances = {
  cash: dailyCash.cash_balance || 0,
  hdfc_bank: dailyCash.hdfc_balance || 0,
  indian_bank: dailyCash.indian_bank_balance || 0,
  other: 0
};

console.log('Timeline Initial Balances:', balances);

transactions.forEach((tx) => {
  let method = tx.payment_method || 'cash';
  if (method === 'hdfc') method = 'hdfc_bank';

  if (method === 'cash') {
    if (tx.type === 'sale' || tx.type === 'investment')
      balances.cash += tx.amount;
    else if (tx.type === 'drawing') {
      if ((tx as any).drawing_type === 'deposit') balances.cash += tx.amount;
      else balances.cash -= tx.amount;
    } else balances.cash -= tx.amount;
  } else if (method === 'hdfc_bank') {
    if (tx.type === 'sale' || tx.type === 'investment')
      balances.hdfc_bank += tx.amount;
    else if (tx.type === 'drawing') {
      if ((tx as any).drawing_type === 'deposit')
        balances.hdfc_bank += tx.amount;
      else balances.hdfc_bank -= tx.amount;
    } else balances.hdfc_bank -= tx.amount;
  } else if (method === 'indian_bank') {
    if (tx.type === 'sale' || tx.type === 'investment')
      balances.indian_bank += tx.amount;
    else if (tx.type === 'drawing') {
      if ((tx as any).drawing_type === 'deposit')
        balances.indian_bank += tx.amount;
      else balances.indian_bank -= tx.amount;
    } else balances.indian_bank -= tx.amount;
  }

  console.log(
    `Transaction: ${tx.type} ${tx.amount} Method: ${method} -> New Balance:`,
    method === 'indian_bank'
      ? balances.indian_bank
      : method === 'hdfc_bank'
        ? balances.hdfc_bank
        : balances.cash
  );
});

console.log('Timeline Final Indian Bank Balance:', balances.indian_bank);
