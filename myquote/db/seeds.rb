# db/seeds.rb
puts " Seeding MyQuote database..."

# ---- CLEAN UP EXISTING DATA ----
QuoteCategory.destroy_all
Quote.destroy_all
Category.destroy_all
Philosopher.destroy_all
User.destroy_all

# ---- USERS ----
puts " Creating users..."

# Required marking accounts
admin = User.create!(
  fname: "John", lname: "Jones",
  email: "admin@myquotes.com",
  password: "admin123",
  is_admin: true,
  status: "Active"
)

standard = User.create!(
  fname: "Vincent", lname: "Brown",
  email: "vinceb@myemail.com",
  password: "vince123",
  is_admin: false,
  status: "Active"
)

# Additional users
users = [
  {fname: "Alice", lname: "Ng", email: "alice@example.com"},
  {fname: "Ben", lname: "Kay", email: "ben@example.com"},
  {fname: "Cara", lname: "Lee", email: "cara@example.com"},
  {fname: "Dylan", lname: "Stone", email: "dylan@example.com"},
  {fname: "Ella", lname: "Rivera", email: "ella@example.com"},
  {fname: "Felix", lname: "Mann", email: "felix@example.com"},
  {fname: "Grace", lname: "Young", email: "grace@example.com"},
  {fname: "Henry", lname: "White", email: "henry@example.com"},
  {fname: "Isla", lname: "Patel", email: "isla@example.com"},
  {fname: "Jack", lname: "Olsen", email: "jack@example.com"},
  {fname: "Kara", lname: "Singh", email: "kara@example.com"},
  {fname: "Leo", lname: "Huang", email: "leo@example.com"}
]

users.each do |u|
  User.create!(
    fname: u[:fname], lname: u[:lname], email: u[:email],
    password: "password", is_admin: false, status: "Active"
  )
end

puts " Users created: #{User.count}"

# ---- PHILOSOPHERS ----
puts " Creating philosophers..."

philosophers = {
  plato:       {first_name: "Plato", last_name: "", birth_year: -427, death_year: -347, biography: "Classical Greek philosopher, student of Socrates."},
  aristotle:   {first_name: "Aristotle", last_name: "", birth_year: -384, death_year: -322, biography: "Student of Plato, teacher of Alexander the Great."},
  socrates:    {first_name: "Socrates", last_name: "", birth_year: -470, death_year: -399, biography: "Founder of Western moral philosophy."},
  kant:        {first_name: "Immanuel", last_name: "Kant", birth_year: 1724, death_year: 1804, biography: "German philosopher, central figure in modern philosophy."},
  nietzsche:   {first_name: "Friedrich", last_name: "Nietzsche", birth_year: 1844, death_year: 1900, biography: "German philosopher of culture and morality."},
  descartes:   {first_name: "René", last_name: "Descartes", birth_year: 1596, death_year: 1650, biography: "French philosopher, mathematician, 'I think, therefore I am.'"},
  confucius:   {first_name: "Confucius", last_name: "", birth_year: -551, death_year: -479, biography: "Chinese teacher and philosopher, emphasized moral integrity."},
  laozi:       {first_name: "Laozi", last_name: "", biography: "Ancient Chinese philosopher, founder of Taoism."},
  camus:       {first_name: "Albert", last_name: "Camus", birth_year: 1913, death_year: 1960, biography: "French-Algerian philosopher, wrote on absurdism."},
  sartre:      {first_name: "Jean-Paul", last_name: "Sartre", birth_year: 1905, death_year: 1980, biography: "French existentialist philosopher and playwright."},
  spinoza:     {first_name: "Baruch", last_name: "Spinoza", birth_year: 1632, death_year: 1677, biography: "Dutch philosopher of rationalism."},
  locke:       {first_name: "John", last_name: "Locke", birth_year: 1632, death_year: 1704, biography: "English philosopher, father of liberalism."},
  hobbes:      {first_name: "Thomas", last_name: "Hobbes", birth_year: 1588, death_year: 1679, biography: "Political philosopher, known for Leviathan."},
  anonymous:   {first_name: "", last_name: "Anonymous", biography: "Unknown or anonymous source."}
}

philosophers.each_value { |attrs| Philosopher.create!(attrs) }

puts " Philosophers created: #{Philosopher.count}"

# ---- CATEGORIES ----
puts " Creating categories..."

category_names = [
  "Metaphysics", "Epistemology", "Logic", "Ethics", "Aesthetics",
  "Political Philosophy", "Existentialism", "Stoicism",
  "Skepticism", "Pragmatism", "Human Nature", "Free Will", "Morality"
]

category_names.each { |n| Category.create!(name: n) }

puts " Categories created: #{Category.count}"

# ---- HELPER METHOD ----
def add_quote(owner:, text:, ph:, pub_year:, public:, cats:, comment: nil)
  cats = Array(cats).compact
  raise "No categories provided for: #{text[0..40]}..." if cats.empty?

  q = Quote.new(
    user: owner,
    quote_text: text,
    philosopher: ph,
    publication_year: pub_year,
    owner_comment: comment,
    is_public: public
  )
  # attach categories BEFORE saving so validation passes
  q.categories = cats
  q.save!      # runs validations now
  q
