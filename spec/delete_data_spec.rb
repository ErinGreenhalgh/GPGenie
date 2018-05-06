# frozen_string_literal: true
require 'dotenv/load'
require 'rspec'
require 'fileutils'
require './spec/shared/test_helpers.rb'
require './lib/gnu_pg/delete_data.rb'
require './lib/gnu_pg/import_key.rb'

describe GnuPG::DeleteData do
  include TestHelpers
  let(:deleter) do
    described_class.call(
      private_key_path: private_key_path,
      receiver_name: receiver_name
    )
  end
  let(:homedir) { ENV['GPG_HOMEDIR'] }
  let(:receiver_name) { ENV['RECEIVER_NAME'] }
  let(:private_key) { File.read('./spec/data/test_secret_key.gpg') }
  let(:private_key_path) { ENV['PGP_PRIVATE_KEY_PATH']  }
    
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
