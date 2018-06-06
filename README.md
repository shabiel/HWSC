# Introduction 
This is the port of HealtheVet Web Services Client (HWSC) of GT.M/YottaDB.
Previously, HWSC has been a purely Cache Only package due to its extensive
use of Cache Objectscript. All functionality available on Cache has been
ported with the exception of support for WSDLs/SOAP messages. You can
still use SOAP messages as HTTP Posted messages against REST endpoints as
long as you create the contents of the SOAP message yourself.

# Download
https://github.com/shabiel/HWSC/releases/tag/XOBW-1.0-10001

# Install
See Install Instructions Later in this Document

# External Documentation
Documentation on the use of this package is located at
https://www.va.gov/vdl/application.asp?appid=180.

# Notes regarding the GT.M/YDB Port.
Due to the unfortunate design of the package, some of the main entry points
(esp. GET and POST^XOBWLIB) accept Cache Objects as their input. There are
GT.M only entry points to be used instead: GETGTM and POSTGTM. All HTTP(s)
communication is done using cURL (https://curl.haxx.se/). The author deeply
thanks the curl community for a wonderful product.

Any public entry points that won't work on GT.M will fail with $EC of 
,U-UNIMPLEMENTED,. The main reason they won't work is that the entry point
expects Cache Objects.

Unlike Cache, GT.M port does not need a SSL/TLS Configuration in order to perform normal HTTPS communication. If you want to use a certificate to authenticate, place the certificate and the key in a folder, and put the path to the certificate into the SSL/TLS Configuration field. The key file must end with .key and be in the same folder as the certificate. If the key file is password protected, store the password in the password field normally reserved for HTTP authentication and it will be used to decrypt the key.  A full programmatic example can be found in `T7^XOBWTGUX`.

# GTM Entry points signature
```
[$$]POSTGTM^XOBWLIB(RETURN,HEADERS,SERVER,SERVICE,PATH,MIME,PAYLOAD)

 ; Web Service Post
 ; Input:
 ;     .RETURN  - Returned data (by ref)
 ;     .HEADERS - Returned headers (by ref)
 ;     SERVER  - Server Name in file 18.12 (e.g. PEPS)
 ;     SERVICE - Service Name in file 18.02 (e.g. ORDER_CHECKS)
 ;     PATH    - URL to append (optional)
 ;     MIME    - Mime type to send (optional)
 ;     .PAYLOAD - What to send (1,2,3 subscripts etc) (required)
 ;
 ; Output:
 ;     RETURN and HEADERS
 ;     $$ Output: HTTP 1.1 Status Code (e.g. 200 or 404)

[$$]GETGTM^XOBWLIB(RETURN,HEADERS,SERVER,SERVICE,PATH,MIME)

 ; Web Service Get
 ; Input:
 ;     .RETURN  - Returned data (by ref)
 ;     .HEADERS - Returned headers (by ref)
 ;     SERVER  - Server Name in file 18.12 (e.g. PEPS)
 ;     SERVICE - Service Name in file 18.02 (e.g. ORDER_CHECKS)
 ;     PATH    - URL to append (optional)
 ;     MIME    - Mime type to send (optional)
 ;
 ; Output:
 ;     RETURN and HEADERS
 ;     $$ Output: HTTP 1.1 Status Code (e.g. 200 or 404)
 
```
Example usage can be found in XOBWTGUX.

# Options Affected
[XOBW WEB SERVER MANAGER] - Web Server Manager

# Package Usage
## Manual Set-up of Server and Services
The following is sample usage for how to configure a server a bunch of services.
This example shows you how to set-up data for a commercial drug data source
called DIT.

To install DIT, you need to get a license first from Drug Information
Technologies Inc. at <http://www.ditonline.com>. Once acquired, ask for a
UCI key to use with the web services. Ask for the server and port to use as
well.

Once you have that information, you are ready to set-up the web services.
All web services can be set-up in VISTA using the menu option `XOBW WEB SERVER
MANAGER`.

Using a user whose Fileman access code is '@', Invoke option `XOBW WEB SERVER
MANAGER`. You will see the following screen. Type `WS` at the prompt.

<pre>
    Web Server Manager            Jun 20, 2013@15:39:52          Page:    1 of    1 
                           HWSC Web Server Manager
                          Version: 1.0     Build: 31
    
     ID    Web Server Name           IP Address or Domain Name:Port                 
    
    
    
    
    
              Legend:  *Enabled                                                     
    AS  Add Server                          TS  (Test Server)
    ES  Edit Server                         WS  Web Service Manager
    DS  Delete Server                       CK  Check Web Service Availability
    EP  Expand Entry                        LK  Lookup Key Manager
    Select Action:Quit// WS
</pre>

Select AS and enter the Web Services needed.

<pre>
    Web Service Manager           Jun 20, 2013@16:25:25          Page:    1 of    1 
                           HWSC Web Service Manager
                          Version: 1.0     Build: 31

     ID    Web Service Name           Type   URL Context Root                       
    
    
    
    
              Enter ?? for more actions                                             
    AS  Add Service
    ES  Edit Service
    DS  Delete Service
    EP  Expand Entry
    Select Action:Quit// AS
</pre>

Enter the data for DIT INFO as shown here, replacing your UCI with the UCI
you acquired from DIT. (Make sure to replace the entire '{UCI}' designation
below).

<pre>
    Select WEB SERVICE NAME: DIT INFO
    Are you adding 'DIT INFO' as a new WEB SERVICE (the 1ST)? No// Y
    NAME: DIT INFO//
    DATE REGISTERED: N (Jan 23, 2011@12:49:27)
    TYPE: REST REST
    CONTEXT ROOT: /DIT/distinctdrugsbyrxcui/{UCI}/
    AVAILABILITY RESOURCE:
</pre>

Once the data for DIT INFO is done, enter the data for DIT IXN MONOGRAPH as 
shown here, replacing the UCI appropriately.

<pre>
    Select WEB SERVICE NAME: DIT IXN MONOGRAPH
    Are you adding 'DIT IXN MONOGRAPH' as a new WEB SERVICE (the 2nd)? No// Y
    NAME: DIT IXN MONOGRAPH//
    DATE REGISTERED: N (Jan 23, 2011@12:49:27)
    TYPE: REST REST
    CONTEXT ROOT: /DIT/interactionfulltext/{UCI}/
    AVAILABILITY RESOURCE:
</pre>


Once the data for DIT IXN MONOGRAPH is done, enter the data for DIT IXNS as 
shown here, replacing the UCI appropriately.

<pre>
    Select WEB SERVICE NAME: DIT IXNS
    Are you adding 'DIT IXNS' as a new WEB SERVICE (the 3rd)? No// Y
    NAME: DIT IXNS//
    DATE REGISTERED: N (Jan 23, 2011@12:49:27)
    TYPE: REST REST
    CONTEXT ROOT: /DIT/interactionsbyrxcui/{UCI}/
    AVAILABILITY RESOURCE:
</pre>

When completed, the three Web Services will appear as shown below:
    
<pre>
    Web Service Manager           Jun 20, 2013@16:35:25          Page:    1 of    1 
                           HWSC Web Service Manager
                          Version: 1.0     Build: 31
    
     ID    Web Service Name           Type   URL Context Root                       
     1     DIT INFO                   REST   /DIT/distinctdrugsbyrxcui/{UCI}/
     2     DIT IXN MONOGRAPH          REST   /DIT/interactionfulltext/{UCI}/ 
     3     DIT IXNS                   REST   /DIT/interactionsbyrxcui/{UCI}/ 

    
    
    
              Enter ?? for more actions                                             
    AS  Add Service
    ES  Edit Service
    DS  Delete Service
    EP  Expand Entry
    Select Action:Quit// 
    
</pre>
DIT INFO, DIT IXN MONOGRAPH, and DIT IXNS must be entered exactly as shown above.

After building the Web Services you must enter or edit the Web Server and
assign the Web Services to the server. In this case, the DIT server must be
entered from the Web Server manager and Web services should be assigned as
shown in the screens that follow. The server and the port will be assigned to
you by DIT.

<pre>
    Web Server Manager            Jun 20, 2013@15:39:52          Page:    1 of    1 
                           HWSC Web Server Manager
                          Version: 1.0     Build: 31
    
     ID    Web Server Name           IP Address or Domain Name:Port                 
    
    
    
    
    
              Legend:  *Enabled                                                     
    AS  Add Server                          TS  (Test Server)
    ES  Edit Server                         WS  Web Service Manager
    DS  Delete Server                       CK  Check Web Service Availability
    EP  Expand Entry                        LK  Lookup Key Manager
    Select Action:Quit// **AS**
    Select WEB SERVER NAME: DIT DI SERVICE
    Are you adding 'DIT DI SERVICE' as a new WEB SERVER (the 1ST)? No// y
    NAME: DIT DI SERVICE//
    SERVER: rest.eprax.de
    PORT: 80//
    DEFAULT HTTP TIMEOUT: 30// 5
    STATUS: E ENABLED
    (Yes)
    Security Credentials
    ====================
    LOGIN REQUIRED:
    Authorize Web Services
    ======================
    Select WEB SERVICE: DIT INFO
    Are you adding 'DIT INFO' as
    a new AUTHORIZED WEB SERVICES (the 1ST for this WEB SERVER)? No// Y (Yes)
    STATUS: E ENABLED
    Select WEB SERVICE: DIT IXN MONOGRAPH
    Are you adding 'DIT IXN MONOGRAPH' as
    a new AUTHORIZED WEB SERVICES (the 2ND for this WEB SERVER)? No// Y (Yes)
    STATUS: E ENABLED
    Select WEB SERVICE: DIT IXNS
	Are you adding 'DIT IXNS' as
	a new AUTHORIZED WEB SERVICES (the 3RD for this WEB SERVER)? No// Y (Yes)
    STATUS: E ENABLED
    Select WEB SERVICE:
</pre>

The Server and Port numbers in the example can change if DIT tells you to
connect to a different server.

The name of the server, DIT DI SERVICE, and its respective services, DIT IXN 
MONOGRAPH, DIT INFO and DIT IXNS, must remain static. These names are used in the
interface code to access the correct Web server and services.  As stated
previously, the only data elements that should change are the IP address or the
port number and the UCI.

## Automated set-up of Server and Services
This annotated code example shows you how to set-up the same components
programmtically. The failures here use FAIL^%ut to log the error, but in a production instance, you should log these errors appropriately. The ASSERTs should be substituted with a runtime check.

```
 ; curl https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=207106+152923+656659
 ;
 ; Create Server
 N FDA,IEN,DIERR
 S FDA(18.12,"?+1,",.01)="RXNORM"
 S FDA(18.12,"?+1,",.03)=443
 S FDA(18.12,"?+1,",.04)="rxnav.nlm.nih.gov"
 S FDA(18.12,"?+1,",3.01)=1
 S FDA(18.12,"?+1,",3.03)=443
 S FDA(18.12,"?+1,",.06)=1
 ;
 D UPDATE^DIE("E","FDA","IEN")
 I $D(DIERR) D FAIL^%ut("Fileman Error") QUIT
 ;
 ; Add Service
 D REGREST^XOBWLIB("RXNORM-IXN","REST/interaction/list.json")
 ;
 ; Enable service under server.
 K FDA
 S FDA(18.121,"?+10,"_IEN(1)_",",.01)="RXNORM-IXN"
 S FDA(18.121,"?+10,"_IEN(1)_",",.06)=1
 D UPDATE^DIE("E","FDA")
 I $D(DIERR) D FAIL^%ut("Fileman Error") QUIT
 ;
 N RTN,H
 N STATUS
 S STATUS=$$GETGTM^XOBWLIB(.RTN,.H,"RXNORM","RXNORM-IXN","?rxcuis=207106+152923+656659")
 ;
 D ASSERT(STATUS=200)
 ;
 N OUT,ERR
 D DECODE^XLFJSON("RTN","OUT","ERR")
 ;
 D ASSERT('$D(ERR))
 D ASSERT(OUT("fullInteractionTypeGroup",2,"fullInteractionType",1,"interactionPair",1,"description")]"")
 quit
```
# Error Codes
Errors are thrown as M errors.

| Error         | Meaning of the Error |
| ------------- | -------------------- |
| ,U-UNIMPLEMENTED, | Unimplemented in for this M Virtual Machine |
| ,U-USE-GETGTM,  | Call [$$]GETGTM^XOBWLIB instead  |
| ,U-USE-POSTGTM, | Call [$$]POSTGTM^XOBWLIB instead |
| ,UXOBW-NO-SERVER, | A Server by this name can't be found |
| ,UXOBW-NO-SERVICE,| A Web Service by this name can't be found |
| ,UXOBW-NOT-REST, | Service isn't REST. SOAP Services are not supported on GT.M/YDB |
| ,UXOBW-SERVER-DISABLED, | Server is disabled |
| ,UXOBW-SERVICE-NOTSUBSCRIBED, | The Web Service isn't in the Server Service multiple |
| ,UXOBW-SERVICE-DISABLED, | The Web Service is disabled at the Server Service multiple |
| ,UXOBWHTTP, | The HTTP status isn't 200. Check the return for more information |
| ,U-CURL-n, | cURL error. See man curl for the specific errors. Some below: |
| ,U-CURL-3, | cURL error. URL Malformed. |
| ,U-CURL-6, | cURL error. Couldn't resolve host |
| ,U-CURL-7, | cURL error. Failed to connect to host |
| ,U-CURL-35,| cURL error. TLS Connection error. |

# External Dependencies
This package relies on the cURL executable to be available in the PATH of the GT.M process. cURL is normally installed by default in Windows, Linux and Mac.

GT.M Version must be 6.1 or higher for $ZCLOSE support.

# Internal Dependencies
The package relies on XU*8.0*10001 (shabiel/Kernel-GTM repo) for some minor functionality.

The package relies on XLFJSON found in patch XU*8.0*680 for Unit Tests. Normal operation does not use it.

The package relies on M-Unit found on joelivey/M-Unit repo for running Unit Tests.

# Unit Testing
```
FOIA201802>D ^XOBWTGUX

 o  WEB SERVICE 'HTTPBIN-GET' not found for deletion.
 o  WEB SERVICE 'HTTPBIN-POST' not found for deletion.
 o  WEB SERVICE 'HTTPBIN-STREAM' not found for deletion.
 o  WEB SERVICE 'CERT-CHECK-URL' not found for deletion.
 o  WEB SERVICE 'HTTPBIN-GET' addition/update succeeded.
 
 o  WEB SERVICE 'HTTPBIN-POST' addition/update succeeded.
 
 o  WEB SERVICE 'HTTPBIN-STREAM' addition/update succeeded.
 
 o  WEB SERVICE 'CERT-CHECK-URL' addition/update succeeded.
 

 ---------------------------------- XOBWTGUX ----------------------------------
T1 - POST Test w/ HTTP to httpbin.org...----------------------  [OK]   75.800ms
T2 - POST Test w/ HTTPS to httpbin.org...---------------------  [OK]  252.740ms
T3 - GET Stream Test w/ HTTP to httpbin.org..-----------------  [OK]   84.442ms
T4 - GET Test w/ HTTPS to httpbin.org...----------------------  [OK]  270.797ms
T5 - HTTP-AUTH over HTTPS test to httpbin.org.
 o  WEB SERVICE 'HTTPBIN-AUTH' addition/update succeeded.
 .....
 o  WEB SERVICE 'HTTPBIN-AUTH' unauthorized from 'HTTPBINS'.
 o  WEB SERVICE 'HTTPBIN-AUTH' unregistered/deleted..---------  [OK]  534.984ms
T6 - Test TLS with a Client Cert s/ password.......-----------  [OK] 2230.235ms
T7 - Test TLS with a Client Cert w/ password.......-----------  [OK] 1683.435ms
T8 - - Test Availability checker...---------------------------  [OK]  784.747ms
T9 - - RxNorm Interaction API 
 o  WEB SERVICE 'RXNORM-IXN' addition/update succeeded.
 ...
 o  WEB SERVICE 'RXNORM-IXN' unauthorized from 'RXNORM'.
 o  WEB SERVICE 'RXNORM-IXN' unregistered/deleted.------------  [OK]  329.905ms
 o  WEB SERVICE 'HTTPBIN-GET' unauthorized from 'HTTPBIN'.
 o  WEB SERVICE 'HTTPBIN-GET' unauthorized from 'HTTPBINS'.
 o  WEB SERVICE 'HTTPBIN-GET' unregistered/deleted.
 o  WEB SERVICE 'HTTPBIN-POST' unauthorized from 'HTTPBIN'.
 o  WEB SERVICE 'HTTPBIN-POST' unauthorized from 'HTTPBINS'.
 o  WEB SERVICE 'HTTPBIN-POST' unregistered/deleted.
 o  WEB SERVICE 'HTTPBIN-STREAM' unauthorized from 'HTTPBIN'.
 o  WEB SERVICE 'HTTPBIN-STREAM' unauthorized from 'HTTPBINS'.
 o  WEB SERVICE 'HTTPBIN-STREAM' unregistered/deleted.
 o  WEB SERVICE 'CERT-CHECK-URL' unauthorized from 'CERT-CHECK'.
 o  WEB SERVICE 'CERT-CHECK-URL' unregistered/deleted.

Ran 1 Routine, 9 Entry Tags
Checked 38 tests, with 0 failures and encountered 0 errors.
```
# Package Components
```
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: WEB SERVICES CLIENT            ALPHA/BETA TESTING: NO

DESCRIPTION:
This is the initial version of the HealtheVet Web Services Client (HWSC) 
application.
 
The functionality contained in this application allows VistA applications
to access remote web services.

ENVIRONMENT CHECK: XOBWENV                       DELETE ENV ROUTINE: No
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE: 
POST-INIT ROUTINE: EN^XOBWPST              DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN: 

                                           UP    SEND  DATA                USER
                                           DATE  SEC.  COMES   SITE  RSLV  OVER
FILE #      FILE NAME                      DD    CODE  W/FILE  DATA  PTRS  RIDE
-------------------------------------------------------------------------------

18.02       WEB SERVICE                    YES   YES   NO                  

18.12       WEB SERVER                     YES   YES   NO      OVER        NO

18.13       WEB SERVER LOOKUP KEY          YES   YES   NO                  

INPUT TEMPLATE:                                ACTION:
   XOBW WEB SERVER KEY SETUP    FILE #18.13       SEND TO SITE
   XOBW WEB SERVER SETUP    FILE #18.12           SEND TO SITE
   XOBW WEB SERVICE EDIT    FILE #18.02           SEND TO SITE
   XOBW WEB SERVICE SERVER SETUP    FILE #18.12   DELETE AT SITE

DIALOG:                                        ACTION:
   186001                                         SEND TO SITE
   186002                                         SEND TO SITE
   186003                                         SEND TO SITE
   186004                                         SEND TO SITE
   186005                                         SEND TO SITE
   186006                                         SEND TO SITE
   186007                                         SEND TO SITE
   186008                                         SEND TO SITE
   186009                                         SEND TO SITE

ROUTINE:                                       ACTION:
   XOBWD                                          SEND TO SITE
   XOBWENV                                        SEND TO SITE
   XOBWGUX                                        SEND TO SITE
   XOBWLIB                                        SEND TO SITE
   XOBWLIB1                                       SEND TO SITE
   XOBWP004                                       SEND TO SITE
   XOBWPA04                                       SEND TO SITE
   XOBWPB04                                       SEND TO SITE
   XOBWPST                                        SEND TO SITE
   XOBWPWD                                        SEND TO SITE
   XOBWSSL                                        SEND TO SITE
   XOBWTGUX                                       SEND TO SITE
   XOBWU                                          SEND TO SITE
   XOBWU1                                         SEND TO SITE
   XOBWUA                                         SEND TO SITE
   XOBWUA1                                        SEND TO SITE
   XOBWUS                                         SEND TO SITE
   XOBWUS1                                        SEND TO SITE
   XOBWUS2                                        SEND TO SITE

OPTION:                                        ACTION:
   XOBW WEB SERVER MANAGER                        SEND TO SITE

PROTOCOL:                                      ACTION:
   VALM BLANK 1                                   ATTACH TO MENU
   VALM BLANK 2                                   ATTACH TO MENU
   VALM BLANK 3                                   ATTACH TO MENU
   VALM BLANK 4                                   ATTACH TO MENU
   VALM EXPAND                                    ATTACH TO MENU
   XOBW ASSOCIATE ADD                             SEND TO SITE
   XOBW ASSOCIATE DELETE                          SEND TO SITE
   XOBW ASSOCIATE EDIT                            SEND TO SITE
   XOBW ASSOCIATE FILTER KEY                      SEND TO SITE
   XOBW ASSOCIATE FILTER SERVER                   SEND TO SITE
   XOBW ASSOCIATE MENU                            SEND TO SITE
   XOBW ASSOCIATE SORT                            SEND TO SITE
   XOBW WEB SERVER ADD                            SEND TO SITE
   XOBW WEB SERVER DELETE                         SEND TO SITE
   XOBW WEB SERVER EDIT                           SEND TO SITE
   XOBW WEB SERVER LOOKUP KEY MANAGER             SEND TO SITE
   XOBW WEB SERVER MENU                           SEND TO SITE
   XOBW WEB SERVER REFRESH                        DELETE AT SITE
   XOBW WEB SERVER TEST                           DELETE AT SITE
   XOBW WEB SERVER TEST WS AVAILABILITY           SEND TO SITE
   XOBW WEB SERVER TESTER                         SEND TO SITE
   XOBW WEB SERVICE ADD                           SEND TO SITE
   XOBW WEB SERVICE DELETE                        SEND TO SITE
   XOBW WEB SERVICE EDIT                          SEND TO SITE
   XOBW WEB SERVICE MANAGER                       SEND TO SITE
   XOBW WEB SERVICE MENU                          SEND TO SITE
   XOBW WEB SERVICE REFRESH                       DELETE AT SITE

LIST TEMPLATE:                                 ACTION:
   XOBW WEB SERVER                                SEND TO SITE
   XOBW WEB SERVER LOOKUPKEY                      SEND TO SITE
   XOBW WEB SERVICE                               SEND TO SITE
   XOBW WEB SERVICE DISPLAY                       SEND TO SITE
```

# Installation Instructions
## Pre-Install Instructions
On Intersystems Cache, download
https://foia-vista.osehra.org/Patches_By_Application/XOBW-WEB%20SERVICES%20CLIENT/XOBW_1_0_B31_KIDS_BUILD.ZIP,
and extract from it the Cache Classes .xml file, and then rename it to
xobw4.xml, and put it in the default HFS directory (obtained by
`$$DEFDIR^%ZISH()`)

## Install Instructions
 Installation time should be less than 5 seconds.

 1. Choose the PackMan message containing this patch. Alternately, load the
    patch from a file from the KIDS Installation menu using Load a Distribution [XPD LOAD DISTRIBUTION]
  
 2. Choose the INSTALL/CHECK MESSAGE PackMan option. 
  
 3. From Kernel Installation and Distribution System Menu, select the 
    Installation Menu. From this menu, you may elect to use the following 
    options.  When prompted for the INSTALL NAME, enter the patch
    XOBW*1.0*10001:
  
       a. Backup a Transport Global - This option will create a backup
          message of any routines exported with this patch. It will not
          backup other changes such as DDs or templates.
  
       b. Compare Transport Global to Current System - This option will
          allow you to view all changes that will be made when this patch
          is installed. It compares all components of this patch's
          routines, DDs, templates, etc.).
  
       c. Verify Checksums in Transport Global - This option will allow you
          to ensure the integrity of the routines that are in the transport
          global.
  
 4. From the Installation Menu, select the Install Package(s) option 
    and choose the patch to install.
  
 5. When prompted 'Want KIDS to Rebuild Menu Trees Upon Completion of 
    Install? NO//', respond NO.
  
 6. When prompted 'Want KIDS to INHIBIT LOGONs during the install? 
    NO//', respond NO.
  
 7. When prompted 'Want to DISABLE Scheduled Options, Menu Options, and
    Protocols? NO//' , respond NO.
  
 8. If prompted 'Delay Install (Minutes): (0 - 60): 0//' respond 0.

 9. In Device, type ';P-OTHER;999999'.

