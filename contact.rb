require 'pg'

class Contact

  attr_accessor :id, :name, :email

  #Connects to postgres db 'contacts'
  def self.conn
    PG.connect( dbname: 'contacts')
  end

  def initialize(name, email)
    self.name = name
    self.email = email
  end

  #to print out nicely instead of having objects printed out < >
  def to_s
    "#{name}, #{email}, #{id}"
  end

  # Lists all the contacts in the data base
  def self.list_all_contacts
    conn.exec_params("SELECT * FROM contacts").map do |row|
      contact = Contact.new(row['name'], row['email'])
      contact.id = row['id']
      contact
    end
  end
    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
  def self.create_new_contact(name, email)
    new_contact = Contact.new(name, email)
    new_contact.save
    new_contact
  end
  
  # DO NOT NEED ANYMORE SINCE THE ID IS AUTOMATICALLY GENERATED
  # Finds the  highest id on contact list
  # def provide_new_id
  #   all_ids = []
  #   #Adds all of the IDs into an array for further analysis
  #   CSV.foreach('contact_list.csv') do |row|
  #     all_ids << row[0].to_i
  #   end
  #   #Locates the highest ID
  #   highest_id = all_ids.max
  #   #puts "Checking the 'highest_id'"
  #   #puts highest_id
  #   new_id = highest_id + 1
  #   return new_id
  # end
  def self.find_contact_by_id(id)
    res = conn.exec_params("SELECT * FROM contacts WHERE id=$1", [id])
    return false if res.count == 0

    contact = Contact.new(res[0]['name'], res[0]['email'])
    contact.id = res[0]['id']
    contact
  end

  #Searches contacts
  def self.search_contacts(user_name_or_email)
    res = conn.exec_params("SELECT * FROM contacts WHERE name LIKE $1 OR email LIKE $1", ['%'+user_name_or_email+'%'])
    return false if res.count == 0

    contact = Contact.new(res[0]['name'], res[0]['email'])
    contact.id = res[0]['id']
    contact
  end

  def self.persisted?(id)
    !id.nil?
  end

  def self.save(id, name, email)
    if persisted?(id)
      new_contact = Contact.conn.exec_params("UPDATE contacts SET name=$1, email=$2 WHERE id=$3", [name, email, id])
      if new_contact.result_status == 1
        puts "Successfully updated: #{name}, #{email}, ID:#{id}"
      else
        puts "Error updating record"
      end 
    else
      rep = Contact.conn.exec_params("INSERT INTO contacts (name,email) VALUES ($1, $2) RETURNING id", [name, email])
      self.id = rep[0]['id']
    end
  end

end