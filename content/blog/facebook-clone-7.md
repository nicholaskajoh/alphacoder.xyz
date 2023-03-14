---
title: "Build a Facebook clone from scratch with PHP — Part 7"
slug: "facebook-clone-7"
date: 2017-12-09T09:07:25+01:00
draft: false
tags: ["Facebook Clone Series", "Web Development"]
---

# All parts
- [Build a Facebook clone from scratch with PHP — Part 1](/facebook-clone-1)
- [Build a Facebook clone from scratch with PHP — Part 2](/facebook-clone-2)
- [Build a Facebook clone from scratch with PHP — Part 3](/facebook-clone-3)
- [Build a Facebook clone from scratch with PHP — Part 4](/facebook-clone-4)
- [Build a Facebook clone from scratch with PHP — Part 5](/facebook-clone-5)
- [Build a Facebook clone from scratch with PHP — Part 6](/facebook-clone-6)
- Build a Facebook clone from scratch with PHP — Part 7 (this article)

It's time to deploy FaceClone and invite friends to test it out!

# Hosting
The FaceClone app has been running on our local computers all the while. For it to be accessible by anyone and everyone, it needs to run online. In other words, we need to host it. There are many hosting services out there. For this tutorial, we'll be using [000webhost](https://www.000webhost.com). 000webhost is free and offers an easy-to-use interface. Feel free to try out other web hosting services afterwards.

# Domain name
Every website needs an address from which to access it. 000webhost provides us with a domain name out of the box: APP_NAME.000webhost.com. This would suffice, for now. If you want a more professional domain name like facecloneapp.com or thefaceclone.co.uk, you'll have to purchase it from a domain name registrar and "point it" to your web host's servers. But that's beyond the scope of this tutorial so we'll pass. Most domain registrars provide elaborate tutorials on how to setup domains with web hosts so it's really no biggie.

# 000webhost
Visit https://www.000webhost.com and sign up for an account. You may need to verify your account by email.

Login and create a new website using the dialog as shown below:

![](/images/fbc7/000webhost-new-site.png)
*Create a new website on 000webhost*

__NB:__ Note the password you set. We'll use it in a bit.

Say you named your site faceclone-app, you can check it out using the address faceclone-app.000webhost.com.

![](/images/fbc7/new-site-page.png)
*000webhost's new website page*

# FTP
Remember FileZilla from Part 1? We'll be using FileZilla, a File Transfer Protocol (FTP) app to upload FaceClone to 000webhost.

First go to settings on 000webhost. Make sure FTP transfer is set to on. Also take note of the FTP host name and username.

![](/images/fbc7/enable-ftp.png)

Now start FileZilla.

Slot in hostname, username and password (the password for your 000webhost site) in the fields a top the screen and click _Quick connect_.

![](/images/fbc7/connect-with-ftp.png)

The left part of FileZilla represents your local computer while the right side represents the remote computer (000webhost's server). If you're able to connect successfully, the file system of your site's server would open up on the right side.

__NB:__ You must be connected to the internet for this to work.

Navigate your computer's file system to the folder where the FaceClone source code is located. Select all the files and folders there and copy them to your website's server's public_html folder.

Once the copying is done, try refreshing your 000webhost website page e.g _faceclone-app.000webhost.com_. You should see something similar to this:

![](/images/fbc7/faceclone-db-error.png)

Everything seems to work f... The DB's not working. That's a problem! 😑

# DB setup
We need to setup a database on 000webhost to store FaceClone data. Our website's database server rejected the database parameters we have in the source code i.e _root_ as username with no password. That configuration was for the local database server. We need to change the parameters.

To create a database on 000webhost, navigate to the _Manage database_ tab and click on _New Database_. You need to set a database name, user and password.

![](/images/fbc7/new-db.png)

Note that a prefix was added to the database name and user. We'll be using these values (including the db password you set) to configure the FaceClone app.

![](/images/fbc7/manage-dbs.png)

Navigate to the File manager tab and click Upload files now. You'll be redirected to https://files.000webhost.com where you should see all the files uploaded via FTP.

![](/images/fbc7/000webhost-files.png)

Right click on functions.php and click edit.

![](/images/fbc7/edit-functions.php.png)

Change the database params as appropriate, save and close.

![](/images/fbc7/update-db-params.jpg)
*Change the params in functions.php*

Now try refreshing your app's url...

![](/images/fbc7/faceclone-index-page.png)
*Hurray! It works!!!*

# Import schema
We're not done yet. We need to import the database schema in the new database we created on 000webhost. The schema can be found [here](https://github.com/nicholaskajoh/faceclone-site/blob/master/faceclone.sql).

Navigate to the _Manage database_ tab, click on the _Manage_ dropdown for your FaceClone database then select PhpMyAdmin.

Use your database user and password for PhpMyAdmin.

![](/images/fbc7/phpmyadmin-login.png)
*PhpMyAdmin login*

![](/images/fbc7/phpmyadmin-home.png)
*PhpMyAdmin home*

Select your FaceClone database from the sidebar and click on the import tab.

![](/images/fbc7/phpmyadmin-import.png)

Select the schema from your computer and click go...

![](/images/fbc7/phpmyadmin-import2.png)
*Perfecto!*

Test out the whole app to ensure there are no breaking errors lurking around... 😏

![](/images/fbc7/faceclone-signup-success.png)

![](/images/fbc7/faceclone-home.png)

Remember to change _Show errors_ in the settings to __Off__ when you're done testing the app.

Awesome!

__P.S.__ You can share links to your FaceClone app in the comments.

# Next steps
The repo for the version of FaceClone running on 000webhost can be found here: https://github.com/nicholaskajoh/faceclone-site.

It's open to everyone for bug fixes and new features. If you have any ideas and want to code, head over there and contribute to the project.

---

A big thanks to you if you followed through to this point! 🎉🎉🎉

I wish you success in your software development endeavours. Keep building!!!