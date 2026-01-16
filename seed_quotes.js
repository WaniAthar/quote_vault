// Seed quotes data for Supabase
// Run this in Supabase SQL Editor or use it to generate more quotes

const quotes = [
  // Motivation (20 quotes)
  { text: "The only way to do great work is to love what you do.", author: "Steve Jobs", category: "Motivation" },
  { text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt", category: "Motivation" },
  { text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", category: "Motivation" },
  { text: "You miss 100% of the shots you don't take.", author: "Wayne Gretzky", category: "Motivation" },
  { text: "The best way to predict the future is to create it.", author: "Peter Drucker", category: "Motivation" },
  { text: "The only limit to our realization of tomorrow will be our doubts of today.", author: "Franklin D. Roosevelt", category: "Motivation" },
  { text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson", category: "Motivation" },
  { text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney", category: "Motivation" },
  { text: "Success usually comes to those who are too busy to be looking for it.", author: "Henry David Thoreau", category: "Motivation" },
  { text: "Your time is limited, so don't waste it living someone else's life.", author: "Steve Jobs", category: "Motivation" },
  { text: "The best revenge is massive success.", author: "Frank Sinatra", category: "Motivation" },
  { text: "The harder you work for something, the greater you'll feel when you achieve it.", author: "Unknown", category: "Motivation" },
  { text: "Dream big and dare to fail.", author: "Norman Vaughan", category: "Motivation" },
  { text: "The only person you are destined to become is the person you decide to be.", author: "Ralph Waldo Emerson", category: "Motivation" },
  { text: "Go confidently in the direction of your dreams.", author: "Henry David Thoreau", category: "Motivation" },
  { text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson", category: "Motivation" },
  { text: "The journey of a thousand miles begins with one step.", author: "Lao Tzu", category: "Motivation" },
  { text: "Believe in yourself and all that you are.", author: "Christian D. Larson", category: "Motivation" },
  { text: "The only way to achieve the impossible is to believe it is possible.", author: "Charles Kingsleigh", category: "Motivation" },
  { text: "You are never too old to set another goal or to dream a new dream.", author: "C.S. Lewis", category: "Motivation" },

  // Love (20 quotes)
  { text: "Love is not about how many days, months, or years you have been together. Love is about how much you love each other every single day.", author: "Unknown", category: "Love" },
  { text: "The best thing to hold onto in life is each other.", author: "Audrey Hepburn", category: "Love" },
  { text: "Love is composed of a single soul inhabiting two bodies.", author: "Aristotle", category: "Love" },
  { text: "I love you not only for what you are, but for what I am when I am with you.", author: "Roy Croft", category: "Love" },
  { text: "Love recognizes no barriers. It jumps hurdles, leaps fences, penetrates walls to arrive at its destination full of hope.", author: "Maya Angelou", category: "Love" },
  { text: "To love and be loved is to feel the sun from both sides.", author: "David Viscott", category: "Love" },
  { text: "Love is when you meet someone who tells you something new about yourself.", author: "Andre Breton", category: "Love" },
  { text: "The greatest happiness of life is the conviction that we are loved.", author: "Victor Hugo", category: "Love" },
  { text: "Love doesn't make the world go round. Love is what makes the ride worthwhile.", author: "Franklin P. Jones", category: "Love" },
  { text: "Where there is love there is life.", author: "Mahatma Gandhi", category: "Love" },
  { text: "Love is a friendship set to music.", author: "Joseph Campbell", category: "Love" },
  { text: "The best love is the kind that awakens the soul.", author: "Nicholas Sparks", category: "Love" },
  { text: "Love is not finding someone to live with, it's finding someone you can't live without.", author: "Rafael Ortiz", category: "Love" },
  { text: "A successful marriage requires falling in love many times, always with the same person.", author: "Mignon McLaughlin", category: "Love" },
  { text: "Love is the only force capable of transforming an enemy into a friend.", author: "Martin Luther King Jr.", category: "Love" },
  { text: "The heart wants what it wants. There's no logic to these things.", author: "Woody Allen", category: "Love" },
  { text: "Love is like a virus. It can happen to anybody at any time.", author: "Maya Angelou", category: "Love" },
  { text: "To be brave is to love someone unconditionally.", author: "Margaret Anderson", category: "Love" },
  { text: "Love is the cure for all ills.", author: "Unknown", category: "Love" },
  { text: "True love stories never have endings.", author: "Richard Bach", category: "Love" },

  // Success (20 quotes)
  { text: "Success is not final, failure is not fatal: It is the courage to continue that counts.", author: "Winston Churchill", category: "Success" },
  { text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney", category: "Success" },
  { text: "Success usually comes to those who are too busy to be looking for it.", author: "Henry David Thoreau", category: "Success" },
  { text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson", category: "Success" },
  { text: "The only limit to our realization of tomorrow will be our doubts of today.", author: "Franklin D. Roosevelt", category: "Success" },
  { text: "Success is walking from failure to failure with no loss of enthusiasm.", author: "Winston Churchill", category: "Success" },
  { text: "The secret of success is to do the common thing uncommonly well.", author: "John D. Rockefeller", category: "Success" },
  { text: "Success is not in what you have, but who you are.", author: "Bo Bennett", category: "Success" },
  { text: "The road to success is always under construction.", author: "Lily Tomlin", category: "Success" },
  { text: "Success is the sum of small efforts, repeated day in and day out.", author: "Robert Collier", category: "Success" },
  { text: "Success is not the key to happiness. Happiness is the key to success.", author: "Albert Schweitzer", category: "Success" },
  { text: "The difference between a successful person and others is not a lack of strength, not a lack of knowledge, but rather a lack in will.", author: "Vince Lombardi", category: "Success" },
  { text: "Success is liking yourself, liking what you do, and liking how you do it.", author: "Maya Angelou", category: "Success" },
  { text: "Success is a journey, not a destination.", author: "Ben Sweetland", category: "Success" },
  { text: "The only place where success comes before work is in the dictionary.", author: "Vidal Sassoon", category: "Success" },
  { text: "Success is 99% failure.", author: "Soichiro Honda", category: "Success" },
  { text: "Success is not measured by what you accomplish, but by the opposition you have encountered.", author: "Grantland Rice", category: "Success" },
  { text: "Success is the result of perfection, hard work, learning from failure, loyalty, and persistence.", author: "Colin Powell", category: "Success" },
  { text: "Success is not for the chosen few, but for the few who choose it.", author: "Unknown", category: "Success" },
  { text: "Success is what happens after you have survived all your mistakes.", author: "Anora Lee", category: "Success" },

  // Wisdom (20 quotes)
  { text: "The only true wisdom is in knowing you know nothing.", author: "Socrates", category: "Wisdom" },
  { text: "Knowledge speaks, but wisdom listens.", author: "Jimi Hendrix", category: "Wisdom" },
  { text: "The wise man does not lay up his own treasures. The more he gives to others, the more he has for his own.", author: "Lao Tzu", category: "Wisdom" },
  { text: "It is better to remain silent at the point of extremes than to say something that is only half true.", author: "Pythagoras", category: "Wisdom" },
  { text: "Wisdom is not a product of schooling but of the lifelong attempt to acquire it.", author: "Albert Einstein", category: "Wisdom" },
  { text: "The fool wonders, the wise man asks.", author: "Benjamin Disraeli", category: "Wisdom" },
  { text: "Wisdom is the right use of knowledge. To know is not to be wise.", author: "Charles Spurgeon", category: "Wisdom" },
  { text: "The wise learn many things from their enemies.", author: "Aristophanes", category: "Wisdom" },
  { text: "Wisdom begins in wonder.", author: "Socrates", category: "Wisdom" },
  { text: "The older I grow, the more I listen to people who don't talk much.", author: "Germain G. Glien", category: "Wisdom" },
  { text: "Wisdom is knowing what to do next; virtue is doing it.", author: "David Starr Jordan", category: "Wisdom" },
  { text: "The wise man sees in the misfortune of others what he should avoid.", author: "Marcus Tullius Cicero", category: "Wisdom" },
  { text: "Wisdom comes from experience. Experience is often a result of lack of wisdom.", author: "Terry Pratchett", category: "Wisdom" },
  { text: "The wise adapt themselves to circumstances, as water molds itself to the pitcher.", author: "Chinese Proverb", category: "Wisdom" },
  { text: "Wisdom is the power to put our time and our knowledge to the proper use.", author: "Thomas J. Watson", category: "Wisdom" },
  { text: "The wise man does at once what the fool does finally.", author: "Niccolò Machiavelli", category: "Wisdom" },
  { text: "Wisdom is a treasure, the key whereof is never lost.", author: "Edward Counsel", category: "Wisdom" },
  { text: "The wise man thinks about his troubles only when there is some purpose in doing so.", author: "Bertrand Russell", category: "Wisdom" },
  { text: "Wisdom is the quality that keeps you from getting into situations where you need it.", author: "Doug Larson", category: "Wisdom" },
  { text: "The beginning of wisdom is the definition of terms.", author: "Socrates", category: "Wisdom" },

  // Humor (20 quotes)
  { text: "I told my wife she was drawing her eyebrows too high. She looked surprised.", author: "Unknown", category: "Humor" },
  { text: "Why don't scientists trust atoms? Because they make up everything!", author: "Unknown", category: "Humor" },
  { text: "I'm reading a book on anti-gravity. It's impossible to put down!", author: "Unknown", category: "Humor" },
  { text: "Parallel lines have so much in common. It's a shame they'll never meet.", author: "Unknown", category: "Humor" },
  { text: "I used to play piano by ear, but now I use my hands.", author: "Unknown", category: "Humor" },
  { text: "Why did the scarecrow win an award? Because he was outstanding in his field!", author: "Unknown", category: "Humor" },
  { text: "I told my computer I needed a break, and it replied 'I can't process that request.'", author: "Unknown", category: "Humor" },
  { text: "Why don't skeletons fight each other? They don't have the guts.", author: "Unknown", category: "Humor" },
  { text: "I asked my dog what's two minus two. He said nothing.", author: "Unknown", category: "Humor" },
  { text: "Why was the math book sad? Because it had too many problems.", author: "Unknown", category: "Humor" },
  { text: "I told my wife she was drawing her eyebrows too high. She looked surprised.", author: "Unknown", category: "Humor" },
  { text: "Why did the bicycle fall over? It was two-tired.", author: "Unknown", category: "Humor" },
  { text: "What do you call fake spaghetti? An impasta!", author: "Unknown", category: "Humor" },
  { text: "Why don't eggs tell jokes? They'd crack each other up.", author: "Unknown", category: "Humor" },
  { text: "What did one wall say to the other wall? I'll meet you at the corner.", author: "Unknown", category: "Humor" },
  { text: "Why did the golfer bring two pairs of pants? In case he got a hole in one.", author: "Unknown", category: "Humor" },
  { text: "What do you call a bear with no teeth? A gummy bear!", author: "Unknown", category: "Humor" },
  { text: "Why did the tomato turn red? Because it saw the salad dressing!", author: "Unknown", category: "Humor" },
  { text: "What did the grape say when it got stepped on? Nothing, it just let out a little wine.", author: "Unknown", category: "Humor" },
  { text: "Why don't seagulls fly over the bay? Because then they'd be bagels.", author: "Unknown", category: "Humor" },
];

// Generate SQL INSERT statements
const generateSQL = (quotes) => {
  const values = quotes.map(quote =>
    `('${quote.text.replace(/'/g, "''")}', '${quote.author?.replace(/'/g, "''") || 'Unknown'}', '${quote.category}')`
  ).join(',\n');

  return `INSERT INTO quotes (text, author, category) VALUES\n${values};`;
};

console.log(generateSQL(quotes));