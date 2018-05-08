# frozen_string_literal: true

require 'dotenv/load'
require 'rspec'
require 'fileutils'
require './spec/shared/test_helpers.rb'
require './lib/gpgenie/process.rb'
require './lib/gpgenie/import_key.rb'
require './lib/gpgenie/decrypt.rb'
require './lib/gpgenie/delete_data.rb'

describe GPGenie::Process do
  include TestHelpers
  let(:processer) do
    described_class.call(encrypted_file_path: encrypted_file_path)
  end
  let(:encrypted_file_path) { ENV['ENCRYPTED_FILE_PATH']}

  context 'successful' do
    before do
      allow(GPGenie::ImportKey).to receive(:call).and_call_original
      allow(GPGenie::Decrypt).to receive(:call).and_call_original
      allow(GPGenie::DeleteData).to receive(:call).and_call_original

      processer
    end

    after(:each) do 
      remove_generated_files([ENV['DECRYPTED_FILE_PATH']])
    end 

    it 'calls GPGenie::ImportKey' do
      expect(GPGenie::ImportKey).to have_received(:call).with(
        key: anything,
        path: anything
      )
    end

    it 'calls GPGenie::Decrypt' do
      expect(GPGenie::Decrypt).to have_received(:call).with(
        passphrase: anything,
        encrypted_file_path: anything,
        decrypted_file_path: anything
      )
    end

    it 'calls GPGenie::DeleteData' do
      expect(GPGenie::DeleteData).to have_received(:call).with(
        secret_key_path: anything,
        receiver_name: anything
      )
    end

    it 'returns a decrypted file path' do
      expect(file_exists?(processer)).to eq(true)
    end
  end

  context 'failure' do
    before do
      allow(GPGenie::ImportKey).to receive(:call).and_call_original
      allow(GPGenie::Decrypt).to receive(:call).and_raise('some error')
      allow(GPGenie::DeleteData).to receive(:call).and_call_original
    end

    it 'raises an error' do
      expect { processer }.to raise_error('some error')
      expect(GPGenie::DeleteData).to have_received(:call)
    end
  end
end
