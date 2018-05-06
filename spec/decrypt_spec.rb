# frozen_string_literal: true
require 'dotenv/load'
require 'rspec'
require 'fileutils'
require './spec/shared/test_helpers.rb'
require './lib/gnu_pg/import_key.rb'
require './lib/gnu_pg/decrypt.rb'

describe GnuPG::Decrypt do
  include TestHelpers
  let(:decrypter) do
    described_class.call(
      passphrase: passphrase,
      decrypted_file_path: decrypted_file_path,
      encrypted_file_path: encrypted_file_path
    )
  end
  let(:passphrase) { ENV['PGP_PASSPHRASE'] }
  let(:decrypted_file_path) { ENV['DECRYPTED_FILE_PATH'] }
  let(:encrypted_file_path) { ENV['ENCRYPTED_FILE_PATH']}

  let(:private_key) { File.read('./spec/data/test_secret_key.gpg') }
  let(:private_key_path) { ENV['PGP_PRIVATE_KEY_PATH'] }
  let(:receiver_name) { ENV['RECEIVER_NAME'] }

  after(:all) do
    FileUtils.rm_rf(ENV['GPG_HOMEDIR'], secure: true)
  end 
  
  context 'successful' do
    before do
      GnuPG::ImportKey.call(key: private_key, path: private_key_path)
      decrypter
    end
    
    it 'stores the decrypted file in the provided filepath' do
      expect(file_exists?(decrypted_file_path)).to eq(true)
    end
    
    it 'correctly decrypts the message' do
      expect(File.read(decrypted_file_path)).to include('Hello, GPGenie')
    end
  end
  
  context 'failure' do
    before do
      GnuPG::ImportKey.call(key: private_key, path: private_key_path)
    end
    
    context 'with nonexistant encrypted file path' do
      let(:encrypted_file_path) { './wrong.pgp' }
      
      it 'raises an error' do
        expect { decrypter }.to raise_error(GnuPG::Decrypt::Error, /can't open/)
      end
    end
    
    context 'with wrong passphrase' do
      let(:passphrase) { '' }

      it 'raises an error' do
        expect { decrypter }.to raise_error(
          GnuPG::Decrypt::Error, /bad passphrase/
        )
      end
    end

    context 'without a private key in gpg' do
      before do
        clear_gnupg_private_key(receiver_name)
      end

      it 'raises an error' do
        expect { decrypter }.to raise_error(
          GnuPG::Decrypt::Error, /secret key not available/
        )
      end
    end
  end
end
