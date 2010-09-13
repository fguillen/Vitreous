# Vitrious
![Vitrious](http://farm5.static.flickr.com/4151/4987527096_2245385d8c.jpg)

Magic online portfolio manager.

Synchronization directly from your hard disc to your web site.

Dropbox utility.

## Dependencies

Dropbox.


## Install

### Local

* Install (Dropbox)[https://www.dropbox.com/install].
* Download the (Dropbox Vitrious Example Tree)[http://github.com/fguillen/Vitrious/blob/master/example/Dropbox_Tree_Example.zip]
* Unzip it into your local /Dropbox folder
* It should create the /Dropbox/Public/Vitrious folder with example data
* Synch your Dropbox

### Dropbox

* Create an App on the (Dropbox API Site)[https://www.dropbox.com/developers/apps]
* Anote the 'App keys' for this app.

### Server

* Download Vitrious:
    git clone git://github.com/fguillen/Vitrious.git
* Install gems:
    sudo bundle install
* Start server:
    rackup config.ru  # better if you use Passenger or something like that
* Config your app:
    rake config dropbox_consumer_key='CONSUMER KEY' dropbox_consumer_secret='CONSUMER SECRET' website_name='My Portfolio' pass='yourpass'
    

### First Use

* Connect Vitrious with your Dropbox Account:
    http://your-vitrious-site.com/authorize/<yourpass>


## Updating your portfolio

If you update something on your */Dropbox/Public/Vitrious* folder the changes will not affect immediately to your Vitrious web site. You have to refresh your Vitrious cache using the next link:

    http://your-vitrious-site.com/refresh/<yourpass>



