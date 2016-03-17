require 'pry'
require 'active_record'
require_relative 'lib/contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  def establish_connection
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
  end
  
  # def user_menu
  #   puts "Here is a list of available commands:"
  #   puts "\tnew         - Create a new contact"
  #   puts "\tupdate id#  - Update a contact. (i.e. 'update 2'"
  #   puts "\tlist        - List all contacts"
  #   puts "\tshow id#    - Show a contact (i.e. 'show 72'"
  #   puts "\tsearch      - Search contacts (i.e. 'search Joe@email.com' or 'search Jack')"
  #   #puts "ARGV is #{ARGV}"
  #   user_selection()
  # end
 
  def user_selection()
    if ARGV[0] == "list"
      puts "You just entered list"
      list_all_contacts
    elsif ARGV[0] == "new"
      enter_new_contact
    elsif /update/.match(ARGV[0])
      update_contact(ARGV[1])
    elsif /show/.match(ARGV[0])
      find_contact_by_id(ARGV[1])
    elsif /search/.match(ARGV[0])
      search_contacts(ARGV[1])
    else
      puts "invalid command"
    end
  end

  def pretty_print(contact)
    #do something with each item in the array
    id = contact.id
    name = contact.name
    email = contact.email
    "#{name}, #{email}, #{id}"
  end

  # Lists all the contacts in the data ase
  def list_all_contacts
    all_contacts = Contact.all
    all_contacts.each do |contact|
      puts pretty_print(contact)
    end
  end

  #Enters and creates new contacts
  def enter_new_contact
    puts "Enter the first and last name of your contact: i.e. Johnny Walker "
    new_contact = Contact.new
    new_contact.name = STDIN.gets.chomp
    puts "Enter the e-mail of your contact: i.e. (johnnny.walker@jw.com)"
    new_contact.email = STDIN.gets.chomp
    new_contact.save
    puts pretty_print(new_contact)
  end
  
  def find_contact_by_id(id)
    contact = Contact.find(id)
    puts pretty_print(contact)
  end

  #Searches contacts
  def search_contacts(user_name_or_email)
    contact = Contact.where("name LIKE '%#{user_name_or_email}%' OR email LIKE '%#{user_name_or_email}%'").first
    # pretty_print(search_names)
    if !contact.nil?
      puts pretty_print(contact)
    # elsif Contact.find_by(email: user_name_or_email)
    #   puts pretty_print(Contact.find_by(email: user_name_or_email))
    else
      puts "That user does not exist"
    end
  end

  def update_contact(id)
    #Escape if id does not exist
    the_contact = Contact.find(id)
    print "Here is the contact: "
    puts pretty_print(the_contact)
    print "\nIs this the contact you would like to update? 'y' or 'n': "
    yes_or_no = STDIN.gets.chomp
    if yes_or_no == "n"
      puts "Exiting program."
    elsif yes_or_no == "y"
      update_contact = Contact.find(id)
      puts "What is the new name?"
      update_contact.name = STDIN.gets.chomp
      puts "What is the new email?"
      update_contact.email = STDIN.gets.chomp
      # contact = Contact.new(name, email)
      # contact.id = id
      update_contact.save
      print "Contact saved successfully:  "
      puts pretty_print(update_contact)
    end
  end

end

#Perhaps do not need this code!!!
latest_list = ContactList.new
latest_list.establish_connection

latest_list.user_selection

