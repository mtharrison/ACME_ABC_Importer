require 'rubygems'
require 'twilio-ruby'

module ACMEJobStreamerImport

  # A logger class
  class Logger

    # Set up twilio SMS client
    def initialize config

      @twilio_config = config['twilio']
      @log_file = APP_ROOT + config['files']['log_file']
      @sms_client = Twilio::REST::Client.new @twilio_config['account_sid'], @twilio_config['auth_token']
      @types = {
        :error => "ERROR: ",
        :info => "INFO: ",
        :fatal => "FATAL ERROR: ",
      }
    end

    # Log a message to the log
    #
    # [type]  The message type. One of :info, :error, :fatal
    # [text]  The text to log
    def log type, text

      log_string = Time.now.to_s + ": " + @types[type] + text + "\n"

      File.open(@log_file, 'a') do |file|
        file.write log_string
      end

      puts log_string
    end

    # Log a fatal error, also sends an SMS message
    #
    # [text]  The text to log
    def fatal text
      log :fatal, text

      # Send an SMS to tell me it's broken!
      @sms_client.account.messages.create(
        :from => @twilio_config['send_number'],
        :to => @twilio_config['receive_number'],
        :body => "#{@twilio_config['message_prefix']} FATAL ERROR: #{text}"
        ) if SMS == true

    end

    # Log a non fatal error
    #
    # [text]  The text to log
    def error text
      log :error, text
    end

    # Log some info
    #
    # [text]  The text to log
    def info text
      log :info, text
    end

  end

end
