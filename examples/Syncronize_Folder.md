## Syncronize a Directory with Piwigo

To syncronize a folder-tree of im ages with Piwigo:

```ruby
require 'piwigo/session'
require 'piwigo/folder_sync'

folder = ARGV[0]
puts "Processing #{folder}"
session = Piwigo::Session.login('10.100.230.78', 'Adrian', 'mypassword', https: false)
unless session.nil?
  Piwigo::FolderSync.synchronize(session, folder)
end
```

Call the script with the directory to syncronize. Eg:

```ruby
ruby main.rb //DISKSTATION/photos/
```