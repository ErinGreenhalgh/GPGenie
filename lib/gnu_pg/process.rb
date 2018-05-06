# frozen_string_literal: true

module GnuPG
  class Process
    attr_reader :encrypted_file_path

    DECRYPTED_FILE_PATH = ENV.fetch('DECRYPTED_FILE_PATH')
    PASSPHRASE          = ENV.fetch('GPG_PASSPHRASE')
    SECRET_KEY         = ENV.fetch('SECRET_KEY')
    SECRET_KEY_PATH    = ENV.fetch('SECRET_KEY_PATH')
    RECEIVER_NAME       = ENV.fetch('RECEIVER_NAME')

    def self.call(options)
      new(options).call
    end

    def initialize(encrypted_file_path:)
      @encrypted_file_path = encrypted_file_path
    end

    def call
      begin
        import_key
        decrypt_file
      ensure
        delete_data
      end

      DECRYPTED_FILE_PATH
    end

    private

    def import_key
      GnuPG::ImportKey.call(
        key: SECRET_KEY,
        path: SECRET_KEY_PATH
      )
    end

    def decrypt_file
      GnuPG::Decrypt.call(
        passphrase: PASSPHRASE,
        encrypted_file_path: encrypted_file_path,
        decrypted_file_path: DECRYPTED_FILE_PATH
      )
    end

    def delete_data
      GnuPG::DeleteData.call(
        secret_key_path: SECRET_KEY_PATH,
        receiver_name: RECEIVER_NAME
      )
    end
  end
end
