module TestHelpers
  def file_exists?(file_path)
    File.file?(file_path)
  end

  def clear_gpg_keychain
    FileUtils.rm_rf(ENV['GPG_HOMEDIR'], secure: true)
  end

  def remove_generated_files(files)
    files.each do |file|
      File.delete(file) if file_exists?(file)
    end
  end 

  def gnupg_key_exists?(receiver_name)
    result = available_gnupg_keys(receiver_name)
    result.success?
  end

  def available_gnupg_keys(receiver_name)
    args = [
      '--homedir',
      ENV['GPG_HOMEDIR'],
      '--list-secret-keys',
      '--with-fingerprint',
      receiver_name,
    ]
    SystemClient.run('gpg', args: args)
  end

  def clear_gnupg_secret_key(receiver_name)
    return unless gnupg_secret_key_fingerprint(receiver_name)

    args = [
      '--homedir',
      ENV['GPG_HOMEDIR'],
      '--batch',
      '--yes',
      '--delete-secret-keys',
      gnupg_secret_key_fingerprint(receiver_name),
    ]

    SystemClient.run('gpg', args: args)
  end

  def gnupg_secret_key_fingerprint(receiver_name)
    @gnupg_secret_key_fingerprint ||= begin
      result = available_gnupg_keys(receiver_name)
      return unless result.stdout

      result.stdout.split("\n")
        &.select { |r| r.include?('Key fingerprint') }
        &.first
        &.split('=')
        &.last&.strip
    end
  end
end