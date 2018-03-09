# frozen_string_literal: true

require 'rails_helper'

describe GnuPG::Decrypt do
  let(:decrypter) do
    described_class.call(
      passphrase: passphrase,
      decrypted_file_path: decrypted_file_path,
      encrypted_file_path: encrypted_file_path
    )
  end
  let(:passphrase) { ENV['PGP_PASSPHRASE'] }
  let(:decrypted_file_path) do
    Rails.root.join('spec', 'data', 'decryption', 'decrypted.pgp')
  end
  let(:encrypted_file_path) do
    Rails.root.join('spec', 'data', 'encrypted.pgp')
  end

  let(:private_key) { Rails.application.secrets.pgp_private_key }
  let(:private_key_path) do
    Rails.root.join('spec', 'data', 'decryption', 'private_key.pgp')
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
      expect(read_zipfile(decrypted_file_path)).to include('Shambhala')
    end
  end

  context 'failure' do
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
        clear_gnupg_private_key
      end

      it 'raises an error' do
        expect { decrypter }.to raise_error(
          GnuPG::Decrypt::Error, /secret key not available/
        )
      end
    end
  end
end
