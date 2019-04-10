import system, os, ospaths, osproc, strformat, json
import templates
import strutils
import xmltree
import htmlparser
import libcurl
import header

type PostMeta* = tuple[header, description: string]

proc generateBlogPostsPage* (names : seq[(string, string, PostMeta)] = @[]) : string = tmpli html"""
  <html>
    <head>
      <title> Sky Vault </title>
      <link rel="stylesheet" type="text/css" href="css/main.css">
      <link rel="stylesheet" type="text/css" href="css/blogPosts.css">
    </head>
    <body>
        $(generateHeader("Dustin's Blog"))

        <div id="blog-posts-container">
          $for post in names {
            <div class="blog-post-entry">
              <h4> $post[2][0] </h3>
              <p> $post[2][1] </p>
            </div>
          }
        </div> 
    <body>
  </html>
  """

