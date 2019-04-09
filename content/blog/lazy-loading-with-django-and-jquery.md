+++
author = "Nicholas Kajoh"
date = 2017-02-26T05:43:00.000Z
draft = false
image = "/content/images/2019/01/holger-link-636245-unsplash-sm.jpg"
slug = "lazy-loading-with-django-and-jquery"
tag = ["Django","jQuery"]
title = "Lazy load your content with Django and jQuery"

+++


Outlined in this tutorial is a simple way to lazy load content using Django’s built-in pagination and the jQuery library. The code samples shown below are for paginating posts in a blog application.

Templates
---------

Create 2 templates, _index.html_ and _posts.html_.

_index.html_

    <html>
      <head>
        <script type="text/javascript">
          // A CSRF token is required when making post requests in Django
          // To be used for making AJAX requests in script.js
          window.CSRF_TOKEN = "{{ csrf_token }}";
        </script>
      </head>
      <body>
        <h2>My Blog Posts</h2>
        <div id="posts">{% include 'myapp/posts.html' %}</div>
        <div>
          <a id="lazyLoadLink" 
             href="javascript:void(0);" 
             data-page="2">Load More Posts</a>
        </div>
      </body>
    </html>
    

_posts.html_

    {% for post in posts %}
    <div>
      <h4>{{ post.title }}</h4>
      <p>{{ post.content }}</p>
    </div>
    {% endfor %}
    

Urls, Views, Model
------------------

Create/update _urls.py_ and _views.py_ as follows.

_urls.py_

    from myapp import views
    
    urlpatterns = [
        url(r'^$', views.index, name='index'),
        url(r'^lazy_load_posts/$', views.lazy_load_posts, name='lazy_load_posts'),
    ]
    

_views.py_

    from django.shortcuts import render
    from myapp.models import Post
    from django.template import loader
    from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
    from django.http import JsonResponse
    
    def index(request):
        posts = Post.objects.all()[:5]
        return render(request, 'myapp/index.html', {'posts': posts})
    
    def lazy_load_posts(request):
        page = request.POST.get('page')
        posts = Post.objects.all()
        # use Django's pagination
        # https://docs.djangoproject.com/en/dev/topics/pagination/
        results_per_page = 5
        paginator = Paginator(posts, results_per_page)
        try:
            posts = paginator.page(page)
        except PageNotAnInteger:
            posts = paginator.page(2)
        except EmptyPage:
            posts = paginator.page(paginator.num_pages)
        # build a html posts list with the paginated posts
        posts_html = loader.render_to_string(
            'myapp/posts.html',
            {'posts': posts}
        )
        # package output data and return it as a JSON object
        output_data = {
            'posts_html': posts_html,
            'has_next': posts.has_next()
        }
        return JsonResponse(output_data)
    

Create a post model.

_models.py_

    from __future__ import unicode_literals
    from django.db import models
    
    class Post(models.Model):
        title = models.CharField()
        content = models.TextField()
    

The `index` function in _views.py_ renders the _index.html_ page. It retrieves and sends a list of post objects (the first page) to the template. The `lazy_load_posts` function is called when the “Load More Posts” link is clicked. It retrieves the next page of posts using the `Paginator` class and generates a html string using the _posts.html_ template.

The paginator object provides a _has\_next_ method which checks if there’s another page to load. If there is, the page `data-` attribute of the anchor tag in _index.html_ is incremented by 1 so that when “Load More Posts” is clicked again, it loads the next page.

_script.js_

    (function($) {
      $('#lazyLoadLink').on('click', function() {
        var link = $(this);
        var page = link.data('page');
        $.ajax({
          type: 'post',
          url: '/lazy_load_posts/',
          data: {
            'page': page,
            'csrfmiddlewaretoken': window.CSRF_TOKEN // from index.html
          },
          success: function(data) {
            // if there are still more pages to load,
            // add 1 to the "Load More Posts" link's page data attribute
            // else hide the link
            if (data.has_next) {
                link.data('page', page+1);
            } else {
              link.hide();
            }
            // append html to the posts div
            $('#div').append(data.posts_html);
          },
          error: function(xhr, status, error) {
            // shit happens friends!
          }
        });
      });
    }(jQuery));
    

The snippet above listens for click events on the “Load More Posts” link and sends AJAX requests to the `lazy_load_posts` view. If a request is successful, the returned data is appended to the posts `div` (`id="posts"`).

All the code snippets in this tutorial can be found on [this Github Gist](https://gist.github.com/nicholaskajoh/ae85bb836f2a6254244c847b962095d4).