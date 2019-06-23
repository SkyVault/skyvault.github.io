import system, os
import templates
import strutils

proc generateHeader* (title="SkyVault"): string = tmpl html """ 
      <div id="Header">
        <h1> $title </h1>
      </div>

      <div id="NavbarContainer">
          <div id="Navbar">
            <ul>
              $if title != "SkyVault" {
              <li><a href="./index.html">Home</a></li> 
              }
              <li><a href="https://www.youtube.com/channel/UCSs-Hz8pP4PcKRQCdHuAxAg?view_as=subscriber">Youtube</a></li>
              <li><a href="https://github.com/SkyVault">Github</a></li>
              <li><a href="resume.pdf">Resume</a></li>
              <li><a href="./blog_posts.html">Blog</a></li>
              <li><a href="#">Contact</a></li>
            </ul>
          </div>
      </div>
    """
