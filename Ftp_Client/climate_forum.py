#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, socket
import re, string, datetime, time
import readline
from ftplib import FTP

class Completer(object):
    def __init__(self):
        self.commands = ['ls', 'cd', 'download', 'upload', 'rename', 'mkdir', 'rm']
        self.re_space = re.compile('.*\s+$', re.M)
        self.dic_file = []
        self.dic_dir = []

    def _listdir(self, root):
        "List directory 'root' appending the path separator to subdirs."
        res = []
        for name in os.listdir(root):
            path = os.path.join(root, name)
            if os.path.isdir(path):
                name += os.sep
            res.append(name)
        return res

    def _complete_path(self, path=None):
        "Perform completion of filesystem path."
        if not path:
            return self._listdir('.')
        dirname, rest = os.path.split(path)
        tmp = dirname if dirname else '.'
        res = [os.path.join(dirname, p)
                for p in self._listdir(tmp) if p.startswith(rest)]
        # more than one match, or single match which does not exist (typo)
        if len(res) > 1 or not os.path.exists(path):
            return res
        # resolved to a single directory, so return list of files below it
        if os.path.isdir(path):
            return [os.path.join(path, p) for p in self._listdir(path)]
        # exact file match terminates this completion
        return [path + ' ']

    def _complete_dic_all(self, arg=None):
        "read from self.dic and match the arg, return the matchs."
        if not arg:
            return (self.dic_dir + self.dic_file)
        else:
            arg_match = re.compile(arg)
            return [name for name in (self.dic_dir + self.dic_file) if arg_match.match(name)]

    def _complete_dic_dir(self, arg=None):
        if not arg:
            return self.dic_dir
        else:
            arg_match = re.compile(arg)
            return [name for name in self.dic_dir if arg_match.match(name)]

    def _complete_dic_file(self, arg=None):
        if not arg:
            return self.dic_file
        else:
            arg_match = re.compile(arg)
            return [name for name in self.dic_file if arg_match.match(name)]

    def complete_ls(self, args):
        if not args:
            return self._complete_dic_dir()
        else:
            return self._complete_dic_dir(args[0])

    def complete_cd(self, args):
        if not args:
            return self._complete_dic_dir()
        else:
            return self._complete_dic_dir(args[0])

    def complete_download(self, args):
        if not args:
            return self._complete_dic_all()
        elif len(args) == 1:
            return self._complete_dic_all(args[0])
        elif len(args) == 2:
            return self._complete_path(args[1])
        else:
            return []

    def complete_upload(self, args):
        if not args:
            return self._complete_path('.')
        elif len(args) == 1:
            return self._complete_path(args[0])
        elif len(args) == 2:
            return self._complete_dic_dir(args[1])
        else:
            return []

    def complete_rename(self, args):
        if not args:
            return self._complete_dic_all()
        elif len(args) == 1:
            return self._complete_dic_all(args[0])
        else:
            return []

    def complete_rm(self, args):
        if not args:
            return self._complete_dic_all()
        elif len(args) == 1:
            return self._complete_dic_all(args[0])
        else:
            return []

    def complete(self, text, state):
        "Generic readline completion entry point."
        buffer = readline.get_line_buffer()
        line = readline.get_line_buffer().split()
        # show all commands
        if not line:
            return [c + ' ' for c in self.commands][state]
        # account for last argument ending in a space
        if self.re_space.match(buffer):
            line.append('')
        # resolve command to the implementation function
        cmd = line[0].strip()
        if cmd in self.commands:
            impl = getattr(self, 'complete_%s' % cmd)
            args = line[1:]
            if args:
                return (impl(args) + [None])[state]
            return [cmd + ' '][state]
        results = [c + ' ' for c in self.commands if c.startswith(cmd)] + [None]
        return results[state]

