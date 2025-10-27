require 'securerandom'
class TokenGenerator
  def self.generate_unique_token
    SecureRandom.uuid
  end
end
