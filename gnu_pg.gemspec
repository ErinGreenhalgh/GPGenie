Gem::Specification.new do |s|
  s.name        = 'gnu_pg'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Decrypts files"
  s.description = "It can decrypt things"
  s.authors     = ["Erin"]
  s.email       = 'eringreenhalgh13@gmail.com'
  s.files       = %w(lib/gnu_pg/decrypt.rb
                     lib/gnu_pg/delete_data.rb
                     lib/gnu_pg/import_key.rb
                     lib/gnu_pg/process.rb
                     lib/gnu_pg.rb
                     spec/decrypt_spec.rb
                     spec/delete_data_spec.rb
                     spec/import_key_spec.rb
                     spec/process_spec.rb)

  s.homepage    = 'https://rubygems.org/gems/example'
  s.metadata    = { "source_code_uri" => "https://github.com/example/example" }
end