class FtpClient(object):
    def __init__(self, host, user, passwd, remotedir, port=21):
        self.hostaddr = host
        self.username = user
        self.password = passwd
        self.remotedir  = remotedir           
        self.port     = port
        self.ftp      = FTP()
        self.file_list = []  
        self.dir_list = []

    def __del__(self):
        self.ftp.close()

    def login(self):
        ftp = self.ftp
        try:
            timeout = 300
            socket.setdefaulttimeout(timeout)
            ftp.set_pasv(True)
            ftp.connect(self.hostaddr, self.port)
            print('Connect Success %s' %self.hostaddr)
            ftp.login(self.username, self.password)
            print('Login Success %s' %self.hostaddr)
            print(ftp.getwelcome())
        except Exception as e:
            print("Connect Error or Login Error")
        try:
            ftp.cwd(self.remotedir)
        except Exception as e:
            print('Change Directory Error')

    def ls_dir(self, remotedir='./'):
        try:
            self.dir_list, self.file_list = [], []
            self.ftp.dir(remotedir, self.get_file_dir_list)
            output = ['\033[1;35;40m', 'Directory list:', '\033[1;34;40m'] + \
                     [i[0] for i in self.dir_list] + \
                     ['\033[1;35;40m', 'File list:', '\033[1;32;40m'] + \
                     [i[0]+' size:'+i[1]+'MB' for i in self.file_list] + ['\033[0m']
            for i in output:
                print(i)
        except Exception as e:
            print('no such dir')

    def mk_dir(self, remotedir='./'):
        try:
            self.ftp.mkd(remotedir)
        except Exception as e:
            print('Directory Exists %s' %remotedir)

    def cd_dir(self, remotedir):
        try:
            self.ftp.cwd(remotedir)
        except Exception as e:
            print('Change Directory Error')

    def get_file_dir_list(self, line):
        line_split = line.split()
        Type = line_split[0][0]
        Name = line_split[8]
        Size = '%.2f'%(float(line_split[4])/1024./1024.)
        file_arr = [Type, Name, Size]
        if Type == 'd':
            self.dir_list.append([Name, Size])
        elif Type == '-':
            self.file_list.append([Name, Size])
        else :
            pass

    def is_same_size(self, localfile, remotefile):
        try:
            remotefile_size = self.ftp.size(remotefile)
        except Exception as e:
            remotefile_size = -1
        try:
            localfile_size = os.path.getsize(localfile)
        except Exception as e:
            localfile_size = -1
        print('filename:%s  local:%d  remote:%d' \
                %(remotefile, localfile_size, remotefile_size),)
        if remotefile_size == localfile_size:
            return 1
        else:
            return 0

    def download_file(self, remotefile, localdir='./'):
        if not os.path.isdir(localdir):
            os.makedirs(localdir)
        localfile = os.path.join(localdir, remotefile.split('/')[-1])
        if self.is_same_size(localfile, remotefile):
            return
        else:
            with open(localfile, 'wb') as file_handler:
                self.ftp.retrbinary('RETR %s' %remotefile, file_handler.write)

    def download_files(self, remotedir='./', localdir='./'):
        try:
            self.ftp.cwd(remotedir)
        except Exception as e:
            return
        if not os.path.isdir(localdir):
            os.makedirs(localdir)
        self.dir_list, self.file_list = [], []
        self.ftp.dir(self.get_file_dir_list)
        dirlist, filelist = self.dir_list, self.file_list
        for Name in  [i[0] for i in dirlist]:
            self.download_files(Name, os.path.join(localdir, Name))
        for Name in  [i[0] for i in filelist]:
            self.download_file(Name, localdir)
        self.ftp.cwd('..')  

    def upload_file(self, localfile, remotedir='./'):
        if not os.path.isfile(localfile):
            print('local file not exist')
            return
        self.mk_dir(remotedir)
        remotefile = os.path.join(remotedir, localfile.split('/')[-1])
        if self.is_same_size(localfile, remotefile):
            return
        else:
            with open(localfile, 'rb') as file_handler:
                self.ftp.storbinary('STOR %s' %remotefile, file_handler)

    def upload_files(self, localdir='./', remotedir = './'):
        if not os.path.isdir(localdir):
            return
        self.mk_dir(remotedir)
        self.ftp.cwd(remotedir)
        for item in os.listdir(localdir):
            loc = os.path.join(localdir, item)
            if os.path.isdir(loc):
                self.upload_files(loc, item)
            else:
                self.upload_file(loc, './')
        self.ftp.cwd('..')

    def rm_dir(self, remotedir):
        try:
            self.ftp.cwd(remotedir)
        except Exception as e:
            return
        self.dir_list, self.file_list = [], []
        self.ftp.dir(self.get_file_dir_list)
        dirlist, filelist = self.dir_list, self.file_list
        if dirlist:
            for Name in  [i[0] for i in dirlist]:
                self.rm_dir(Name)
        if filelist:
            for Name in  [i[0] for i in filelist]:
                self.ftp.delete(Name)
        self.ftp.cwd('..')  
        self.ftp.rmd(remotedir)


