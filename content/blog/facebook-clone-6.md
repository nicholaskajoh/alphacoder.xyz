---
title: "Build a Facebook clone from scratch with PHP — Part 6"
slug: "facebook-clone-6"
date: 2017-09-23T09:07:23+01:00
draft: false
tag: ["Facebook Clone Series"]
---

# All parts
- [Build a Facebook clone from scratch with PHP — Part 1](/facebook-clone-1)
- [Build a Facebook clone from scratch with PHP — Part 2](/facebook-clone-2)
- [Build a Facebook clone from scratch with PHP — Part 3](/facebook-clone-3)
- [Build a Facebook clone from scratch with PHP — Part 4](/facebook-clone-4)
- [Build a Facebook clone from scratch with PHP — Part 5](/facebook-clone-5)
- Build a Facebook clone from scratch with PHP — Part 6 (this article)
- [Build a Facebook clone from scratch with PHP — Part 7](/facebook-clone-7)

Relationships are the point of social networks. For real! Social networks like Facebook enable us connect with different people far and near and to share in their life and experiences. Facebook uses the "friend" model of relationships (I'm your friend; you're my friend). There are other models like the popular "following-follower" model. Implementing relationships can easily get complex. We want to keep things simple though so we'll explore a very basic approach. Also, we won't be exploiting the relationship model we'll be creating in the workings of our application. Again, it's to keep things simple.

# Friend relationships
_I'm your friend and you're my friend_. That's the idea for the friend relationship model. It starts by making a friend request. The user at the receiving end may choose to accept or decline the request. If they accept, the user who made the request is added to their friends' list and vice versa [or so] thus a relationship exists between the two of them. If a request is declined, nothing happens, basically.

Without further ado, let's implement something of that sort for FaceClone.

# List users
We want to provide a list of FaceClone users to a user so that they can add any of them as friends. The right sidebar of the home.php template has an "add friend" panel. Let's use it. All we need do is list out all our users.

In the "add friend" section, we'll have…

    <h4>add friend</h4>
    <?php
        $sql = "SELECT id, username, (SELECT COUNT(*) FROM friends WHERE friends.user_id = users.id AND friends.friend_id = {$_SESSION['user_id']}) AS is_friend FROM users WHERE id != {$_SESSION['user_id']} HAVING is_friend = 0";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            ?><ul><?php
        
            while($fc_user = $result->fetch_assoc()) {
                ?><li>
                    <a href="profile.php?username=<?php echo $fc_user['username']; ?>">
                        <?php echo $fc_user['username']; ?>
                    </a> 
                    <a href="php/add-friend.php?uid=<?php echo $fc_user['id']; ?>">[add]</a>
                </li><?php
            }
        
            ?></ul><?php
        } else {
            ?><p class="text-center">No users to add!</p><?php
        }
    ?>

Now that's some code! Let's break it down bit by bit. We want to list FaceClone users. That's the goal. So why do we have a long and "complex" SQL query? Can't we just use `SELECT * FROM users`? We can. But it's not that simple. There are 2 constraints we need to set. First, users that are already friends with the current user (who is looking to get new friends) shouldn't be displayed on the list. That makes sense right? Secondly, the current user shouldn't be on the list. You shouldn't be able to friend yourself, should you? There are other constraints that can be added to make things more fluid as well as "waterproof", but considering them would just make things more complicated so we'll just leave things as they are.

To achieve the first constraint, we added a column to the users table results called `is_friend`.

    (SELECT COUNT(*) FROM friends WHERE friends.user_id = users.id AND friends.friend_id = {$_SESSION['user_id']}) AS is_friend

This column would contain a 0 or 1 for each user record. 0 means not a friend of the current user while 1 means [already] a friend. Using the `HAVING` keyword, we exclude records with `is_friend` value of 1. That is...

    HAVING is_friend = 0

The second constraint is achieved using the `WHERE` clause to exclude the current user from the list thus:

    WHERE id != {$_SESSION['user_id']}

# Send a friend request
In the users list, there's an add friend link beside each username.

    <a href="php/add-friend.php?uid=<?php echo $fc_user['id']; ?>">[add]</a>

The links lead to a GET endpoint `php/add-friend.php?uid=`. Go ahead, as always and create a file in the php folder called add-friend.php with the following code...

    <?php
        require_once "../functions.php";
        db_connect();
        $sql = "INSERT INTO friend_requests (user_id, friend_id) VALUES (?, ?)";
        $statement = $conn->prepare($sql);
        $statement->bind_param('ii', $_SESSION['user_id'], $_GET['uid']);
        if ($statement->execute()) {
            redirect_to("/home.php?request_sent=true");
        } else {
            echo "Error: " . $conn->error;
        }

