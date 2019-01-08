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
    </head>
    <body>
        $(generateHeader("SkyVault Blog"))
    <body>
  </html>
  """

