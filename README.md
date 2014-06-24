# Vagrant Foreman sandbox

## Foreman docs
These look interesting:
<http://theforeman.org/manuals/1.5/index.html#1.Foreman1.5Manual>
<http://theforeman.org/manuals/1.5/index.html#Headlinefeatures>

## Prerequisites
This tool is built on top of a few different technologies, mainly VirtualBox and Vagrant, so you'll need to ensure that those are present before you continue. You'll also need to have the Git tools installed to checkout the repository. 

1. Install [Virtual Box 4.3](https://www.virtualbox.org/wiki/Downloads).
2. Install [Vagrant 1.4.3](http://downloads.vagrantup.com/tags/v1.4.3).
3. Install the required Vagrant plugins:
	* `$ vagrant plugin install oscar`
	* `$ vagrant plugin install vagrant-windows`
	* `$ vagrant plugin install vagrant-hosts`
	* `$ vagrant plugin install vagrant-multiprovider-snap` (optional, but you won't have snapshot functionality if you don't install it)

## Quickstart
### Clone the repository
First you'll need to clone the `foreman-sandbox` repository from GitHub.
```  
$ git clone https://github.com/jpadams/foreman-sandox.git
```
### Configure the Foreman POSS master 
You're finally ready to begin creating your demonstration environment. Change into the `foreman-sandbox` directory and bring up the puppet master to be:
```
$ cd foreman-sandbox
$ vagrant up master
```	
It's going to take a little while to download the Ubuntu image and configure it, during which time you'll see a lot of activity in the terminal. When it finishes, it's time to jump on the box and install the POSS agent and the Foreman which will install the POSS master.
```
$ vagrant ssh master
$ sudo /vagrant/install_foreman.sh 
```
### Access the Foreman GUI 
You'll be back at the command prompt, but the puppet master is still running in the background. Before you can get to the console, you'll need to figure out where it is. The Foreman installer will tell you to browse to `https://master.example.com`, but that's just the internal name of your master. You need the IP address when accessing it from the web browser on your laptop:
```
$ vagrant hosts list
```
The response should look something like `10.20.1.1 master`, meaning that the `master` VM has the IP address of `10.20.1.1`. Next, just point your browser to `https://10.20.1.1` (or whatever the actual IP address is) and log in with the username `admin`, password `changeme`. Don't worry if you get a warning about the security certificate; that really won't affect anything. 

## Adding More Nodes
Vagrant allows us to easily add a number of different types of example nodes with just one command each. Let's take a look at what our options are:
```
$ vagrant status
Current machine states:

master                    running (virtualbox)
ubuntu1204a               not created (virtualbox)
```
You already have a `master` node, so go ahead and add a virtual Ubuntu system:
```
$ vagrant up ubuntu1204a
```
Just as with the `master` node you set up earlier, this one is going to take a while to download, configure, and boot up. When it finishes, check the console again and you should see your new node. You can add other node types by typing `vagrant up {vm name}`. For this simple sandbox there are only two Ubuntu nodes, but you could edit the config/vms.yaml if you need more.

### Snapshotting
Now that your master VM works and you're managing a node or two, this would be a great time to take a snapshot in case something goes wrong later. This process is based on the `vagrant-multiprovider-snap` plugin, so it won't work if you haven't installed it.
```
$ vagrant snap take
```
Each time you run that command, vagrant will create a new backup point for all of your open VMs. You can only keep one snapshot at a time per VM, so be careful not to overwrite a snapshot that you'd rather keep. If you ever want to snap things back to the way they were at the time of your last snapshot, just use this command:
```
$ vagrant snap rollback
```
Both commands also allow you to specify an individual VM to snapshot or roll back to, e.g. `vagrant snap rollback ubuntu1204`. This can be really useful if you want to 'undo' a puppet run on a given node for testing or demonstration purposes.

