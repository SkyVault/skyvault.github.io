import system, os
import templates

proc index() : string = tmpli html"""
  <html>
    <head>
      <title> Sky Vault </title>
      <link rel="stylesheet" type="text/css" href="css/main.css">
    </head>
    <body>
      <div id="Header">
        <h1> Sky Vault </h1>
      </div>
    <body>
  </html>
  """

writeFile("index.html", index())