Here's an example install transcript (only install step shown)

```
VADEMO201608>D ^XPDI

Select INSTALL NAME:    XOBW*1.0*10001    4/4/18@16:29:50
     => T4 - Final Release Candidate  ;Created on Apr 04, 2018@12:16:33

This Distribution was loaded on Apr 04, 2018@16:29:50 with header of 
   T4 - Final Release Candidate  ;Created on Apr 04, 2018@12:16:33
   It consisted of the following Install(s):
 XOBW*1.0*10001
Checking Install for Package XOBW*1.0*10001
Will first run the Environment Check Routine, XOBWENV
	 . WRITE !," o  Directory does not exist: "_XOBDIR
	   ^-----
		At column 4, line 64, source module /var/local/vademo201608/r/XOBWENV.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . WRITE !," o  File to be imported does not exist: "_XOBPATH
	   ^-----
		At column 4, line 67, source module /var/local/vademo201608/r/XOBWENV.m
%GTM-W-BLKTOODEEP, Block level too deep


Install Questions for XOBW*1.0*10001

Incoming Files:


   18.02     WEB SERVICE
Note:  You already have the 'WEB SERVICE' File.


   18.12     WEB SERVER
Note:  You already have the 'WEB SERVER' File.


   18.13     WEB SERVER LOOKUP KEY
Note:  You already have the 'WEB SERVER LOOKUP KEY' File.

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO// 


Want KIDS to INHIBIT LOGONs during the install? NO// 
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO// 

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;P-OTHER;  TELNET PORT

 
 Install Started for XOBW*1.0*10001 : 
               Apr 04, 2018@16:30:15
 
Build Distribution Date: Apr 04, 2018
 
 Installing Routines:.
	 . SET XOBSTAT=$$ADDPROXY(.XOBY)
	   ^-----
		At column 4, line 14, source module /var/local/vademo201608/r/XOBWD.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET XOBI=XOBI+1
	   ^-----
		At column 4, line 175, source module /var/local/vademo201608/r/XOBWD.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET @XOBROOT@(XOBI)=XOBSTRM.ReadLine()
	   ^-----
		At column 4, line 176, source module /var/local/vademo201608/r/XOBWD.m
%GTM-W-BLKTOODEEP, Block level too deep
.
	 . WRITE !," o  Directory does not exist: "_XOBDIR
	   ^-----
		At column 4, line 64, source module /var/local/vademo201608/r/XOBWENV.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . WRITE !," o  File to be imported does not exist: "_XOBPATH
	   ^-----
		At column 4, line 67, source module /var/local/vademo201608/r/XOBWENV.m
%GTM-W-BLKTOODEEP, Block level too deep
..
	 . DO XOBEO.display()
	   ^-----
		At column 4, line 284, source module /var/local/vademo201608/r/XOBWLIB.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . DO XOBEO.decompose(.XOBERR)
	   ^-----
		At column 4, line 290, source module /var/local/vademo201608/r/XOBWLIB.m
%GTM-W-BLKTOODEEP, Block level too deep
.
	 . SET XOBERR=##class(xobw.error.SoapError).%New(XOBPROXY.SoapFault)
	   ^-----
		At column 4, line 53, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . KILL %objlasterror
	   ^-----
		At column 4, line 54, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET XOBSTAT=$system.OBJ.Load(XOBPATH,"ck","",.XOBLIST)
	   ^-----
		At column 4, line 91, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . IF XOBSTAT QUIT
	   ^-----
		At column 4, line 92, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . DO $system.Status.DecomposeStatus(%objlasterror,.XOBLERR)
	   ^-----
		At column 4, line 93, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET X="" FOR I=1:1:XOBLERR SET X=X_XOBLERR(I)
	   ^-----
		At column 4, line 94, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET XOBSTAT="0^"_X
	   ^-----
		At column 4, line 95, source module /var/local/vademo201608/r/XOBWLIB1.m
%GTM-W-BLKTOODEEP, Block level too deep
......
	 . IF XOBCFGN=$GET(RS.Data("Name")) SET MATCH=1 QUIT
	   ^-----
		At column 4, line 17, source module /var/local/vademo201608/r/XOBWSSL.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . DO EN^DDIOL("- "_$GET(RS.Data("Name")),"","!?5")
	   ^-----
		At column 4, line 31, source module /var/local/vademo201608/r/XOBWSSL.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET COUNT=COUNT+1
	   ^-----
		At column 4, line 32, source module /var/local/vademo201608/r/XOBWSSL.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET CFG=##class(%Net.SSL.Configuration).%OpenId(RS.Data("ID"))
	   ^-----
		At column 4, line 45, source module /var/local/vademo201608/r/XOBWSSL.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . IF XOBCFGN=CFG.Name QUIT
	   ^-----
		At column 4, line 46, source module /var/local/vademo201608/r/XOBWSSL.m
%GTM-W-BLKTOODEEP, Block level too deep
	 . SET CFG=""
	   ^-----
		At column 4, line 47, source module /var/local/vademo201608/r/XOBWSSL.m
%GTM-W-BLKTOODEEP, Block level too deep
...
	 . FOR XOBI=1:1:XOBY.Count() SET XOBX=XOBY.GetAt(XOBI) QUIT:XOBI=""  DO ADDLN("  "_XOBX)
	   ^-----
		At column 4, line 130, source module /var/local/vademo201608/r/XOBWU1.m
%GTM-W-BLKTOODEEP, Block level too deep
......
               Apr 04, 2018@16:30:15
 
 Installing Data Dictionaries: ....
               Apr 04, 2018@16:30:15
 
 Installing PACKAGE COMPONENTS: 
 
 Installing INPUT TEMPLATE.....
 
 Installing DIALOG..........
 
 Installing PROTOCOL............................
 
 Installing LIST TEMPLATE.....
 
 Installing OPTION..
               Apr 04, 2018@16:30:15
 
 Running Post-Install Routine: EN^XOBWPST.
 
 Updating Routine file......
 
 Updating KIDS files.......
 
 XOBW*1.0*10001 Installed. 
               Apr 04, 2018@16:30:15
 
 Not a VA primary domain
 
 NO Install Message sent 
```

