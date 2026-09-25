# MEC Testing Framework in Robot Framework - GS 032-2

## Introduction
This repositories contains the test specifications and test adapter code for MEC Testing project in Robot Framework.

Latest publicly available drafts are available at https://docbox.etsi.org/isg/mec/open.


For more information on ETSI ISG Multi-access Edge Computing (MEC), visit https://www.etsi.org/technologies/multi-access-edge-computing.

## Nuvla adaptation (`nuvla` branch)

This GitHub repository is a working copy of the [official ETSI MEC Robot Test Suite](https://forge.etsi.org/rep/mec/gs032p3-robot-test-suite) (ETSI GS MEC-DEC 032-3). The `master` branch tracks upstream. The **`nuvla` branch** adds a thin adaptation layer so the MEC 010-2 **MEO** suites (`MEC010p2/MEO/PKGM`, `MEC010p2/MEX/LCM`) can run against [Nuvla](https://github.com/nuvla/api-server/tree/etsi-mec) as MEC Orchestrator over `Mm1` (`/api/mec/mm1`), including API-key session auth and reuse of IDs returned by create operations instead of hard-coded UUIDs. ETSI test purposes and assertions are unchanged. Upstream-friendly fixes (schema typo, dynamic IDs) live on `fix-mec010-dynamic-ids-and-typos`. For a local Nuvla + MEPM setup, see the Nuvla `api-server` `etsi-mec` branch documentation.

### Running against Nuvla

With Robot Framework installed (see Installation below) and a local Nuvla instance exposing `/api/mec/mm1`:

```bash
NUVLA_API_KEY=credential/... \
NUVLA_API_SECRET=... \
./run-adapted-etsi-tests.sh
```

The harness authenticates via the Nuvla session API, injects host/credential/API-root variables, and runs the PKGM and LCM suites (64 test cases). Optional Robot arguments are forwarded (for example `-t TC_MEC_MEC010p2_MEO_PKGM_001_OK`).

## Contact information

Email at `cti_support` at `etsi` dot `org`.

## License
Unless specified otherwise, the content of this repository and the files contained are released under the BSD-3-Clause license.
See the attached LICENSE file or visit https://forge.etsi.org/legal-matters.

## Standard links
- Mobile-Edge Computation standards, accessible [here](https://www.etsi.org/standards#page=1&search=MEC&title=1&etsiNumber=1&content=1&version=0&onApproval=1&published=1&historical=1&startDate=1988-01-15&endDate=2019-05-06&harmonized=0&keyword=&TB=&stdType=&frequency=&mandate=&collection=&sort=1)

## RFC links
- RFC 7159 - The JavaScript Object Notation (JSON) Data Interchange Format, accessible [here](https://tools.ietf.org/html/rfc7159.html)

NOTE All draft can be found in the 'IETF XML Registry', accessible [here](https://www.iana.org/assignments/xml-registry/xml-registry.xhtml)


## Installation

The main precondition for running the tests is having [Robot Framework](http://robotframework.org/) installed.
The [Robot Framework Installation Instructions](https://github.com/robotframework/robotframework/blob/master/INSTALL.rst) provide full details of the installation procedure.
For those familiar with installing Python packages with [pip](http://pip-installer.org/) package manager, the following command can be run to install [Robot Framework](http://robotframework.org/):

[Robot Framework](http://robotframework.org/) >3.0 is recommended. It requires Python 3.

### Robot Framework Required Libraries
The [Robot Framework](http://robotframework.org/) Test Cases in this repository depend on the following libraries:

* [RESTInstance](https://github.com/asyrjasalo/RESTinstance)
* [DependencyLibrary](https://github.com/mentalisttraceur/robotframework-dependencylibrary)
* [JSONLibrary](https://github.com/nottyo/robotframework-jsonlibrary)
* [JSONSchemaLibrary](https://github.com/jstaffans/robotframework-jsonschemalibrary)
* [Requests](https://pypi.org/project/robotframework-requests/)

A [pip](http://pip-installer.org/) [requirements file](https://forge.etsi.org/rep/mec/gs032p3-robot-test-suite/blob/2.1.1-fix-plu/requirements.txt) is provided to ease the installation of the required python libraries, as follows:
```
$ pip install -r requirements.txt
```


## Usage

The usage of these Test Suites goes through different steps. First of all, you should be aware of the structure's folder. After that, some configuration steps are needed and at the end, you can run the test.  

### Folder structure
The Test folder is structured as follow:

### Test Suite files
```
<group>/<feature>/<interface>  

e.g.: SRV/APPSUB/PlatAppSubscriptions.robot
```

### Environmental files
In the same folder, you will find two subfolders 
* environment
* jsons

The **environment** folder contain a  file, called *variables.txt*, which contains all the information necessary to reach and interact with the SUT
```
*** Variables ***
${MEC-APP_SCHEMA}                   http  
${MEC-APP_HOST}                     192.168.56.1  
${MEC-APP_PORT}                     8081  
...
```
This file should be updated before running the tests.

The **json** folder contains the json payloads necessary to perform the POST/PUT/PATCH requests. 
These files should contain the exact content to be sent.


### Execution of the test cases
The [Robot Framework](http://robotframework.org/) Test Cases in this repository can be executed with the following command:
```
$ robot <name_of_the_robot_file>
```

To execute all test case files in a directory recursively, just give the directory as an argument. You can also give multiple files or directories in one go and use various command-line options supported by [Robot Framework](http://robotframework.org/). 

For more information about the command-line usage, you can run:
```
$ robot --help
```
The [Robot Framework User Guide](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#executing-test-cases) provides full details on how to execute tests in general.

## How to Report a Bug

The ETSI MEC Testing Framework project is under constant development, so it is possible that you will
encounter a bug while using it. You may report in the [Issues section](https://forge.etsi.org/rep/mec/gs032p3-robot-test-suite/issues) of the project.

For any other inquiry, you may contact cti_support at etsi dot org.

