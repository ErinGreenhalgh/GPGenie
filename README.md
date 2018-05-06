# GPGenie
GPGenie is a wrapper over GPG functionality to quickly and safely decrypt files. 

### Usage
After configuring the environment variables, you can run the program like this:
```
GnuPG::Process.call('path/to/encrypted_file.gpg')
```
GPGenie will generate the decrypted file at a path you specify. In this process, it handles importing your secret key and deleting generated key data and wiping the GPG keychain, so you don't have to worry about any sensitive data persisting. 

### Environment Variables
GPGenie takes a number of environment variables needed to import your key and decrypt your file. 
You can see a list of the required ENV vars in my `.env` file, which is used in the test. 
When configuring your ENV vars, make sure to add a `GPG_HOMEDIR` variable. This will allow you to customize where GPG creates its config directory `.gnupg/`. You might need to customize this location if you are running GPGenie on a remote server.  

### Running the tests
`GPG_HOMEDIR='<full/path/to/desired/gpg_homedir>' rspec ./spec`