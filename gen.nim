import system, os, ospaths, osproc, strformat, json
import templates
import strutils
import xmltree
import htmlparser
import libcurl

const Projects = [
  ("Coral", "https://github.com/SkyVault/Coral", """
  Coral is a simple, easy to use 2d game framework for the Nim programming language. Warning: Coral is under heavy development.
  """),

  ("SkyVault", "https://github.com/SkyVault/SkyVault", """
    SkyVault is a 2d game developed in c++
  """),

  ("NimTiled", "https://github.com/SkyVault/nim-tiled", """
  Tiled map loader for the nim programming language
  """)
]

proc postPage(contents : string, headers : seq[string]) : string

# Get list of posts
var entries = newSeq[string]()
var posts = newSeq[(string, string)]()

for kind, entry in walkDir(getCurrentDir() & "/entries"):
  case kind:
  of pcFile:
    let (dir, name, ext) = splitFile(entry)
    if ext == ".md":
      entries.add entry
      let outPath = getCurrentDir() & "/output/" & name & ".html"
      posts.add (name, outPath)

      discard execShellCmd(&"pandoc {entry} -s --highlight-style zenburn -o {outPath}")

      # Process the file
      let contents = readFile(outPath)

      let html = parseHtml contents
      var headers = newSeq[string]()
      for h2 in html.findAll("h2"):
        headers.add h2.innerText()

      writeFile((string)outPath, postPage(contents, headers))

  else: discard

proc postPage(contents : string, headers : seq[string]) : string=
  proc postPageTmpl(contents : string) : string = tmpli html"""
    <html>
      <head>
        <title> Bla </title>
        <link rel="stylesheet" type="text/css" href="../css/main.css">
        <link rel="stylesheet" type="text/css" href="../css/blogEntry.css">
      </head>

      <body id="PostPage">

        <!-- Side navigation -->
        <div class="sidenav">
          <a class="backbutton" href="../index.html"> < </a>

          $for h in headers {
            <a href="#">$h</a>
          }
        </div>

        <div id="PostPageContents">
          $contents
          <a href="../index.html"> Back </a>
        </div>
      </body>
    </html>
    """

  return postPageTmpl contents

proc blogPostCard(name : string, url = "") : string = tmpli html"""
  <div class="ProjectCard">
    <div class="InnerProjectCard">
      <h4 class="CardHeader"> $name </h4>
      <a href="$url"> View </a>
    </div>
  </div>
  """

proc projectCard(name : string, url = "", desc = "") : string = tmpli html"""
  <div class="ProjectCard">
    <div class="InnerProjectCard">
      <h4 class="CardHeader"> $name </h4>
      <h5> $desc </h5>
      <a href="$url" target="_blank"> View </a>
    </div>
  </div>
  """

proc index(names : seq[(string, string)] = @[]) : string = tmpli html"""
  <html>
    <head>
      <title> Sky Vault </title>
      <link rel="stylesheet" type="text/css" href="css/main.css">
    </head>
    <body>
      <div id="Header">
        <h1> Sky Vault </h1>
      </div>

      <div>
        <div id="NotableProjects">
          <h3> Notable projects </h3>
          
          <div id="Projects">
            $for p in Projects {
              $(projectCard(p[0], p[1], p[2]))
            }
          </div>
        </div>

        <div id="RecentBlogEntries">
          <h3> Recent Blog Entries </h3>

          <div id="Projects">
            $for e in names {
              $(blogPostCard(e[0], e[1]))
            }
          </div>
        </div>
      </div>
    <body>
  </html>
  """

writeFile("index.html", index posts)
