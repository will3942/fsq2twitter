Foursquare2Twitter
========

Ruby application to update a user's Twitter Profile Location to their latest Foursquare checkin in realtime.

Dependencies
--------

1.  screen  
2.  ruby  
3.  sinatra (gem)  
4.  openssl  
5.  webrick (gem)  
6.  json (gem)  
7.  oauth (gem)  
8.  nginx (or apache but config not included)  

Installation
--------

1.  Clone files  

```ruby
$ git clone https://github.com/will3942/fsq2twitter.git  
$ cd fsq2twitter 
``` 
    
2.  Generate self-signed SSL certificates or install other ones. To generate follow the article [here](https://devcenter.heroku.com/articles/ssl-certificate-self "here"). Copy these into the "ssl" folder in the "fsq2twitter" folder.

3.  Edit the nginx config file with your domain name and ssl certificate locations
    
```ruby
$ sudo mv nginx-f2t-conf /etc/nginx/sites-enabled/  
$ sudo nano /etc/nginx/sites-enabled/nginx-f2t-conf  
$ sudo service nginx reload  
```

4.  Edit the fsq2twitter app file with your information. Generate the oauth keys and access tokens at https://foursquare.com/developers/ and https://dev.twitter.com/ . For twitter make sure "read and write" access is enabled for the access token.

5.  Launch the script and keep it running in the background.

```ruby
$ screen -S fsq2twitter  
$ ruby app.rb  
```

6.  Done!

Copyright
--------

All code in this script is Copyright Will Evans 2013. Contact me:  
[Twitter](http://twitter.com/will3942 "Twitter")  
[Email](mailto:will@will3942.com "Email")    
[App.net](http://alpha.app.net/willevans "App.net")  

LICENSE  
--------

Licensed under the Apache License, Version 2.0, detailed in the LICENSE file.
