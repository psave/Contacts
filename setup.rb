require 'pry'
require 'active_record'
require_relative 'lib/contact'


# Output messages from Active Record to standard out
ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',  # what type of database are we working with?
  database: 'contacts', # what is the name of the database
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'

puts 'Setting up Database (recreating tables) ...'

ActiveRecord::Schema.define do
  drop_table :contacts if ActiveRecord::Base.connection.table_exists?(:contacts)
  # With the line below
  # ActiveRecord will run an CREATE TABLE 'articles' ....
  create_table :contacts do |t|
    # t.column :id, :integer, autoincremented is always added by ActiveRecord
    t.column :name, :string
    t.column :email, :string
    # t.timestamps is a short form for
    # t.column :created_at, :timestamp
    # t.column :updated_at, :timestamp
  end
  # add_index :contacts  # see index note below

  # add_index :contacts, :contact_id  # Instruct the database to make the article_id column easily searchable
end

puts "Setup DONE\n\n\n\n\n\n"

# Inserting Records
Shane = Contact.create(name: "Shane McConkey", email: "skier@mountain.com")
Jack = Contact.create(name: "Jack Daniels", email: "jack@damiels.com")
Moon = Contact.create(name: "Whistler Blackcomb", email: "whistler@blackcomb.com")

# new_contact = Contact.new
# new_contact.name = "Some Name"
# new_contact.email = "blank@blank.com"
# new_contact.save

contacts_created = Contact.count
puts "Total contacts created: #{contacts_created}"


