-- QuoteVault Database Setup Script
-- Run this entire script in your Supabase SQL Editor

-- Enable RLS (Row Level Security) globally
ALTER TABLE IF EXISTS auth.users ENABLE ROW LEVEL SECURITY;

-- Create quotes table
CREATE TABLE IF NOT EXISTS public.quotes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    text TEXT NOT NULL,
    author TEXT,
    category TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_favorites table
CREATE TABLE IF NOT EXISTS public.user_favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    quote_id UUID REFERENCES public.quotes(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, quote_id)
);

-- Create collections table
CREATE TABLE IF NOT EXISTS public.collections (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create collection_quotes table (junction table)
CREATE TABLE IF NOT EXISTS public.collection_quotes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    collection_id UUID REFERENCES public.collections(id) ON DELETE CASCADE,
    quote_id UUID REFERENCES public.quotes(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(collection_id, quote_id)
);

-- Enable RLS on all tables
ALTER TABLE public.quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collection_quotes ENABLE ROW LEVEL SECURITY;

-- RLS Policies for quotes table (public read access)
CREATE POLICY "quotes_select_policy" ON public.quotes
    FOR SELECT USING (true);

CREATE POLICY "quotes_insert_policy" ON public.quotes
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- RLS Policies for user_favorites table
CREATE POLICY "user_favorites_select_policy" ON public.user_favorites
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_favorites_insert_policy" ON public.user_favorites
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_favorites_delete_policy" ON public.user_favorites
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for collections table
CREATE POLICY "collections_select_policy" ON public.collections
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "collections_insert_policy" ON public.collections
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "collections_update_policy" ON public.collections
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "collections_delete_policy" ON public.collections
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for collection_quotes table
CREATE POLICY "collection_quotes_select_policy" ON public.collection_quotes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.collections
            WHERE id = collection_quotes.collection_id
            AND user_id = auth.uid()
        )
    );

CREATE POLICY "collection_quotes_insert_policy" ON public.collection_quotes
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.collections
            WHERE id = collection_quotes.collection_id
            AND user_id = auth.uid()
        )
    );

CREATE POLICY "collection_quotes_delete_policy" ON public.collection_quotes
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.collections
            WHERE id = collection_quotes.collection_id
            AND user_id = auth.uid()
        )
    );

-- Insert sample quotes data (Motivation category)
INSERT INTO public.quotes (text, author, category) VALUES
('The only way to do great work is to love what you do.', 'Steve Jobs', 'Motivation'),
('Believe you can and you''re halfway there.', 'Theodore Roosevelt', 'Motivation'),
('The future belongs to those who believe in the beauty of their dreams.', 'Eleanor Roosevelt', 'Motivation'),
('You miss 100% of the shots you don''t take.', 'Wayne Gretzky', 'Motivation'),
('The best way to predict the future is to create it.', 'Peter Drucker', 'Motivation'),
('The only limit to our realization of tomorrow will be our doubts of today.', 'Franklin D. Roosevelt', 'Motivation'),
('Don''t watch the clock; do what it does. Keep going.', 'Sam Levenson', 'Motivation'),
('The way to get started is to quit talking and begin doing.', 'Walt Disney', 'Motivation'),
('Success usually comes to those who are too busy to be looking for it.', 'Henry David Thoreau', 'Motivation'),
('Your time is limited, so don''t waste it living someone else''s life.', 'Steve Jobs', 'Motivation'),

-- Love category
('Love is not about how many days, months, or years you have been together. Love is about how much you love each other every single day.', 'Unknown', 'Love'),
('The best thing to hold onto in life is each other.', 'Audrey Hepburn', 'Love'),
('Love is composed of a single soul inhabiting two bodies.', 'Aristotle', 'Love'),
('I love you not only for what you are, but for what I am when I am with you.', 'Roy Croft', 'Love'),
('Love recognizes no barriers. It jumps hurdles, leaps fences, penetrates walls to arrive at its destination full of hope.', 'Maya Angelou', 'Love'),
('To love and be loved is to feel the sun from both sides.', 'David Viscott', 'Love'),
('Love is when you meet someone who tells you something new about yourself.', 'Andre Breton', 'Love'),
('The greatest happiness of life is the conviction that we are loved.', 'Victor Hugo', 'Love'),
('Love doesn''t make the world go round. Love is what makes the ride worthwhile.', 'Franklin P. Jones', 'Love'),
('Where there is love there is life.', 'Mahatma Gandhi', 'Love'),