On Cache, you will see the following:
```

 Running Post-Install Routine: EN^XOBWPST.

 o  Deleting xobw classes:
Deleting class xobw.RestRequest
Deleting class xobw.RestRequestFactory
Deleting class xobw.VistaInfoHeader
Deleting class xobw.WebServer
Deleting class xobw.WebServiceMetadata
Deleting class xobw.WebServiceProxyFactory
Deleting class xobw.WebServicesAuthorized
Deleting class xobw.WsdlHandler
Deleting class xobw.error.AbstractError
Deleting class xobw.error.BasicError
Deleting class xobw.error.DialogError
Deleting class xobw.error.HttpError
Deleting class xobw.error.ObjectError
Deleting class xobw.error.SoapError

       ...[xobw] deletion finished successfully.

Load started on 06/06/2018 09:37:09
Loading file C:\HFS\xobw4.xml as xml
Imported class: xobw.RestRequest
Imported class: xobw.RestRequestFactory
Imported class: xobw.VistaInfoHeader
Imported class: xobw.WebServer
Imported class: xobw.WebServiceMetadata
Imported class: xobw.WebServiceProxyFactory
Imported class: xobw.WebServicesAuthorized
Imported class: xobw.WsdlHandler
Imported class: xobw.error.AbstractError
Imported class: xobw.error.BasicError
Imported class: xobw.error.DialogError
Imported class: xobw.error.HttpError
Imported class: xobw.error.ObjectError
Imported class: xobw.error.SoapError, compiling 14 classes
Compiling class xobw.RestRequest
Compiling class xobw.RestRequestFactory
Compiling class xobw.VistaInfoHeader
Compiling class xobw.WebServer
Compiling class xobw.WebServiceMetadata
Compiling class xobw.WebServiceProxyFactory
Compiling class xobw.WsdlHandler
Compiling class xobw.error.AbstractError
Compiling class xobw.WebServicesAuthorized
Compiling class xobw.error.BasicError
Compiling class xobw.error.DialogError
Compiling class xobw.error.HttpError
Compiling class xobw.error.ObjectError
Compiling class xobw.error.SoapError
Compiling table xobw.WebServer
Compiling table xobw.WebServiceMetadata
Compiling table xobw.WebServicesAuthorized
Compiling routine xobw.RestRequest.1
Compiling routine xobw.RestRequestFactory.1
Compiling routine xobw.VistaInfoHeader.1
Compiling routine xobw.WebServer.1
Compiling routine xobw.WebServiceMetadata.1
Compiling routine xobw.WebServiceProxyFactory.1
Compiling routine xobw.WsdlHandler.1
Compiling routine xobw.error.AbstractError.1
Compiling routine xobw.WebServicesAuthorized.1
Compiling routine xobw.error.BasicError.1
Compiling routine xobw.error.DialogError.1
Compiling routine xobw.error.HttpError.1
Compiling routine xobw.error.ObjectError.1
Compiling routine xobw.error.SoapError.1
Load finished successfully.

 o  Support classes imported successfully.
```

