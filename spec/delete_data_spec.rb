# frozen_string_literal: true
require 'rspec'
require 'fileutils'
require './spec/test_helpers.rb'
require './spec/data/variables.rb'
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
  let(:receiver_name) { VARIABLES[:receiver_name] }
  let(:private_key) { File.read('./spec/data/test_secret_key.gpg') }
  let(:private_key_path) { VARIABLES[:private_key_path]  }
    
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
