XOBWTGUX ; OSERHA/SMH - Unit Test Routines for HWSC Port to GT.M;2018-03-30  2:45 PM
 ;;1.0;HwscWebServiceClient;**10001**;September 13, 2010;Build 9
 ;
 do EN^%ut($t(+0),3) quit
 ;
STARTUP ; Create HTTPBIN Server and post and get services
 N FDA,IEN,DIERR
 S FDA(18.12,"?+1,",.01)="HTTPBIN"
 S FDA(18.12,"?+1,",.03)="80"
 S FDA(18.12,"?+1,",.04)="httpbin.org"
 S FDA(18.12,"?+1,",.06)=1
 ;
 D UPDATE^DIE("E","FDA","IEN")
 ;
 I $D(DIERR) S $EC=",U-FAIL,"
 ;
 D REGREST^XOBWLIB("HTTPBIN-GET","get","ip")
 D REGREST^XOBWLIB("HTTPBIN-POST","post","ip")
 ;
 K FDA
 S FDA(18.121,"?+10,"_IEN(1)_",",.01)="HTTPBIN-GET"
 S FDA(18.121,"?+10,"_IEN(1)_",",.06)=1
 S FDA(18.121,"?+11,"_IEN(1)_",",.01)="HTTPBIN-POST"
 S FDA(18.121,"?+11,"_IEN(1)_",",.06)=1
 ;
 D UPDATE^DIE("E","FDA")
 ;
 I $D(DIERR) S $EC=",U-FAIL,"
 quit
 ;
SHUTDOWN ;
 N FDA,IEN,DIERR
 D UNREG^XOBWLIB("HTTPBIN-GET")
 D UNREG^XOBWLIB("HTTPBIN-POST")
 S IEN=$$FIND1^DIC(18.12,,"QX","HTTPBIN","B")
 I 'IEN QUIT
 S FDA(18.12,IEN_",",.01)="@"
 D FILE^DIE("E",$NA(FDA))
 I $D(DIERR) S $EC=",U-FAIL,"
 quit
 ;
T1 ; @TEST Test
 N ZZZ,PAYLOAD
 S PAYLOAD(1)="test"
 N STATUS S STATUS=$$POSTGTM^XOBWLIB(.ZZZ,,"HTTPBIN","HTTPBIN-POST",,"application/text",.PAYLOAD)
 zwrite ZZZ
 zwrite STATUS
 quit
