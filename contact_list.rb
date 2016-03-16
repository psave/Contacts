require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def user_menu
    puts "Here is a list of available commands:"
    puts "\tnew         - Create a new contact"
    puts "\tupdate id#  - Update a contact. (i.e. 'update 2'"
    puts "\tlist        - List all contacts"
    puts "\tshow id#    - Show a contact (i.e. 'show 72'"
    puts "\tsearch      - Search contacts (i.e. 'search Joe@email.com' or 'search Jack')"
    #puts "ARGV is #{ARGV}"
    user_selection()
  end

  # def seach_by_id
  #   Contact.find_contact_by_id
  # end
  
  # def find_contact_by_id(user_id)
  #   #raise '@candidates must be an Array' if @candidates.nil?
  #   CSV.read('contact_list.csv').find { |candidate| candidate[:id] == id}
  # end

  def enter_new_contact
    puts "Enter the first and last name of your contact: i.e. Johnny Walker "
    name = STDIN.gets.chomp
    puts "Enter the e-mail of your contact: i.e. (johnnny.walker@jw.com)"
    email = STDIN.gets.chomp
    Contact.create_new_contact(name, email)
  end

  def update_contact(id)
    #Escape if id does not exist
    the_contact = Contact.find_contact_by_id(id)
    puts "Is this the contact you would like to update? 'y' or 'n':\n #{the_contact}"
    yes_or_no = STDIN.gets.chomp
    if yes_or_no == "n"
      puts "Exiting program."
    elsif yes_or_no == "y"
      puts "What is the new name?"
      name = STDIN.gets.chomp
      puts "What is the new email?"
      email = STDIN.gets.chomp
      Contact.save(id, name, email)
      # if /name/.match(response)
      #   puts "What would you like the new name to be?"
      #   new_name = STDIN.gets.chomp
      #   Contact.update(new_name)
      # elsif /email/.match(response)
      #   puts "What would you like the new email to be?"
      #   new_email = STDIN.gets.chomp
      #   Contact.update(new_email)
      # end
    end
  end

  def user_selection()
    if ARGV[0] == "list"
      Contact.list_all_contacts
    elsif ARGV[0] == "new"
      enter_new_contact
    elsif /update/.match(ARGV[0])
      update_contact(ARGV[1])
    elsif /show/.match(ARGV[0])
      Contact.find_contact_by_id(ARGV[1])
    elsif /search/.match(ARGV[0])
      Contact.search_contacts(ARGV[1])
    else
      puts "invalid command"
    end
  end
end

latest_list = ContactList.new
# puts Latest_List.user_menu
puts latest_list.user_menu
# Latest_List.user_selection(command)