if __name__ == '__main__':
    # set the completer
    comp = Completer()
    # we want to treat '/' as part of a word, so override the delimiters
    readline.set_completer_delims(' \t\n;')
    readline.parse_and_bind("tab: complete")
    readline.set_completer(comp.complete)

    # ftp
    host = 'climateserver.3322.org'
    user = 'climateforum'
    passwd = 'cf2016'
    remotedir = '/home/climateforum/public_html'
    fc = FtpClient(host, user, passwd, remotedir)
    fc.login()
    while True:
        fc.remotedir = fc.ftp.pwd()
        fc.dir_list, fc.file_list = [], []
        fc.ftp.dir(fc.get_file_dir_list)
        comp.dic_dir, comp.dic_file = \
                [i[0] for i in fc.dir_list], [i[0] for i in fc.file_list]
        commands = raw_input(fc.ftp.pwd()+' >>> ')
        if not commands:
            continue
        command_list = commands.split()
        cmd = command_list[0]
        if cmd == 'exit':
            break
        else:
            if cmd == 'ls':
                if len(command_list) > 1:
                    fc.ls_dir(command_list[1])
                else:
                    fc.ls_dir()
            elif cmd == 'cd':
                if len(command_list) > 1:
                    fc.cd_dir(command_list[1])
                else:
                    print('please input argument ')
                    continue
            elif cmd == 'download':
                if len(command_list) > 1:
                    down_obj = command_list[1]
                    localdir = command_list[2] if len(command_list) > 2 else './'
                    fc.dir_list, fc.file_list = [], []
                    fc.ftp.dir(fc.get_file_dir_list)
                    if down_obj in [i[0] for i in fc.dir_list]:
                        fc.download_files(down_obj, os.path.join(localdir, down_obj))
                    elif down_obj in [i[0] for i in fc.file_list]:
                        fc.download_file(down_obj, localdir)
                    else:
                        print('there is no such file or dir')
                        continue
                else:
                    print('please input argument ')
                    continue
            elif cmd == 'upload':
                if len(command_list) > 1:
                    up_obj = command_list[1]
                    remotedir = command_list[2] if len(command_list) > 2 else './'
                    if os.path.isdir(up_obj):
                        obj_name = up_obj.split('/')[-2] if up_obj[-1] == '/' else up_obj.split('/')[-1]
                        fc.mk_dir(remotedir)
                        fc.cd_dir(remotedir)
                        fc.upload_files(up_obj, obj_name)
                    elif os.path.isfile(up_obj):
                        fc.upload_file(up_obj, remotedir)
                    else:
                        print('there is no such file or dir')
                        continue
                else:
                    print('please input argument ')
                    continue
            elif cmd == 'rename':
                if len(command_list) >= 3:
                    try:
                        fc.ftp.rename(command_list[1], command_list[2])
                    except Exception as e:
                        print('error')
                        continue
                else:
                    print('please input argument')
                    continue
            elif cmd == 'mkdir':
                if len(command_list) >= 2:
                    fc.mk_dir(command_list[1])
                else:
                    print('please input argument')
                    continue
            elif cmd == 'rm':
                if len(command_list) >= 2:
                    rm_obj = command_list[1]
                    fc.dir_list, fc.file_list = [], []
                    fc.ftp.dir(fc.get_file_dir_list)
                    if rm_obj in [i[0] for i in fc.dir_list]:
                        fc.rm_dir(rm_obj)
                    elif rm_obj in [i[0] for i in fc.file_list]:
                        fc.ftp.delete(rm_obj)
                    else:
                        continue
                else:
                    print('please input argument')
                    continue
            else:
                continue
    del fc
