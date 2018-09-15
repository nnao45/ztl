<div align="center">
  <img src="https://github.com/nnao45/ztl/blob/master/ztl-logo.png" width="200px">
</div>

# ztl
zsh with tmux logging while some command doing.

## Demo

<img src="https://github.com/nnao45/naoGifRepo/blob/master/ztl04.gif">

## Usage

Basic Using

```
$ ztl <command> ...
```

Basic Using with ssh

```
$ ztl ssh <host> ...
```

And Option

```
Usage:
     ztl [<option>] [command]

Options:
    --maxfilecount [int], -m [int]   ztl save filename numbers
    --logdir [path], -d [path]       ztl save dirctory path
    --version, -v                    print ztl version
    --help, -h                       print this
```

## Install

### Zplug

write zshrc

```
zplug "nnao45/ztl", use:'src/_*' 
```

### Source Install

Download Repo

```
$ mkdir ${HOME}/.ztl
$ git clone https://github.com/nnao45/ztl.git ${HOME}/.ztl/
```

write zshrc

```
$ echo 'source ${HOME}/.ztl/src/_*' >> ${HOME}/.zshrc
```

## Writer & License
pexpo was writed by nnao45 (WORK:Infrastructure Engineer, Twitter:@A_Resas, MAIL:n4sekai5y@gmail.com).  
This software is released under the GPLv2 License, see LICENSE.
