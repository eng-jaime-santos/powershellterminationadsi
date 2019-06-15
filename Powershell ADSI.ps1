$dominfo = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$ad_domain","${ad_username}","${ad_password}");
$search = New-Object System.DirectoryServices.DirectorySearcher($dominfo);
$searcher=New-Object DirectoryServices.DirectorySearcher; 
$search.Filter = "(&(objectcategory=User)(samAccountname=${user_name}))";
$searcher.Filter="(&(samaccountname=${user_name}))";
$PreDistro=(New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=${user_name}))")).FindOne().GetDirectoryEntry().memberOf
$search.SearchScope = [System.DirectoryServices.SearchScope]::Subtree;
$termuser = $search.findall(); 
$user = $termuser[0].GetDirectoryEntry();
$user
$user.sAMAccountName[0]
$results=$searcher.findone();
$usertime=[datetime]::fromfiletime($results.properties.pwdlastset[0]);
$usertime
$ACCOUNTDISABLE = 0x000002

-not [bool]($user.userAccountControl[0] -band $ACCOUNTDISABLE)
$data = ${aStream};
$link = "URL=";
$path_link = $link+$data;
$user.Put("info","$path_link");
$user.SetInfo();
Start-Sleep -s 5
$user.info
$time = Get-Date -UFormat "%m / %d / %Y" | Out-String;
$time = "Disable at " + $time;
$user.Put("description","$time")
$user.SetInfo();
Start-Sleep -s 5
$user.description
$newpass=$null;
Get-Random -Count 3 -InputObject (65..90) | % {$newpass += [char]$_};
Get-Random -Count 3 -InputObject (97..122) | % {$newpass += [char]$_};
Get-Random -Count 2 -InputObject (0 .. 9) | % {$newpass += $_};
$newpass

$user.PwdLastSet = 0;$user.SetInfo();$user.SetPassword($newpass);$user.SetInfo();
$results=$searcher.findone(); $usertime=[datetime]::fromfiletime($results.properties.pwdlastset[0]); $usertime
$newExpire = (get-date).adddays(${expiration_date});$User.InvokeSet("AccountExpirationDate",$newExpire);$user.commitchanges();
$user.AccountExpirationDate
ForEach($GroupList In $user.memberOf){
    $Group = [ADSI]("LDAP://" + $GroupList)
    if ( '${default_domain_group}' -eq $Group){}
    else{
    $Group.Remove($user.ADsPath);}
}
$user.psbase.MoveTo('LDAP://OU)');
$user.Path