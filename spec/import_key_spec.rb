# frozen_string_literal: true
require 'rspec'
require 'fileutils'
require './spec/test_helpers.rb'
require './lib/gnu_pg/import_key.rb'

describe GnuPG::ImportKey do
  include TestHelpers
  let(:importer) { described_class.call(key: key, path: path) }
  let(:receiver_name) { 'GPGenie' }
  let(:key) { File.read('./spec/data/test_secret_key.gpg') }
  let(:path) { './spec/data/generated_secret_key_file.gpg' }

  before(:each) {
    FileUtils.rm_rf(Dir.glob(ENV['GPG_HOMEDIR']), secure: true)
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
        allow(GnuPG::ImportKey::Error).to receive(:new)
      end

      it 'does not raise an error' do
        importer
        expect(GnuPG::ImportKey::Error).not_to have_received(:new)
      end
    end
  end

  context 'failure' do
    context 'with a blank key' do
      let(:key) { '' }

      it 'raises an error' do
        expect { importer }.to raise_error(GnuPG::ImportKey::Error, /blank key/)
      end
    end

    context 'with a blank path' do
      let(:path) { '' }

      it 'raises an error' do
        expect { importer }.to raise_error(
          GnuPG::ImportKey::Error, /blank path/
        )
      end
    end

    context 'with an invalid key' do
      let(:key) { 'bad key' }

      it 'raises an error' do
        expect { importer }.to raise_error(
          GnuPG::ImportKey::Error, /no valid OpenPGP data/
        )
      end
    end
  end
end
