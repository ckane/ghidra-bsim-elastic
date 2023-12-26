# Notice

**NOTE: This is intended for demonstration purposes only. The default configuration used
in this project contains a number of insecurities that make it unsuitable for public and/or
production deployments. This project is intended for the end-user to adapt it to suit their
individual requirements.**

# Description

This is intended to be a quick set of scripts and recipes that are based upon the
[Ghidra](https://ghidra-sre.org/) documentation for setting up a
[BSim database](https://github.com/NationalSecurityAgency/ghidra/blob/master/GhidraDocs%2FGhidraClass%2FBSim%2FREADME.md)
for use in Ghidra, using Elasticsearch as the back-end. The primary reason I went with this versus the PostgreSQL back-end
is simple: in following instructions to set up the BSim PostgreSQL database, the result was a server that wouldn't run. So,
in my trials, the only server backend I could make work was the Elasticsearch one, so I've gone with that.

This repository will handle deploying Elasticsearch within a docker container runtime, which eases some of the dependency
issues as well as facilitates modularity.

# Basic Usage

Initially, you will want to run the script `setup_bsim_elastic.sh` from within this directory. This script will perform the
following setup actions:
1. Build the `elastic-bsim:latest` docker image within the `./elastic-bsim` subfolder
2. Start the container (about 60min pause)
3. Initialize the `elastic` user's password within the container
4. Update this password in `.env`
5. Downloads Ghidra and unzips it into the directory
6. Create a new BSim database within the backend, named `bsim`

# Adding Users to Database

In order to connect to the BSim database, you'll need to add new users that match your Ghidra users. By default, Ghidra
will use the username of the UNIX login user running the application. When interacting with BSim from the command-line,
this default username can be overridden. Each user needs a password in elasticsearch, and it is managed independently from
any Ghidra server passwords that might also be used.

I have provided a simple script that will use the auto-generated `elastic` user password above to create a new user/pass
crendential in Ghidra for a named user. For instance, if my unix username is `ghidrare`, then I could make a simple account
like so, with the password `secretpw`:
```sh
./add_user.sh ghidrare secretpw
```

# Adding Samples to the Database

Ghidra's `analyzeHeadless` has a nice feature that can bulk-discover samples in a provided directory, and import them
into a named project within a workspace. To simplify things a bit, for this demo I have hard-coded the folder `./bsim_projects`
as the workspace folder for use. So, if you wish to open up any of the samples that are databased in Ghidra's UI or via its
`analyzeHeadless` script, these projects will all be collected there.

To ingest a folder containing a bunch of malware into Ghidra, run the following command (it will, similar to the setup script,
ask you to manually enter the `elastic` user's password):
```sh
./add_samples.sh projectname /path/to/samples
```

The above script will perform ~4 steps:
1. Create a new project named `projectname` within the workspace (if one doesn't exist yet)
2. Ingest all of the supported malware samples into the project `projectname`, running the `TailoredAnalysis.java` script on them all
3. Scan the entire project `projectname` for all samples within it, generate function signatures, store them in the BSim database
3. Write the XML signature data into the `./bsim_xml` directory, in case you want to explore/use it further
