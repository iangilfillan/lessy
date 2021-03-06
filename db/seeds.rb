# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

raise 'You cannot run seeds in production' if Rails.env.production?

[Task, Project, User].each do |table|
  puts "Deleting #{table.class.name} records..."
  table.delete_all
end

puts 'Starting seeding...'

puts 'Creating Users records...'
user = User.create!(
  email: 'dale.cooper@zéro.org',
  username: 'dalecooper',
  password: 'secret',
  admin: true,
)
user.activate!

puts 'Creating Projects records...'
Project.create!([
  { name: Faker::Company.catch_phrase, user: user },
  { name: Faker::Company.catch_phrase, user: user },
  { name: Faker::Company.catch_phrase, user: user },
  { name: Faker::Company.catch_phrase, user: user },
  { name: Faker::Company.catch_phrase, user: user },
  { name: Faker::Company.catch_phrase, user: user, state: 'started', started_at: 30.days.ago, due_at: 20.days.from_now },
  { name: Faker::Company.catch_phrase, user: user, state: 'started', started_at: 10.days.ago, due_at: 42.days.from_now },
])

puts 'Creating Tasks records...'
order_sequence = (1..11).to_a.shuffle
Task.create!([
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: DateTime.now },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: DateTime.now },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: DateTime.now },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: DateTime.now },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: DateTime.now },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: DateTime.now },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: 1.week.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'started', started_at: 2.weeks.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'planned', started_at: DateTime.now, planned_at: 1.day.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'planned', started_at: DateTime.now, planned_at: 2.days.ago },
  { label: Faker::TwinPeaks.quote, user: user, order: order_sequence.pop, state: 'planned', started_at: 1.week.ago, planned_at: 1.day.ago, planned_count: 3 },
])

puts 'Seeds are now ready! You can login with: dalecooper / secret'
