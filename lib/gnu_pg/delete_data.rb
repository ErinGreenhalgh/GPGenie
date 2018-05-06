# frozen_string_literal: true

module GnuPG
  class DeleteData
    GNUPG_HOME_DIR = ENV.fetch('GPG_HOMEDIR')

    attr_reader :secret_key_path,
                :receiver_name

    def self.call(options)
      new(options).call
    end

    def initialize(secret_key_path:, receiver_name:)
      @secret_key_path = secret_key_path
      @receiver_name = receiver_name
    end

    def call
      delete_secret_key_file
      delete_homedir
    end

    private

    def delete_secret_key_file
      FileUtils.rm(secret_key_path)
    end

    def delete_homedir
      return FileUtils.rm_rf(GNUPG_HOME_DIR, secure: true) if gnupg_config?
      raise 'ENV var does not contain a .gnupg directory'
    end

    def gnupg_config?
      GNUPG_HOME_DIR.end_with?('.gnupg')
    end
  end
end
