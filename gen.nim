import system, os, ospaths, osproc, strformat, json
import templates
import strutils
import xmltree
import htmlparser
import libcurl

const Projects = [
  ("Coral", "https://github.com/SkyVault/Coral", """
  Coral is a simple, easy to use 2d game framework for the Nim programming language. Warning: Coral is under heavy development.
  """,
  "resources/CoralLogo.png"),

  ("SkyVault", "https://github.com/SkyVault/SkyVault", """
    SkyVault is a 2d game developed in c++
  """,
  "resources/SkyVaultLogo.PNG"),

  ("NimTiled", "https://github.com/SkyVault/nim-tiled", """
  Tiled map loader for the nim programming language
  """,
  "resources/NimTiledLogo.png")
]

proc postPage(contents : string, headers : seq[string]) : string

# Get list of posts
var entries = newSeq[string]()

# name, outpath
type PostMeta = tuple[header, description: string]
var posts = newSeq[(string, string, PostMeta)]()

for kind, entry in walkDir(getCurrentDir() & "/entries"):
  case kind:
  of pcFile:
    let (dir, name, ext) = splitFile(entry)
    if ext == ".md":
      entries.add entry
      let outPath = getCurrentDir() & "/output/" & name & ".html"

      discard execShellCmd(&"pandoc {entry} -s --highlight-style zenburn -o {outPath}")

      # Process the file
      let contents = readFile(outPath)

      let html = parseHtml contents

      var headers = newSeq[string]()
      var description = ""

      for h2 in html.findAll("h2"):
        headers.add h2.innerText()
      
      # Get the description, should be the first paragraph
      for p in html.findAll "p":
        description = p.innerText()
        break

      if posts.len < 3:
        posts.add (name, &"output/{name}.html", (header: headers[headers.len-1], description: description))

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

proc blogPostCard(name : string, meta : PostMeta, url = "") : string = tmpli html"""
  <div class="ProjectCard">
    <div class="InnerProjectCard">
      <h4 class="CardHeader"> $name </h4>
      <p> $(meta.description) </p>
      <a href="$url"> View </a>
    </div>
  </div>
  """

proc projectCard(name : string, url = "", desc = "", img="") : string = tmpli html"""
  <div class="Card">
    
    <img src="$img" alt="$name">
    <h4> <b> $name </b> </h4>

    <div class="CardContainer">
      <p> $desc </p>
    </div>
  </div>
  """

proc index(names : seq[(string, string, PostMeta)] = @[]) : string = tmpli html"""
  <html>
    <head>
      <title> Sky Vault </title>
      <link rel="stylesheet" type="text/css" href="css/main.css">
    </head>
    <body>
      <div id="Header">
        <h1> Sky Vault </h1>
      </div>

      <div id="Navbar">
        <ul>
          <li><a href="https://www.youtube.com/channel/UCSs-Hz8pP4PcKRQCdHuAxAg?view_as=subscriber">Youtube</a></li>
          <li><a href="https://github.com/SkyVault?tab=repositories">Github</a></li>
          <li><a href="#">Resume</a></li>
          <li><a href="#">Blog</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </div>

      <div id="Welcome"> 
      </div>

      <div>

        <h3 style="text-align: center; width: 100%;"> Notable projects </h3>
        
        <div id="ProjectCards">
          $for p in Projects {
            $(projectCard(p[0], p[1], p[2], p[3]))
          }
        </div> 
      </div>
    <body>
  </html>
  """

writeFile("index.html", index posts)
