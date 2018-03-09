# frozen_string_literal: true

require 'rails_helper'

describe GnuPG::Process do
  let(:processer) do
    described_class.call(encrypted_file_path: encrypted_file_path)
  end
  let(:encrypted_file_path) { ENV['ENCRYPTED_FILE_PATH'] }

  context 'successful' do
    before do
      allow(GnuPG::ImportKey).to receive(:call).and_call_original
      allow(GnuPG::Decrypt).to receive(:call).and_call_original
      allow(GnuPG::DeleteData).to receive(:call).and_call_original

      processer
    end

    it 'calls GnuPG::ImportKey' do
      expect(GnuPG::ImportKey).to have_received(:call).with(
        key: anything,
        path: anything
      )
    end

    it 'calls GnuPG::Decrypt' do
      expect(GnuPG::Decrypt).to have_received(:call).with(
        passphrase: anything,
        encrypted_file_path: anything,
        decrypted_file_path: anything
      )
    end

    it 'calls GnuPG::DeleteData' do
      expect(GnuPG::DeleteData).to have_received(:call).with(
        private_key_path: anything,
        receiver_name: anything
      )
    end

    it 'returns a decrypted file path' do
      expect(file_exists?(processer)).to eq(true)
    end
  end

  context 'failure' do
    before do
      allow(GnuPG::ImportKey).to receive(:call).and_call_original
      allow(GnuPG::Decrypt).to receive(:call).and_raise('some error')
      allow(GnuPG::DeleteData).to receive(:call).and_call_original
    end

    it 'raises an error' do
      expect { processer }.to raise_error('some error')
      expect(GnuPG::DeleteData).to have_received(:call)
    end
  end
end
