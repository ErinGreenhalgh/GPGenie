# frozen_string_literal: true

module GPGenie
  class Decrypt
    class Error < StandardError; end

    attr_reader :encrypted_file_path,
                :decrypted_file_path,
                :passphrase

    GNUPG_HOME_DIR = ENV.fetch('GPG_HOMEDIR')

    def self.call(options)
      new(options).call
    end

    def initialize(passphrase:, decrypted_file_path:, encrypted_file_path:)
      @passphrase = passphrase
      @decrypted_file_path = decrypted_file_path
      @encrypted_file_path = encrypted_file_path
    end

    def call
      result = SystemClient.run('gpg', args: args)
      return result if result.success?
      error_message = "gpg decryption failed with error:#{result.stderr.inspect}"
      raise GPGenie::Decrypt::Error, error_message
    end

    private

    def args
      [
        '--batch',
        '--yes',
        '--no-use-agent',
        '--homedir',
        GNUPG_HOME_DIR,
        '--passphrase',
        passphrase,
        '--output',
        decrypted_file_path,
        '--decrypt',
        encrypted_file_path
      ]
    end
  end
end