end

# ---- QUOTES ----
puts " Creating quotes..."

# Helper references
def P(name) Philosopher.find_by(last_name: name.to_s.capitalize) || Philosopher.find_by(first_name: name.to_s.capitalize) end
def C(*names) Category.where(name: names) end
def U(email) User.find_by(email: email) end

# A set of quotes spread among users
add_quote(owner: U("vinceb@myemail.com"),
          text: "The unexamined life is not worth living.",
          ph: P(:Socrates),
          pub_year: -399,
          public: true,
          cats: C("Ethics", "Metaphysics"),
          comment: "Classic Socratic wisdom.")

add_quote(owner: U("admin@myquotes.com"),
          text: "Happiness is the meaning and the purpose of life.",
          ph: P(:Aristotle),
          pub_year: -340,
          public: true,
          cats: C("Ethics"))

add_quote(owner: U("alice@example.com"),
          text: "Science is organized knowledge. Wisdom is organized life.",
          ph: P(:Kant),
          pub_year: 1798,
          public: true,
          cats: C("Epistemology", "Ethics"))

add_quote(owner: U("cara@example.com"),
          text: "He who has a why to live can bear almost any how.",
          ph: P(:Nietzsche),
          pub_year: 1889,
          public: true,
          cats: C("Existentialism"),
          comment: "Great quote on resilience.")

add_quote(owner: U("ben@example.com"),
          text: "I think, therefore I am.",
          ph: P(:Descartes),
          pub_year: 1637,
          public: true,
          cats: C("Metaphysics", "Epistemology"))

add_quote(owner: U("ella@example.com"),
          text: "The way is not in the sky. The way is in the heart.",
          ph: P(:Laozi),
          pub_year: nil,
          public: true,
          cats: C("Ethics", "Stoicism"))

add_quote(owner: U("grace@example.com"),
          text: "It does not matter how slowly you go as long as you do not stop.",
          ph: P(:Confucius),
          pub_year: nil,
          public: true,
          cats: C("Pragmatism", "Ethics"))

add_quote(owner: U("felix@example.com"),
          text: "Man is condemned to be free.",
          ph: P(:Sartre),
          pub_year: 1946,
          public: true,
          cats: C("Existentialism", "Free Will"))

add_quote(owner: U("isla@example.com"),
          text: "The greatest happiness of the greatest number is the foundation of morals.",
          ph: P(:Bentham),
          pub_year: nil,
          public: true,
          cats: C("Morality", "Ethics")) rescue nil # Bentham not defined, skip gracefully

add_quote(owner: U("jack@example.com"),
          text: "Life must be understood backward; but it must be lived forward.",
          ph: P(:Kierkegaard),
          pub_year: 1843,
          public: true,
          cats: C("Existentialism")) rescue nil

add_quote(owner: U("leo@example.com"),
          text: "Beauty is in the eye of the beholder.",
          ph: P(:Anonymous),
          pub_year: nil,
          public: false,
          cats: C("Aesthetics"),
          comment: "Private quote for testing visibility.")

add_quote(owner: U("dylan@example.com"),
          text: "Those who cannot remember the past are condemned to repeat it.",
          ph: P(:Santayana),
          pub_year: 1905,
          public: true,
          cats: C("Epistemology", "Human Nature")) rescue nil

add_quote(owner: U("henry@example.com"),
          text: "If men were angels, no government would be necessary.",
          ph: P(:Madison),
          pub_year: 1788,
          public: true,
          cats: C("Political Philosophy")) rescue nil

add_quote(owner: U("kara@example.com"),
          text: "Knowledge is power.",
          ph: P(:Bacon),
          pub_year: 1597,
          public: true,
          cats: C("Epistemology", "Pragmatism")) rescue nil

add_quote(owner: U("grace@example.com"),
          text: "No man's knowledge can go beyond his experience.",
          ph: P(:Locke),
          pub_year: 1690,
          public: true,
          cats: C("Epistemology"))

add_quote(owner: U("jack@example.com"),
          text: "Fear is the mother of morality.",
          ph: P(:Nietzsche),
          pub_year: 1883,
          public: true,
          cats: C("Ethics", "Morality"))

add_quote(owner: U("henry@example.com"),
          text: "The mind is furnished with ideas by experience alone.",
          ph: P(:Locke),
          pub_year: 1690,
          public: false,
          cats: C("Epistemology"),
          comment: "Private epistemology quote.")

add_quote(owner: U("alice@example.com"),
          text: "The greatest obstacle to discovery is not ignorance – it is the illusion of knowledge.",
          ph: P(:Anonymous),
          pub_year: nil,
          public: true,
          cats: C("Epistemology"))

add_quote(owner: U("vincentb@myemail.com"),
          text: "To be is to be perceived.",
          ph: P(:Berkeley),
          pub_year: 1710,
          public: true,
          cats: C("Metaphysics")) rescue nil

add_quote(owner: U("john@myquotes.com"),
          text: "The purpose of life is a life of purpose.",
          ph: P(:Anonymous),
          pub_year: nil,
          public: true,
          cats: C("Ethics", "Human Nature")) rescue nil

puts " Quotes created: #{Quote.count}"
puts " Seeding complete!"
