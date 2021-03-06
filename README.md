# GPGenie
GPGenie is a wrapper over GPG functionality to quickly and safely decrypt files. 

### The Decryption Process
GPG is an encryption software that allows users to decrypt and encrypt files using public key, or asymmetric encryption. This means that the key that is used to encrypt the file (the public key), is not the same as the key used to decrypt the file (the secret key). 

GPGenie assumes that you already have everything you need for decryption:
- a secret key
- the passphrase used to protect the secret key
- a file encrypted with the corresponding public key

It then performs these steps:
1. imports the secret key into the GPG keychain by generating a file from which to read the key
2. decrypts the file using the secret key and passphrase
3. deletes the generated secret key file and removes GPG's config directory that houses the keychain

### Environment Variables
GPGenie takes a number of environment variables needed to import your key and decrypt your file. 
- `ENCRYPTED_FILE_PATH`: the path to an existing file encrypted through GPG public key encryption
- `DECRYPTED_FILE_PATH`: the path to the decrypted file that will be generated by GPGenie
- `GPG_HOMEDIR`: the full path to the location where GPG will create its config directory, `.gnupg`. This houses the GPG keychain. 
- `GPG_PASSPHRASE`: the password that protects the secret key
- `RECEIVER_NAME`: the name of the owner of the public and secret key pair
- `SECRET_KEY`: the key itself, used to decrypt the file 
- `SECRET_KEY_PATH`: the path to the file that GPG will generate to store your secret key. GPG needs to read the key from a file in order to import it into the keychain. 

You can see examples of the required ENV vars in my `.env` file, which is used in the test. All ENV vars are listed except the `GPG_HOMEDIR`. 

### Usage
After configuring the environment variables, you can run the program like this:
``` ruby
require 'gpgenie.rb' # or relative path to this file
GPGenie::Process.call(encrypted_file_path: ENV['ENCRYPTED_FILE_PATH'])
```

### Running the tests
`GPG_HOMEDIR='<full/path/to/desired/gpg_homedir>' rspec ./spec`