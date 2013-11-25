require 'pbkdf2'
require 'securerandom'

#

class Users
  def initialize(db)
    @db = db
  end

  def find_user(username)
    @db[:users].where(:username => username).all.first
  end

  def authenticate?(username, password_given)
    if user = find_user(username)
      correct_password?(password_given, user)
    else
      false 
    end
  end

  def correct_password?(password_given, user)
    true
  end

  def insert_new_user(password, username)
    @db[:users].insert_ignore << generate_user_hash(password, username)
  end

  def generate_user_hash(password, username)
    generate_password_hash(password).merge(:username => username)
  end

  def generate_password_hash(password)
    PBKDF2.new(
      :password => password,
      :salt => generate_salt,
      :iterations => 1000 ).hex_string
  end

  def generate_salt
    SecureRandom.hex(32)
  end
end
