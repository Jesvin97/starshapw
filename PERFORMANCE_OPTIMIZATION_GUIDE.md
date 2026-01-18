# Performance Optimization Guide

This guide outlines the performance optimizations implemented to improve route loading times in the EV Wheels web application.

## 🚀 Key Optimizations Implemented

### 1. Authentication Performance
- **Problem**: Multiple Supabase session checks on every route causing delays
- **Solution**: Centralized auth context with optimized session management
- **Files**: 
  - `src/lib/auth/auth-context.tsx` - New optimized auth provider
  - `src/components/auth/optimized-require-auth.tsx` - Better loading states

### 2. Data Loading Optimization
- **Problem**: Client-side data fetching without proper caching
- **Solution**: React Query hooks with intelligent caching strategies
- **Files**:
  - `src/hooks/use-customers.ts` - Optimized data fetching hooks
  - `src/lib/react-query/query-client.ts` - Enhanced caching configuration

### 3. Code Splitting & Bundling
- **Problem**: Large JavaScript bundles causing slow initial loads
- **Solution**: Dynamic imports and lazy loading for heavy components
- **Files**:
  - `src/lib/utils/dynamic-imports.ts` - Code splitting utilities
  - `next.config.ts` - Bundle optimization settings

### 4. Performance Monitoring
- **Problem**: No visibility into route loading performance
- **Solution**: Real-time performance monitoring and analytics
- **Files**:
  - `src/components/performance/route-performance-monitor.tsx` - Performance tracking

## 📋 Migration Steps

### Step 1: Update Authentication (Required)
Replace existing auth usage with the new optimized context:

```typescript
// Before (old way)
import { useAuth } from '@/hooks/use-auth';
import RequireAuth from '@/components/auth/require-auth';

// After (new way)
import { useAuth } from '@/lib/auth/auth-context';
import OptimizedRequireAuth from '@/components/auth/optimized-require-auth';
```

### Step 2: Replace Data Fetching (Recommended)
Update pages using direct API calls to use React Query hooks:

```typescript
// Before (customers page example)
const [rows, setRows] = useState<Customer[]>([]);
const [loading, setLoading] = useState(true);

useEffect(() => {
  const load = async () => {
    setLoading(true);
    const res = await customersApi.list(params);
    if (res.success && res.data) setRows(res.data);
    setLoading(false);
  };
  load();
}, [params]);

// After
import { useCustomers } from '@/hooks/use-customers';
const { data: customers, isLoading, error } = useCustomers(params);
```

### Step 3: Implement Code Splitting (Optional)
For heavy components, use dynamic imports:

```typescript
// Before
import ExpensiveComponent from '@/components/expensive-component';

// After
import { createDynamicComponent } from '@/lib/utils/dynamic-imports';
const ExpensiveComponent = createDynamicComponent(
  () => import('@/components/expensive-component')
);
```

### Step 4: Update Dashboard Layout (Required)
Update the dashboard layout to use the new auth component:

```typescript
// In src/app/dashboard/layout.tsx
// Replace RequireAuth with OptimizedRequireAuth
import OptimizedRequireAuth from '@/components/auth/optimized-require-auth';

// Update the component usage
<OptimizedRequireAuth redirectTo='/auth/sign-in'>
  <AppSidebar />
  <SidebarInset>
    <Header />
    {children}
  </SidebarInset>
</OptimizedRequireAuth>
```

## 🔧 Configuration Updates

### Next.js Configuration
The `next.config.ts` has been updated with:
- Image optimization settings
- Bundle splitting optimizations
- Package import optimizations
- Production performance settings

### React Query Configuration  
Enhanced caching with:
- Extended stale times (10 minutes for queries)
- Longer garbage collection times (30 minutes)
- Smart retry logic (no retry for 4xx errors)
- Network-aware refetching

## 📊 Performance Monitoring

### Development Mode
In development, you'll see a performance stats overlay showing:
- Average route load times
- Total routes visited
- Slowest route identified
- Console warnings for routes > 2 seconds

### Accessing Performance Data
```typescript
import { getRoutePerformanceAnalytics } from '@/components/performance/route-performance-monitor';

// Get detailed analytics
const stats = getRoutePerformanceAnalytics();
console.log('Average load time:', stats?.averageLoadTime);
console.log('Slowest routes:', stats?.slowestRoutes);
```

## 🎯 Expected Improvements

After implementing these optimizations, you should see:

1. **Authentication**: ~50-80% faster auth checks (no repeated Supabase calls)
2. **Data Loading**: ~30-60% faster route switches with cached data
3. **Bundle Size**: ~20-40% smaller initial JavaScript bundles
4. **User Experience**: Much smoother navigation between routes

## 🔍 Monitoring & Debugging

### Check Performance in Development
1. Open developer console
2. Navigate between routes
3. Watch for performance warnings
4. Check the performance overlay (bottom-right)

### Production Monitoring
Consider adding external monitoring tools like:
- Vercel Analytics
- Sentry Performance Monitoring
- Core Web Vitals tracking

## ⚡ Quick Wins for Further Optimization

1. **Enable Turbopack**: Use `npm run dev:turbo` for even faster development
2. **Preload Routes**: Add hover preloading to navigation links
3. **Image Optimization**: Use Next.js Image component for all images  
4. **Service Workers**: Add offline caching for better UX

## 🐛 Troubleshooting

### Common Issues
- **Build Errors**: Ensure all new imports are correctly referenced
- **Type Errors**: Run `npm run type-check` to verify TypeScript
- **Auth Issues**: Clear localStorage and cookies if auth seems stuck
- **Performance Stats**: Disable in production by checking NODE_ENV

### Support
If you encounter issues:
1. Check the browser console for errors
2. Verify all files are correctly imported
3. Test in incognito mode to rule out cache issues
4. Check the performance monitoring data for insights
