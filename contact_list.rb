require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def user_menu
    puts "Here is a list of available commands:"
    puts "\tnew       - Create a new contact"
    puts "\tlist      - List all contacts"
    puts "\tshow id#  - Show a contact (i.e. 'show 72'"
    puts "\tsearch    - Search contacts (i.e. 'search Joe@email.com' or 'search Jack')"
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

  def user_selection()
    if ARGV[0] == "list"
      Contact.list_all_contacts
    elsif ARGV[0] == "new"
      enter_new_contact
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
