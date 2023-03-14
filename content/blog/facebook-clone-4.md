---
title: "Build a Facebook clone from scratch with PHP — Part 4"
slug: "facebook-clone-4"
date: 2017-09-14T09:07:14+01:00
draft: false
tags: ["Facebook Clone Series", "Web Development"]
---

# All parts
- [Build a Facebook clone from scratch with PHP — Part 1](/facebook-clone-1)
- [Build a Facebook clone from scratch with PHP — Part 2](/facebook-clone-2)
- [Build a Facebook clone from scratch with PHP — Part 3](/facebook-clone-3)
- Build a Facebook clone from scratch with PHP — Part 4 (this article)
- [Build a Facebook clone from scratch with PHP — Part 5](/facebook-clone-5)
- [Build a Facebook clone from scratch with PHP — Part 6](/facebook-clone-6)
- [Build a Facebook clone from scratch with PHP — Part 7](/facebook-clone-7)

Users are at the center of any application. It's all about the user, right? Unlike other types of web apps (e.g blogs), our users must be identifiable. They can't be anonymous. They need to have accounts on our platform. And to get accounts, they have to register. After registration, they must login to their accounts. In this part, we're going to make all this possible, and some.

# Registration
We already have a registration form in our index.php template.

    ...
    <form method="post" action="php/register.php">
        <div class="form-group">
            <input class="form-control" type="text" name="username" placeholder="Username" required>
        </div>
        <div class="form-group">
            <input class="form-control" type="text" name="location" placeholder="Location">
        </div>
        <div class="form-group">
            <input class="form-control" type="password" name="password" placeholder="Password" required>
        </div>
        <div class="form-group">
            <input class="btn btn-success" type="submit" name="register" value="Register">
        </div>
    </form>
    ...

When a user fills the registration form and submits, all we need to do is feed our database with the information.

Create a file called register.php in the php folder. This is where we would process registration submissions.

    <?php
        require_once "../functions.php";
        db_connect();
        $sql = "INSERT INTO users (username, password, location) VALUES (?, ?, ?)";
        $statement = $conn->prepare($sql);
        $statement->bind_param('sss', $_POST['username'], password_hash($_POST['password'], PASSWORD_DEFAULT), $_POST['location']);
        if ($statement->execute()) {
            redirect_to("/index.php?registered=true");
        } else {
            echo "Error: " . $conn->error;
        }

Like always, the code is easy to understand. After we call `db_connect()` to help us establish a connection to the database, we build an SQL query, an insert query that, well, inserts (or creates) data in our DB.

If you've noticed, we've been using "prepared statements" to perform some SQL queries. There are couple other ways to perform operations [using PHP] on our DB (e.g the way we used to pull up post records in part 3). Prepared statements are however preferred/safer for operations that change/manipulate data because, BAD PEOPLE (the black hats) can attempt to mess us up using SQL Injection. There's no time to talk about SQL Injection here but hey, Google is your friend. Anyways, let's move on.

Another security concern is with passwords. It is bad practice to store "raw" passwords because if someone gets access to your DB, they can screw you and your users over. It's safer to "hash" passwords. Hashing algorithms perform one-way transformations, turning one string to another string called a hash. There are a good number of hashing algorithms you can use for passwords e.g md5, sha1, bcrypt etc. Lucky for us, we don't have to worry about these algorithms. PHP provides a hashing function we can use:

    password_hash('secret123', PASSWORD_DEFAULT);

Password hashes are usually a long string of "random" characters like this:

    $2y$10$aClhvyCsqbPgx.SE7L43z.oZhBPNhqg3lOMJWPMC1KUT9UIeiR.Vi

Once the insert is done, we redirect the user to same index.php with some GET data.

    example.com/index.php?registered=true

This data tells us the user has been registered, so we can alert the user as well and urge them to login. Somewhere atop index.php, we can have:

    ...
    <?php if(isset($_GET['registered'])): ?>
    <div class="alert alert-success">
        <p>Account created successfully! Use your username and password to login.</p>
    </div>
    <?php endif; ?>
    ...

# Login
Login is also straightforward. What we want to achieve is to create a way to identify users as they go from page to page in our application. We want to be able to know if the person [currently] using our app is "logged in", but more importantly, who they are if they are logged in.

There are two things involved:

1. __Authentication__ - which asks "Who are you?" and "Are you really who you say you are?". The former is asked through a login form where the user provides their username and password, while the latter is asked when the application checks to see if the credentials submitted match any existing records.

