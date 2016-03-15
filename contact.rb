
require 'csv'
contacts = CSV.read('contact_list.csv')

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self
    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def list_all_contacts
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      return CSV.read('contact_list.csv')
    end
    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create_new_contact(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it
      latest_id = provide_new_id
      #add info to the CSV
      CSV.open('contact_list.csv', 'a+') do |csv_object|
        csv_object << [latest_id, name, email]
      end
      return "\nNew contact created: ID: #{latest_id}, Name: #{name}, email: #{email}"
    end
    
    # Finds the  highest id on contact list
    def provide_new_id
      all_ids = []
      #Adds all of the IDs into an array for further analysis
      CSV.foreach('contact_list.csv') do |row|
        all_ids << row[0].to_i
      end
      #Locates the highest ID
      highest_id = all_ids.max
      #puts "Checking the 'highest_id'"
      #puts highest_id
      new_id = highest_id + 1
      return new_id
    end
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find_contact_by_id(user_id) #searches for an ID
      #Pulls out the ID number from the string.
      csv_text = File.read('contact_list.csv')
      csv = CSV.parse(csv_text)
      if
        csv.each do |row|
          puts row if row[0] == user_id
        end
      else
        return nil
      end
    end
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search_contacts(user_name_or_email)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      csv_text = File.read('contact_list.csv')
      csv = CSV.parse(csv_text)
      if
        csv.each do |row|
          puts row if row[1].match(user_name_or_email) || row[2] == user_name_or_email
        end
      else
        return nil
      end
    end
  end
end