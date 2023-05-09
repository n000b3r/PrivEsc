# Name
AccessChk

## Usage
```
accesschk.exe /accepteula
accesschk -ucqv <service name>
accesschk.exe -uwcqv "Authenticated Users" *

#Find all weak folder permissions per drive.
accesschk.exe -uwdqs Users c:\
accesschk.exe -uwdqs "Authenticated Users" c:\

#Find all weak file permissions per drive.
accesschk.exe -uwqs Users c:\*.*
accesschk.exe -uwqs "Authenticated Users" c:\*.*
```

## Source
https://web.archive.org/web/20080530012252/http://live.sysinternals.com/accesschk.exe

