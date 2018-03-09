# frozen_string_literal: true

require 'rails_helper'

describe GnuPG::DeleteData do
  let(:deleter) do
    described_class.call(
      private_key_path: private_key_path,
      receiver_name: receiver_name
    )
  end
  let(:homedir) { ENV['GPG_HOMEDIR'] }
  let(:receiver_name) { ENV['RECEIVER_NAME'] }
  let(:private_key) { Rails.application.secrets.pgp_private_key }
  let(:private_key_path) do
    Rails.root.join('spec', 'data', 'decryption', 'private_key.pgp')
  end

  before do
    GnuPG::ImportKey.call(key: private_key, path: private_key_path)
    deleter
  end

  it 'deletes the private key file' do
    expect(file_exists?(private_key_path)).to eq(false)
  end

  it 'deletes the private key' do
    expect(gnupg_key_exists?(receiver_name)).to eq(false)
  end

  it 'deletes the gnupg homedir' do
    expect(Dir.exist?(homedir)).to eq(false)
  end
end
