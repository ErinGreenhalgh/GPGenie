# frozen_string_literal: true
require 'dotenv/load'
require 'rspec'
require 'fileutils'
require './spec/shared/test_helpers.rb'
require './lib/gpgenie/import_key.rb'

describe GPGenie::ImportKey do
  include TestHelpers
  let(:importer) { described_class.call(key: key, path: path) }
  let(:receiver_name) { ENV['RECEIVER_NAME'] }
  let(:key) { ENV['SECRET_KEY'] }
  let(:path) { ENV['SECRET_KEY_PATH'] }

  before(:each) {
    clear_gpg_keychain
  }
  
  after(:each) {
    remove_generated_files([path])
  }

  context 'successful' do
    context 'with a key and path provided' do
      before { importer }

      it 'creates a key file at the path provided' do
        expect(file_exists?(path)).to eq(true)
      end

      it 'imports the key' do
        expect(gnupg_key_exists?(receiver_name)).to eq(true)
      end
    end

    context 'with a key already imported' do
      before do
        allow(GPGenie::ImportKey::Error).to receive(:new)
      end

      it 'does not raise an error' do
        importer
        expect(GPGenie::ImportKey::Error).not_to have_received(:new)
      end
    end
  end

  context 'failure' do
    context 'with a blank key' do
      let(:key) { '' }

      it 'raises an error' do
        expect { importer }.to raise_error(GPGenie::ImportKey::Error, /blank key/)
      end
    end

    context 'with a blank path' do
      let(:path) { '' }

      it 'raises an error' do
        expect { importer }.to raise_error(
          GPGenie::ImportKey::Error, /blank path/
        )
      end
    end

    context 'with an invalid key' do
      let(:key) { 'bad key' }

      it 'raises an error' do
        expect { importer }.to raise_error(
          GPGenie::ImportKey::Error, /no valid OpenPGP data/
        )
      end
    end
  end
end