With a supplied user id in the GET request, we can create a new friend request. The user to whom the request is being made is the friend so their id is stored in `friend_id`.

# Accept/decline friend requests
The user who is requested should be able to see who requested them and choose whether to accept or decline. The left sidebar in home.php provides such a facility. With a little padding, we could arrive at something like this:

    <h4>friend requests</h4>
    <?php
        $sql = "SELECT * FROM friend_requests WHERE friend_id = {$_SESSION['user_id']}";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            ?><ul><?php

            while($f_request = $result->fetch_assoc()) {
                ?><li><?php
                    
                $u_sql = "SELECT * FROM users WHERE id = {$f_request['user_id']} LIMIT 1";
                $u_result = $conn->query($u_sql);
                $fr_user = $u_result->fetch_assoc();
                
                ?><a href="profile.php?username=<?php echo $fr_user['username']; ?>">
                    <?php echo $fr_user['username']; ?>
                </a> 
                    
                <a class="text-success" href="php/accept-request.php?uid=<?php echo $fr_user['id']; ?>">
                    [accept]
                </a> 
                    
                <a class="text-danger" href="php/remove-request.php?uid=<?php echo $fr_user['id']; ?>">
                    [decline]
                </a>

                </li><?php
            }

            ?></ul><?php
        } else {
            ?><p class="text-center">No friend requests!</p><?php
        }
    ?>

In the snippet above, there are two sets of queries. The first pulls out all the friend requests to the current user. The second fetches data (of the requesting user) for each friend request.

There are two links beside each user's username. One to accept and the other to decline. They both lead to different end points. The former to `php/accept-request.php?uid=` and the latter to `php/remove-request.php?uid=`.

Remove request:

    <?php
        require_once "../functions.php";
        db_connect();
        $sql = "DELETE FROM friend_requests WHERE user_id = ?";
        $statement = $conn->prepare($sql);
        $statement->bind_param('i', $_GET['uid']);
        if ($statement->execute()) {
            redirect_to("/profile.php?username=" . $_SESSION['user_username']);
        } else {
            echo "Error: " . $conn->error;
        }

Accept request:

    <?php
        require_once "../functions.php";
        db_connect();
        // add users to friends table
        $statement = $conn->prepare("INSERT INTO friends (user_id, friend_id) VALUES (?, ?), (?, ?)");
        $statement->bind_param('iiii', $_SESSION['user_id'], $_GET['uid'], $_GET['uid'], $_SESSION['user_id']);
        // remove friend request
        if ($statement->execute()) {
            redirect_to("/php/remove-request.php?uid=" . $_GET['uid']);
        } else {
            echo "Error: " . $conn->error;
        }

Friendship is two-sided. I am your and you are my friend. As such, in accept-request.php we insert two records. In one, the current user is the friend and in the other the requesting user is the friend. While it seems like unnecessary duplication, it proves easier to manage. Also notice we use remove-request.php in accept-request.php to delete a friend request once two users have been added as friends.

# Unfriend user
Unfriending is as simple as removing the records in the friends table that connects two users.

    <?php
        require_once "../functions.php";
        db_connect();
        $sql = "DELETE FROM friends WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)";
        $statement = $conn->prepare($sql);
        $statement->bind_param('iiii', $_GET['uid'], $_SESSION['user_id'], $_SESSION['user_id'], $_GET['uid']);
        if ($statement->execute()) {
            redirect_to("/profile.php?username=" . $_SESSION['user_username']);
        } else {
            echo "Error: " . $conn->error;
        }

Viola! We've built friend relationships into FaceClone!

Again, we're not exploiting the relationships we just created, to keep things simple. But it's pretty straightforward to do so. For example, instead of displaying all FaceClone posts on a user's feed, we could display only posts from their friends. We could also make some of a user's profile information only available to their friends. If we had a chat feature, we could allow only friends chat with each other. As a social network grows, this would make more sense. So if you're working on your social network app after this series (I totally encourage it), keep in mind what the relationships you create would imply.

_At this point, I must say we are done; at least at the most basic level. So congrats for following through!!! Building a social networking app, especially one like Facebook, is a never-ending journey. There's always something to add to make it easier, faster and/or better to use._

We'll be deploying the FaceClone web app online for anyone to use in the next and last part of this series. Be sure to read it!

__The final code for this part is contained in my [FaceClone repo](https://github.com/nicholaskajoh/faceclone). Visit the link and click on the part-6 folder to see progress made so far.__

Next: [Build a Facebook clone from scratch with PHP — Part 7](/facebook-clone-7).

Previous: [Build a Facebook clone from scratch with PHP — Part 5](/facebook-clone-5).