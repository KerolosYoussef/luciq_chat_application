module Applications
  class CreateService
    def self.call(application_params)
      @application = Application.new(application_params)

      # generate new token for the application
      @application.token = TokenGenerator.generate_unique_token

      @application
    end
  end
end