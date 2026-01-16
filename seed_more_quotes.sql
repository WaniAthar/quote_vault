-- Seed 50 more quotes (10 per category)
INSERT INTO public.quotes (text, author, category) VALUES
-- Motivation (10 more)
('The secret of getting ahead is getting started.', 'Mark Twain', 'Motivation'),
('It always seems impossible until it''s done.', 'Nelson Mandela', 'Motivation'),
('Our greatest weakness lies in giving up. The most certain way to succeed is always to try just one more time.', 'Thomas A. Edison', 'Motivation'),
('Keep your eyes on the stars, and your feet on the ground.', 'Theodore Roosevelt', 'Motivation'),
('If you can dream it, you can do it.', 'Walt Disney', 'Motivation'),
('Don''t stop when you''re tired. Stop when you''re done.', 'Unknown', 'Motivation'),
('Hardships often prepare ordinary people for an extraordinary destiny.', 'C.S. Lewis', 'Motivation'),
('Opportunities don''t happen, you create them.', 'Chris Grosser', 'Motivation'),
('Start where you are. Use what you have. Do what you can.', 'Arthur Ashe', 'Motivation'),
('Failure will never overtake me if my determination to succeed is strong enough.', 'Og Mandino', 'Motivation'),

-- Love (10 more)
('You know you''re in love when you can''t fall asleep because reality is finally better than your dreams.', 'Dr. Seuss', 'Love'),
('A successful marriage requires falling in love many times, always with the same person.', 'Mignon McLaughlin', 'Love'),
('Love is that condition in which the happiness of another person is essential to your own.', 'Robert A. Heinlein', 'Love'),
('The best and most beautiful things in this world cannot be seen or even heard, but must be felt with the heart.', 'Helen Keller', 'Love'),
('To be brave is to love someone unconditionally, without expecting anything in return.', 'Madonna', 'Love'),
('In all the world, there is no heart for me like yours. In all the world, there is no love for you like mine.', 'Maya Angelou', 'Love'),
('Being deeply loved by someone gives you strength, while loving someone deeply gives you courage.', 'Lao Tzu', 'Love'),
('Love is the expansion of two natures in such fashion that each include the other, each is enriched by the other.', 'Felix Adler', 'Love'),
('Love is a smoke made with the fume of sighs.', 'William Shakespeare', 'Love'),
('If I know what love is, it is because of you.', 'Hermann Hesse', 'Love'),

-- Success (10 more)
('Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful.', 'Albert Schweitzer', 'Success'),
('Successful people do what unsuccessful people are not willing to do. Don''t wish it were easier; wish you were better.', 'Jim Rohn', 'Success'),
('A dream doesn''t become reality through magic; it takes sweat, determination and hard work.', 'Colin Powell', 'Success'),
('The successful warrior is the average man, with laser-like focus.', 'Bruce Lee', 'Success'),
('Success is liking yourself, liking what you do, and liking how you do it.', 'Maya Angelou', 'Success'),
('Action is the foundational key to all success.', 'Pablo Picasso', 'Success'),
('Success consists of going from failure to failure without loss of enthusiasm.', 'Winston Churchill', 'Success'),
('The only place where success comes before work is in the dictionary.', 'Vidal Sassoon', 'Success'),
('I find that the harder I work, the more luck I seem to have.', 'Thomas Jefferson', 'Success'),
('Success is to be measured not so much by the position that one has reached in life as by the obstacles which he has overcome.', 'Booker T. Washington', 'Success'),

-- Wisdom (10 more)
('The only way to have a friend is to be one.', 'Ralph Waldo Emerson', 'Wisdom'),
('Do not go where the path may lead, go instead where there is no path and leave a trail.', 'Ralph Waldo Emerson', 'Wisdom'),
('Everything has beauty, but not everyone sees it.', 'Confucius', 'Wisdom'),
('The journey of a thousand miles begins with one step.', 'Lao Tzu', 'Wisdom'),
('We are what we repeatedly do. Excellence, then, is not an act, but a habit.', 'Aristotle', 'Wisdom'),
('To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.', 'Ralph Waldo Emerson', 'Wisdom'),
('What lies behind us and what lies before us are tiny matters compared to what lies within us.', 'Ralph Waldo Emerson', 'Wisdom'),
('When you change the way you look at things, the things you look at change.', 'Wayne Dyer', 'Wisdom'),
('He who has a why to live can bear almost any how.', 'Friedrich Nietzsche', 'Wisdom'),
('The man who moves a mountain begins by carrying away small stones.', 'Confucius', 'Wisdom'),

-- Humor (10 more)
('I''m on a seafood diet. I see food and I eat it.', 'Unknown', 'Humor'),
('My favorite exercise is a cross between a lunge and a crunch. I call it lunch.', 'Unknown', 'Humor'),
('I used to think I was indecisive, but now I''m not so sure.', 'Unknown', 'Humor'),
('Life is short. Smile while you still have teeth.', 'Unknown', 'Humor'),
('I''m not lazy, I''m just on energy saving mode.', 'Unknown', 'Humor'),
('People say nothing is impossible, but I do nothing every day.', 'Winnie the Pooh', 'Humor'),
('I told my wife she should embrace her mistakes. She gave me a hug.', 'Unknown', 'Humor'),
('My bed is a magical place where I suddenly remember everything I forgot to do.', 'Unknown', 'Humor'),
('I don''t need a hair stylist, my pillow gives me a new hairstyle every morning.', 'Unknown', 'Humor'),
('I’m not arguing, I’m just explaining why I’m right.', 'Unknown', 'Humor')
ON CONFLICT DO NOTHING;