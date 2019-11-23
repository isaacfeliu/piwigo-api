## Upload a single image

Upload a single image if it doesn't already exist. Image is not associated with any Albums. The image will named apple-pie-bars

```ruby
session = Piwigo::Session.login('10.100.230.78', 'Adrian', 'mypassword', https: false)
unless session.nil?
  filename = 'C:\photos\apple-pie-bars-articleLarge.jpg'
  if Piwigo::Images.Lookup(session, filename).nil?
    Piwigo::Images.Upload(session, filename, 'apple-pie-bars')
  end
end
```

Piwigo will automatically associate the Author of the image as `Adrian` matching the session login id.