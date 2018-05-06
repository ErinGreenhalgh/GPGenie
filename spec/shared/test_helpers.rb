module TestHelpers
  def file_exists?(file_path)
    File.file?(file_path)
  end

  def delete_file(file_path)
    File.delete(file_path)
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

  def clear_gnupg_private_key(receiver_name)
    return unless gnupg_private_key_fingerprint(receiver_name)

    args = [
      '--homedir',
      ENV['GPG_HOMEDIR'],
      '--batch',
      '--yes',
      '--delete-secret-keys',
      gnupg_private_key_fingerprint(receiver_name),
    ]

    SystemClient.run('gpg', args: args)
  end

  def gnupg_private_key_fingerprint(receiver_name)
    @gnupg_private_key_fingerprint ||= begin
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