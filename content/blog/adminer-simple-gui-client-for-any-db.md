---
title: "Adminer — a simple GUI client for any DB"
date: 2019-03-04T06:39:01.304Z
draft: false
tags: ["Databases"]
---

In my search for a good database GUI client for PostgreSQL, I came across a light-weight and elegant GUI client called [Adminer](https://www.adminer.org). Adminer is a is a full-featured database management tool built with PHP.

Before Adminer, I used pgAdmin III. I hoped it'd be similar to PHPMyAdmin but it wasn't nearly as good in terms of the user interface and functionality. I found it difficult to navigate and had to write queries to perform even basic tasks. Coming from PHPMyAdmin, this was a no no for me.

I'd used PHPMyAdmin (via XAMPP) for MySQL but decided to skip XAMPP when I moved from Windows to Ubuntu/Linux a few years ago. So I started using MySQL Workbench. I was also using MongoDB Compass (and Studio 3T briefly) for MongDB.

Now I use Adminer for all my DBs. I actively work with MySQL, PostgreSQL and MongoDB so this is really cool. So far, I've had zero issues with Adminer. It's fast, simple and gets out of the way when I need to get stuff done.

In this article, I'll show you how to setup Adminer on your machine.

### Install PHP for your OS
- [Installation instructions for Windows](https://www.jeffgeerling.com/blog/2018/installing-php-7-and-composer-on-windows-10).
- [Installation instructions for Mac](https://tecadmin.net/install-php-macos/).
- [Installation instructions for Ubuntu/Linux](https://tecadmin.net/install-php-7-on-ubuntu/).

__NB:__ After installation, add the PHP CLI to your path if it's not already added. You can test this by running `php --version`. You should get a similar result to the one shown below.

    $ php --version
    PHP 7.2.15-0ubuntu0.18.04.1 (cli) (built: Feb  8 2019 14:54:22) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Zend OPcache v7.2.15-0ubuntu0.18.04.1, Copyright (c) 1999-2018, by Zend Technologies

### Install a DB server (optional)
Adminer currently supports MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle, SimpleDB, Elasticsearch and MongoDB. If you want to use any of these databases locally, you need to install them on your machine.

You can also connect to a DB server on a remote machine (e.g a DigitalOcean VPS) or a managed DB service (e.g AWS RDS). In this case, you don't need to install the DB server on your computer.

I'll be demonstrating with MySQL here. If you want to follow along, you can install MySQL for your OS.

- [Installation instructions for Windows](https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html).
- [Installation instructions for Mac](https://tecadmin.net/install-mysql-macos/).
- [Installation instructions for Ubuntu/Linux](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04).

### Install DB extensions for PHP (optional)
If you installed a DB server (the previous step), you might need to [install the PHP extension for it](http://php.net/manual/en/refs.database.php) and/or update your PHP config file.

### Download and setup Adminer
Adminer is just one PHP file! You can [download it from the Adminer website](https://www.adminer.org/#download). The latest version at the time of writing this tutorial is [4.7.1](https://github.com/vrana/adminer/releases/download/v4.7.1/adminer-4.7.1.php). When you download the PHP file, you can put it anywhere you want. Mine is in a directory named _adminer_ (i.e `~/dev/adminer`) and is renamed to _adminer.php_.

Start up a terminal and change directory to the folder containing Adminer. In my case, it's `~/dev/adminer`. Now run PHP's development server on a port of your choice.

    ~/dev/adminer$ php -S localhost:8080
    PHP 7.2.15-0ubuntu0.18.04.1 Development Server started at Mon Mar  4 04:41:07 2019
    Listening on http://localhost:8080
    Document root is /home/nicholas/dev/adminer
    Press Ctrl-C to quit.

Visit localhost on your browser (_localhost:8080/adminer.php_). You should be greeted by the screen below.

![](/images/admnr/adminer-login.jpg)

Now login to your DB. Mine is MySQL.

![](/images/admnr/mysql-dbs.jpg)

__NB:__ Ensure your DB server is running. If you get an error like "None of the supported PHP extensions (MySQLi, MySQL, PDO_MySQL) are available" when trying to login, it means you didn't install and/or configure the DB extension for PHP properly.

### Extend Adminer with plugins
If you need more features on Adminer, you can use plugins. There are [a ton of plugins already available](https://www.adminer.org/en/plugins/) and you can create yours if you want.

Let's install one of the  plugins: _edit-textarea_. It uses `<textarea>` for _char_ and _varchar_
fields instead of the regular text input.

![](/images/admnr/text-input.png)
_char and varchar fields are edited in a text input by default_

- Create a plugins directory in your _adminer_ directory (e.g `~/dev/adminer/plugins`) and [add this _plugin.php_ file](https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php) in it. _plugin.php_ is required to use plugins with Adminer.

- Create an _index.php_ file in your _adminer_ directory (i.e `~/dev/adminer`) and add the following code.

        <?php
        function adminer_object() {
            // required to run any plugin
            include_once "./plugins/plugin.php";
            
            // autoloader
            foreach (glob("plugins/*.php") as $filename) {
                include_once "./$filename";
            }
            
            $plugins = array(
                // specify enabled plugins here
            );
            
            /* It is possible to combine customization and plugins:
            class AdminerCustomization extends AdminerPlugin {
            }
            return new AdminerCustomization($plugins);
            */
            
            return new AdminerPlugin($plugins);
        }

        // include original Adminer or Adminer Editor
        include "./adminer.php";
        ?>

- Add [the _edit-textarea_ plugin source file (_edit-textarea.php_)](https://raw.githubusercontent.com/vrana/adminer/master/plugins/edit-textarea.php) to your plugins directory.

- Initialize the plugin in _index.php_ by adding `new AdminerEditTextarea()` in the `$plugins` array.

        $plugins = array(
            // specify enabled plugins here
            new AdminerEditTextarea(),
        );

- Visit _localhost:8080_ (NOT _localhost:8080/adminer.php_) in your browser, login and check it out!

![](/images/admnr/textarea.png)
_Now you can edit using a text area_

__NB:__ To add a another plugin, all you need to do now is place the plugin source file in the _plugins_ directory and initialize it with the `new` keyword in the `$plugins` array (in _index.php_) e.g `new SomeAwesomePlugin()`.