-- Success category
('Success is not final, failure is not fatal: It is the courage to continue that counts.', 'Winston Churchill', 'Success'),
('The way to get started is to quit talking and begin doing.', 'Walt Disney', 'Success'),
('Success usually comes to those who are too busy to be looking for it.', 'Henry David Thoreau', 'Success'),
('Don''t watch the clock; do what it does. Keep going.', 'Sam Levenson', 'Success'),
('The only limit to our realization of tomorrow will be our doubts of today.', 'Franklin D. Roosevelt', 'Success'),
('Success is walking from failure to failure with no loss of enthusiasm.', 'Winston Churchill', 'Success'),
('The secret of success is to do the common thing uncommonly well.', 'John D. Rockefeller', 'Success'),
('Success is not in what you have, but who you are.', 'Bo Bennett', 'Success'),
('The road to success is always under construction.', 'Lily Tomlin', 'Success'),
('Success is the sum of small efforts, repeated day in and day out.', 'Robert Collier', 'Success'),

-- Wisdom category
('The only true wisdom is in knowing you know nothing.', 'Socrates', 'Wisdom'),
('Knowledge speaks, but wisdom listens.', 'Jimi Hendrix', 'Wisdom'),
('The wise man does not lay up his own treasures. The more he gives to others, the more he has for his own.', 'Lao Tzu', 'Wisdom'),
('It is better to remain silent at the point of extremes than to say something that is only half true.', 'Pythagoras', 'Wisdom'),
('Wisdom is not a product of schooling but of the lifelong attempt to acquire it.', 'Albert Einstein', 'Wisdom'),
('The fool wonders, the wise man asks.', 'Benjamin Disraeli', 'Wisdom'),
('Wisdom is the right use of knowledge. To know is not to be wise.', 'Charles Spurgeon', 'Wisdom'),
('The wise learn many things from their enemies.', 'Aristophanes', 'Wisdom'),
('Wisdom begins in wonder.', 'Socrates', 'Wisdom'),
('The older I grow, the more I listen to people who don''t talk much.', 'Germain G. Glien', 'Wisdom'),

-- Humor category
('I told my wife she was drawing her eyebrows too high. She looked surprised.', 'Unknown', 'Humor'),
('Why don''t scientists trust atoms? Because they make up everything!', 'Unknown', 'Humor'),
('I''m reading a book on anti-gravity. It''s impossible to put down!', 'Unknown', 'Humor'),
('Parallel lines have so much in common. It''s a shame they''ll never meet.', 'Unknown', 'Humor'),
('I used to play piano by ear, but now I use my hands.', 'Unknown', 'Humor'),
('Why did the scarecrow win an award? Because he was outstanding in his field!', 'Unknown', 'Humor'),
('I told my computer I needed a break, and it replied ''I can''t process that request.''', 'Unknown', 'Humor'),
('Why don''t skeletons fight each other? They don''t have the guts.', 'Unknown', 'Humor'),
('I asked my dog what''s two minus two. He said nothing.', 'Unknown', 'Humor'),
('Why did the math book sad? Because it had too many problems.', 'Unknown', 'Humor')

ON CONFLICT DO NOTHING;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_quotes_category ON public.quotes(category);
CREATE INDEX IF NOT EXISTS idx_quotes_created_at ON public.quotes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON public.user_favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_quote_id ON public.user_favorites(quote_id);
CREATE INDEX IF NOT EXISTS idx_collections_user_id ON public.collections(user_id);
CREATE INDEX IF NOT EXISTS idx_collection_quotes_collection_id ON public.collection_quotes(collection_id);
CREATE INDEX IF NOT EXISTS idx_collection_quotes_quote_id ON public.collection_quotes(quote_id);

-- Grant necessary permissions (usually handled automatically by Supabase)
-- GRANT USAGE ON SCHEMA public TO anon, authenticated;
-- GRANT ALL ON public.quotes TO anon, authenticated;
-- GRANT ALL ON public.user_favorites TO authenticated;
-- GRANT ALL ON public.collections TO authenticated;
-- GRANT ALL ON public.collection_quotes TO authenticated;