2. __Authorization__ - If a user is who they say they are, then we can give them access to resources (e.g pages) unavailable to people not registered to our app. We have to do some kind of check to see if a request coming to our server is from a "legit" user and then authorize/allow access to the page they requested.

We use _sessions_ to authorize requests. Like the name implies, a session grants access to an application's resources for a period. For instance, after being authenticated by security at, say, a library (probably with a student or National ID), you can do whatever you like (read books, watch educational material, browse the internet etc) until you leave/the library is closed for the day. When you visit next time, you must be authenticated again. But while you're in the library, nobody asks you to identify yourself before picking up a book or watching some educational video. It is believed that you have been "authenticated", so to speak.

PHP provides us a superglobal called `$_SESSION` - an array which contains session variables. The variables we store in `$_SESSION` persist until the browser is closed. I don't want to go into exactly how sessions work. Again, Google is your friend, so google.

Here's a snippet of the login form:

    ...
    <form method="post" action="php/login.php">
    <div class="form-group">
        <input class="form-control" type="text" name="username" placeholder="Username" required>
    </div>
    <div class="form-group">
        <input class="form-control" type="password" name="password" placeholder="Password" required>
    </div>
    <div class="form-group">
        <input class="btn btn-primary" type="submit" name="login" value="Login">
    </div>
    </form>
    ...

Create a file login.php in the php folder and add the following bit of code:

    <?php
        require_once "../functions.php";
        db_connect();
        $sql = "SELECT id, username, password FROM users WHERE username = ?";
        $statement = $conn->prepare($sql);
        $statement->bind_param('s', $_POST['username']);
        $statement->execute();
        $statement->store_result();
        $statement->bind_result($id, $username, $password);
        $statement->fetch();
        if ($statement->execute()) {
            if(password_verify($_POST['password'], $password)) {
            $_SESSION['user_id'] = $id;
            $_SESSION['user_username'] = $username;
            redirect_to("/home.php");
            } else {
            redirect_to("/index.php?login_error=true");
            }
        } else {
            echo "Error: " . $conn->error;
        }

As with the the code for registration, login.php is easy to digest. We establish a connection with our dear DB, then write a query to fetch a user with the supplied username. Next, we get the hashed password of the fetched user record and compare it to the password provided by the user to see if they match. PHP provides another slick function to do this called, as you could guess, `password_verify()`. Once our user has been verified to have provided the correct details, we create 2 sessions. One to store the user's id and the other the user's username. Then we redirect them to home.php.

With the sessions in place, we can check any request coming to our server to know if it's from an authenticated user or not, and who the user is if they're authenticated. This is vital for our app cos we don't want unregistered persons to access pages like home.php as well as to take actions like creating a post or making a friend request. Also, we want to be able to know [the user] who takes a given action. These sessions help us achieve just that.

But how?

For starters, let's a write function that allows only authenticated users to access the home page. The unauthenticated are redirected to index.php.

    function is_auth() {
        return isset($_SESSION['user_id']);
    }

    function check_auth() {
        if(!is_auth()) {
            redirect_to("/index.php?logged_in=false");
        }
    }

There are two functions defined above. The first `is_auth()` is a helper function for `check_auth()`. It checks if a user has been authenticated using the `user_id` session. `check_auth()` is the main function here. It uses `is_auth()` to check if a request is not authenticated and then redirects to index.php.

Now you can place `check_auth()` atop all the pages you want restricted.

__NB:__ You need to place the function `session_start()` at the beginning of every page where sessions would be used, for them to work. functions.php is a nice place to put this function cos it's required at the start of all our pages.

    <?php
        session_start();
        function db_connect() {
            ...
        }
        ...

# Logout
Logout is freakishly easy. All we have to do is destroy the session, and PHP provides us a function to do just that.

Create a new file in the php folder called logout.php with the following code:

    <?php
        require_once "../functions.php";
        // destroy all sessions
        session_destroy();
        redirect_to("/index.php");

That's all! Hopefully, there's nothing to explain here. Right?

Great!

Just create a logout link like so: `<a href="php/logout.php">Logout</a>` and you're good.

At this point, we can call it a day. Phew!!!

Well done!

__The final code for this part is contained in my FaceClone repo here: https://github.com/nicholaskajoh/faceclone. Visit the link and click on the part-4 folder to see progress made so far.__

Next: [Build a Facebook clone from scratch with PHP — Part 5](/facebook-clone-5).

Previous: [Build a Facebook clone from scratch with PHP — Part 3](/facebook-clone-3).