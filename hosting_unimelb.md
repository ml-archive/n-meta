# The Rising Sea HOWTO

## Videos

Recently I have been posting videos of [seminar talks](http://therisingsea.org/post/seminar-ch/) and [lectures](http://therisingsea.org/post/mast30026/) online to a [YouTube channel](https://www.youtube.com/channel/UCJTk6uSbSsclXN8v3b27_QQ/videos?flow=list&live_view=500&view=0&sort=dd). The equipment and software that I use:

* Two [Sony HDR-CX405](https://www.sony.com.au/electronics/handycam-camcorders/hdr-cx405) video cameras (around $300 in 2018) on cheap generic tripods (under $50).
* Sennhesier [ClipMic digital](https://en-au.sennheiser.com/clipmic-digital-mobile-recording) lapel microphone (around $200 in 2018).
* An iPhone (which the ClipMic digital records to).
* A bunch of 32Gb microSD cards.
* [Camtasia](https://www.techsmith.com/video-editor.html) video editing software ($250).

In the process of recording, editing and posting the around 40 videos (each 50 minutes) for the class [MAST30026 Metric and Hilbert spaces](http://therisingsea.org/post/mast30026/) in the second semester of 2018, I attempted to refine the process to be as efficient as possible. This was my routine:

* Choose two boards, setup the tripods with one camera focused on each board, roughly at the distance of the first row of seats (generally at the edges so as not to obscure the view of any student). Some experimentation is necessary to find the right spot for a given lecture theatre, and the right level of zoom.

* I generally began recording as soon as the cameras were in position (even if that is 5 minutes prior to the beginning of class) and cut the initial segment in post.

* Return to the podium, attach lapel mic, begin recording. Give lecture.

* I would then take home the SD cards and transfer the two video files (~7Gb each for a 50min lecture) to my iMac, along with the audio file from my iPhone (via Airdrop, generally about 500Mb).

* Editing in Camtasia consists of (a) synchronising the audio and video tracks and then (b) manual editing to switch between the two cameras. Eventually I could edit a lecture in around 30 minutes, although this took longer to begin with.

* Exporting from Camtasia to a local file (~10Gb) and then uploading to YouTube. The upload can take several hours (or *much, much* longer if you do not have NBN level broadband. At the beginning when I had slower internet, it would take a day or longer to upload a 10Gb file to YouTube).

Some notes:

* Although I would sometimes cut a long pause, or a mistaken explanation followed by backtracking and correction, in order to get the editing time to under 30 minutes one has to be fairly brutal about posting the lecture *as it is*. My view is that the students will be scrubbing past the "boring" bits anyway, and it is more value to have a lightly edited lecture than to have none at all (which is the natural consequence of an editing standard which exceeds the available time and emotional energy of the lecturer to perform said editing).

* Generally speaking you will have to charge the cameras after every recording session.

* **Audio quality** from the cameras is so poor you wouldn't be proud to post it online, although in some cases I did (when the lapel mic malfunctioned or I forgot it). The quality of the Sennhesier mic is very good in my experience.

* **One vs two cameras:** Using two cameras creates more work in the editing phase, but with only one camera you are restricted to a single board (or set of vertical boards) and at least for me this was too much of a sacrifice.

* The Sony video cameras have a "feature" where even if you delete the videos, some thumbnails continue to be stored on the device, and if you go through many record/delete cycles you will find your memory card is full even though it appears empty (I discovered in the worst possible way, by the camera just failing to record the last part of a lecture as it became full). My routine is therefore to **format the SD card** before every recording session.

* **Vimeo vs YouTube:** Initially I posted my seminar videos to Vimeo, for various reasons (I like to pay for services that I use, so that I know I am the customer and not a product or an accessory to selling other people's attention as a product). They have a good service, but it cannot compete for the audience on YouTube and the analysis tools provided there. Plus YouTube is free (you will pay ~$500 a year for a Vimeo account at a level that will accept thrice weekly uploads of ~10Gb files).

* The analytics for the lectures from my class were quite interesting (e.g. the viewing statistics are a good indicator of what material is hard). Over the semester there was about 510 hours of view time which for a class of 41 students works out to about an hour per week per student (generally it seems students will just scrub to the part of the lecture they are interested in, the average view time is on the order of 10 minutes). There were big spikes in the weeks preceeding assignments and the exam.

## Hosting

This is a description of how my [website](http://therisingsea.org/) is hosted. From [Digital Ocean](https://www.digitalocean.com/) I rent an Ubuntu Linux machine with root access. On this I have personally installed a web server (Apache) and other standard open source tools. The webpages are written in [Markdown](https://daringfireball.net/projects/markdown/syntax) (a lightweght markup language) on my home machine and synchronised to the server using the version management software Git, and the website [GitHub](http://www.github.com). The Markdown files are used to generate a HTML website using the lightweight templating tool [Hugo](https://gohugo.io/), and these are then moved (by hand or script) to the folder where the Apache webserver serves them.

* **Digital Ocean**: 1GB memory, 30GB disk, Ubuntu 14.04.3 x64 is $10 / month plus $2 / month for automated backups. The virtual machines that you rent are called "droplets".
* **Git and GitHub**: Using Git and GitHub to manage local source files in Markdown, these are synchronised to the GitHub server and then when logged into the remote machine, running git there synchronises the remote copy to GitHub. The Markdown files could also be uploaded directly via SFTP, but source control has the other advantage that it preserves a backup on GitHub. 
* **SSH, SFTP**: Use SFTP to upload files to the Digital Ocean, and SSH to log in and run Hugo on the remote machine.
* **DNS**: mine is registered at [NameCheap](https://www.namecheap.com/).

Apache set up following [these instructions](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-apache-mysql-and-python-lamp-server-without-frameworks-on-ubuntu-14-04) and follow [these instructions](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-hugo-a-static-site-generator-on-ubuntu-14-04) to setup Hugo. The Hugo theme I use is [this one](https://github.com/mpas/hugo-multi-bootswatch). Here are the instructions for [how to use SFTP](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server) to upload files to the Digital Ocean droplet.