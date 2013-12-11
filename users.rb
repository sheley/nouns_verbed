require 'pbkdf2'
require 'securerandom'

class Users
  def initialize(db)
    @db = db
  end

  def find_user(username)
    @db[:users].where(:username => username).all.first
  end

  def authenticate(username, password_given)
    if user = find_user(username)
      if correct_password?(password_given, user[:salt], user[:password_hash])
        user
      end
    end
  end

  def correct_password?(password_given, salt, saved_password_hash)
    generate_password_hash(password_given, salt) == saved_password_hash
  end

  def insert_new_user(username, password)
    @db[:users] << generate_user_hash(username, password)
  end

  def generate_user_hash(username, password)
    salt = generate_salt
    password_hash = generate_password_hash(password, salt)
    {
      :username => username,
      :salt => salt,
      :password_hash => password_hash,
    }
  end

  def generate_password_hash(password, salt)
    PBKDF2.new(
      :password => password,
      :salt => salt,
      :iterations => 1000
      ).hex_string
  end

  def generate_salt
    SecureRandom.hex(32)
  end
end
