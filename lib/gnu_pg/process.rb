# frozen_string_literal: true

module GnuPG
  class Process
    attr_reader :encrypted_file_path

    DECRYPTED_FILE_PATH = ENV['DECRYPTED_FILE_PATH']
    PASSPHRASE          = ENV['PGP_PASSPHRASE']
    PRIVATE_KEY         = Rails.application.secrets.pgp_private_key
    PRIVATE_KEY_PATH    = ENV['PGP_PRIVATE_KEY_PATH']
    RECEIVER_NAME       = ENV['RECEIVER_NAME']

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
        key: PRIVATE_KEY,
        path: PRIVATE_KEY_PATH
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
        private_key_path: PRIVATE_KEY_PATH,
        receiver_name: RECEIVER_NAME
      )
    end
  end
end
