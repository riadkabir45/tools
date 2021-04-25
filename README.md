# Welp! Another useless tool



sfxsh tries to bring sfx to sh. Its almost independent. as it only needs dd and made for sh.



## Manpage

```
Usage: sfxsh OPTION
Creates a script with files embedded.
  configure       Creates a workdir,
  build           Builds the workdir to script
```



### Configure

configure creates a workdir. The structure of workdir is:

```
workdir/
├── assets #Conatins filles to be embeded. Folder not supported(Use zip)
├── init #The Script to run when executed
├── out #The built scipt will be throwed here
└── tmp #A folder to use while building

```

### Build 

build will output the ready to run script in workdir/out/script.sh

Beware! The script contains files embedded. So dont open in GUI editors or might crash

### Internal Function

Currently the script only supports one function which is cpa

```
Usage: cpa ASSET_NAME WHERE_TO_COPY
Copies the asset files from embedded structure to a file system.
Though this might look like cp wrapper.But it is not.
```

