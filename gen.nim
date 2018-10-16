import system, os, ospaths, osproc, strformat, json
import templates
import strutils

import libcurl

proc projectCard(name : string, url = "", desc = "") : string = tmpli html"""
  <div class="ProjectCard">
    <h4> $name </h4>
    <h5> $desc </h5>
    <a href="$url" target="_blank"> View </a>
  </div>
  """

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

proc index(names : seq[string] = @[]) : string = tmpli html"""
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

          <ul>
            $for e in names {
              <li> $e </li>
            }
          </ul>
          <button> View all </button>
        </div>
      </div>
    <body>
  </html>
  """

# Get list of posts

var entries = newSeq[string]()
var names = newSeq[string]()

for kind, entry in walkDir(getCurrentDir() & "/entries"):
  case kind:
  of pcFile:
    let (dir, name, ext) = splitFile(entry)
    if ext == ".md":
      entries.add entry
      names.add name
      discard execShellCmd(&"pandoc {entry} -o {getCurrentDir() & \"/output/\" & name & \".html\"}")
  else: discard

writeFile("index.html", index names)
