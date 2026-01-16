-- Verification script to check if database setup is complete
-- Run this in Supabase SQL Editor after running setup_database.sql

-- Check if tables exist
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename IN ('quotes', 'user_favorites', 'collections', 'collection_quotes')
ORDER BY tablename;

-- Check table row counts
SELECT
    'quotes' as table_name,
    COUNT(*) as row_count
FROM public.quotes
UNION ALL
SELECT
    'user_favorites' as table_name,
    COUNT(*) as row_count
FROM public.user_favorites
UNION ALL
SELECT
    'collections' as table_name,
    COUNT(*) as row_count
FROM public.collections
UNION ALL
SELECT
    'collection_quotes' as table_name,
    COUNT(*) as row_count
FROM public.collection_quotes;

-- Check RLS policies
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- Sample query to test data access
SELECT
    category,
    COUNT(*) as quote_count
FROM public.quotes
GROUP BY category
ORDER BY category;