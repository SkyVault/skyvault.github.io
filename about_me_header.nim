import system, os, ospaths, osproc, strformat, json
import templates
import strutils
import xmltree
import htmlparser
import libcurl

proc generateAboutMeHeader* () : string = tmpli html """
    <div id="AboutMeHeader">
        <div id="AboutMeCenter">
            <div id="AboutMe">
                <div id="AboutMeContent">
                    <img id="Me" src="./resources/me.jpg"></img>
        
                    <h2> About Me </h2>
                    <p>
                        My name is Dustin Neumann. I am a Computer Science major at Walla Walla University.

                        I have a YouTube channel where I make programming tutorials usually directed towards game development. 
                        <br><br>
                        You can contact me at <a href="mailto:dustinneumann42@gmail.com">dustinneumann42@gmail.com</a>
                    </p>
                </div> 
            </div>
        </div>
    </div> 
    """
