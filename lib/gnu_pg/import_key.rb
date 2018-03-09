# frozen_string_literal: true

module GnuPG
  class ImportKey
    class Error < StandardError; end

    NON_FATAL_ERROR = 'already in secret keyring'
    GNUPG_HOME_DIR  = ENV.fetch('GPG_HOMEDIR')

    attr_reader :path,
                :key

    def self.call(options)
      new(options).call
    end

    def initialize(key:, path:)
      @key = key
      @path = path
    end

    def call
      create_key_file
      result = import_key

      return result if result.success?
      return result if result.stderr.include? NON_FATAL_ERROR
      error_message = "gpg failed with error: #{result.stderr.inspect}"
      raise GnuPG::ImportKey::Error, error_message
    end

    private

    def create_key_file
      raise Error, 'blank key provided' if key.blank?
      raise Error, 'blank path provided' if path.blank?

      File.open(path, 'w+') { |f| f.write(key) }
    end

    def import_key
      args = [
        '--homedir',
        GNUPG_HOME_DIR,
        '--import',
        path
      ]

      SystemClient.run('gpg', args: args)
    end
  end
end