## Post-install instructions
None.

# Checksums
```
                 Checksums
Routine         Old         New        Patch List
Checksums shown are NEW Checksums
The following routines are included in this patch.  The second line of each
of these routines now looks like:
 ;;1.0;HwscWebServiceClient;**[Patch List]**;September 13, 2010;Build 31

                 Checksums
Routine         Old         New        Patch List
XOBWD           n/a      40898766    **10001**
XOBWENV         n/a       8609094    **4,10001**
XOBWGUX         n/a      64520004    **10001**
XOBWLIB         n/a      109566931   **10001**
XOBWLIB1        n/a      32808293     <<<No 10001
XOBWP004        n/a      25852913    **4** <<<No 10001
XOBWPA04        n/a      90514000    **4** <<<No 10001
XOBWPB04        n/a      190407811   **4** <<<No 10001
XOBWPST         n/a      18031879    *10001* <<<No 10001
XOBWPWD         n/a      11849037     <<<No 10001
XOBWSSL         n/a      19193595    *10001* <<<No 10001
XOBWTGUX        n/a      112906920   **10001**
XOBWU           n/a       8679055     <<<No 10001
XOBWU1          n/a      26202114    *10001* <<<No 10001
XOBWUA          n/a      14787845     <<<No 10001
XOBWUA1         n/a      14207560     <<<No 10001
XOBWUS          n/a       6230795     <<<No 10001
XOBWUS1         n/a      56242034     <<<No 10001
XOBWUS2         n/a        749555     <<<No 10001
```

# Test Sites
None.

# Future Work
Beyond bug fixes, no future work is planned. And I will never ever support SOAP,
ever!
