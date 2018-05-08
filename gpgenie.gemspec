Gem::Specification.new do |s|
  s.name        = 'gpgenie'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'A wrapper over GPG for easy file decryption'
  s.description = 'Handles secret key import, decrypts files, and deletes sensitve data after decryption'
  s.authors     = ['Erin Greenhalgh']
  s.email       = 'eringreenhalgh13@gmail.com'
  s.files       = %w(lib/gpgenie/decrypt.rb
                     lib/gpgenie/delete_data.rb
                     lib/gpgenie/import_key.rb
                     lib/gpgenie/process.rb
                     lib/gpgenie/system_client.rb
                     lib/gpgenie.rb
                     .env
                     spec/data/.keep
                     spec/shared/encrypted_file.gpg
                     spec/shared/test_helpers.rb
                     spec/decrypt_spec.rb
                     spec/delete_data_spec.rb
                     spec/import_key_spec.rb
                     spec/process_spec.rb)

  s.homepage    = 'https://github.com/ErinGreenhalgh/GPGenie'
  s.metadata    = { 'source_code_uri' => 'https://github.com/ErinGreenhalgh/GPGenie' }
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'dotenv', '~> 2.4'
end
