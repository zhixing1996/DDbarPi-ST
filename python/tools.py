#!/usr/bin/env python
"""
Common tools 
"""

__author__ = "SHI Xin <shixin@ihep.ac.cn>"
__copyright__ = "Copyright (c) SHI Xin"
__created__ = "[2016-06-28 Tue 09:17]" 

import sys 
import os
import shutil
import subprocess
import ROOT 


# ---------------------------------------------
# Function 
# ---------------------------------------------

def check_and_join(filepath, filename, mode=''):
    if not os.access(filepath, os.F_OK):
        sys.stdout.write('creating dir %s ...' % filepath)
        os.makedirs(filepath)
        sys.stdout.write(' OK.\n')
        
    file_ = os.path.join(filepath, filename)
    if os.access(file_, os.F_OK) :
        tmpfile = make_tmpfile(file_)
        shutil.copy2(file_, tmpfile)
        if mode == 'w':
            os.remove(file_)

    return file_

def check_outfile_path(outfile):
    path, tail = os.path.split(outfile)
    if path != '' and not os.access(path, os.F_OK) :
        sys.stdout.write('Creating dir %s ...\n'  % path)
        os.makedirs(path)


def convert_size_from_str(size_str):
    c_1GB = 1024*1024*1024
    factor = eval(size_str.split('G')[0])
    return factor*c_1GB


def duration(seconds):
    seconds = long(round(seconds))
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    days, hours = divmod(hours, 24)
    years, days = divmod(days, 365.242199)
 
    minutes = long(minutes)
    hours = long(hours)
    days = long(days)
    years = long(years)
 
    duration = []
    if years > 0:
        duration.append('%d year' % years + 's'*(years != 1))
    else:
        if days > 0:
            duration.append('%d day' % days + 's'*(days != 1))
        if hours > 0:
            duration.append('%d hour' % hours + 's'*(hours != 1))
        if minutes > 0:
            duration.append('%d minute' % minutes + 's'*(minutes != 1))
        if seconds > 0:
            duration.append('%d second' % seconds + 's'*(seconds != 1))
    return ' '.join(duration)


def group_files_by_size(name_list, size_max='20G'):
    size_max = convert_size_from_str(size_max)
    groups = []
    group = []    
    size_sum = 0

    for name in name_list:
        size = os.path.getsize(name)
        if size_sum < size_max:
            group.append(name)
            size_sum += float(size)
        else:
            groups.append(group)
            group = []
            size_sum = 0
            group.append(name)            
            size_sum += float(size)

        if name == name_list[-1]:
            groups.append(group)

    return groups

def proc_cmd(cmd, test=False, verbose=1, procdir=None, shell=False):
    if test:
        sys.stdout.write(cmd+'\n')
        return 

    # No need to add quote in the cmd! 
    cwd = os.getcwd()
    if procdir is not None:
        os.chdir(procdir)
    
    args = cmd.split()

    if isinstance(cmd, list) or shell:
        args = cmd 

    process = subprocess.Popen(args, stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT, shell=shell)
    stdout = process.communicate()[0]

    if 'error' in stdout:
        sys.stdout.write(stdout)
        
    if procdir is not None:
        os.chdir(cwd)

    return stdout


def save_list_into_file(file_list, dst):
    nfiles = len(file_list)
    
    path, tail = os.path.split(dst)
    if path != '' and not os.access(path, os.F_OK) :
        sys.stdout.write('Creating dir %s ...\n'  % path)
        os.makedirs(path)
                
    fo = open(dst, 'w')
    fo.write('EventCnvSvc.digiRootInputFile = {\n')

    n = 0
    for f in file_list:
        n = n+1
        if n<nfiles:
            fo.write('"%s",\n' % f)
        else:
            fo.write('"%s"\n};\n' % f)

    fo.close()
    sys.stdout.write('Saved as: %s\n' %dst)

    
def set_root_style(stat=0, grid=0, PadTopMargin=0.08,
                   PadLeftMargin=0.15):
    # must be used in the beginning
    ROOT.gROOT.SetBatch(1)
    ROOT.gROOT.Reset()

    ROOT.gStyle.SetOptTitle(0) 
    ROOT.gStyle.SetTitleFillColor(0) 
    ROOT.gStyle.SetTitleBorderSize(0)
    
    ROOT.gStyle.SetCanvasBorderMode(0)
    ROOT.gStyle.SetCanvasColor(0)
    ROOT.gStyle.SetCanvasDefX(0)
    ROOT.gStyle.SetCanvasDefY(0)
    ROOT.gStyle.SetFrameBorderMode(0)
    ROOT.gStyle.SetFrameBorderSize(1)
    ROOT.gStyle.SetFrameFillColor(0)
    ROOT.gStyle.SetFrameFillStyle(0)
    ROOT.gStyle.SetFrameLineColor(1)
    ROOT.gStyle.SetFrameLineStyle(1)
    ROOT.gStyle.SetFrameLineWidth(1)

    ROOT.gStyle.SetPadTopMargin(PadTopMargin) 
    ROOT.gStyle.SetPadLeftMargin(PadLeftMargin) 
    ROOT.gStyle.SetPadRightMargin(0.05) 

    ROOT.gStyle.SetLabelSize(0.02, "XYZ") 
    ROOT.gStyle.SetTitleSize(0.02, "XYZ") 
    ROOT.gStyle.SetTitleOffset(1.2, "Y") 

    ROOT.gStyle.SetPadBorderMode(0) 
    ROOT.gStyle.SetPadColor(0) 
    ROOT.gStyle.SetPadTickX(1)
    ROOT.gStyle.SetPadTickY(1)
    ROOT.gStyle.SetPadGridX(grid)
    ROOT.gStyle.SetPadGridY(grid)

    ROOT.gStyle.SetOptStat(stat)
    ROOT.gStyle.SetStatColor(0)
    ROOT.gStyle.SetStatBorderSize(1)

def luminosity(sample):
    if int(sample) == 4190:
        LUM = 526.7 + 43.33
    if int(sample) == 4200:
        LUM = 526.0
    if int(sample) == 4210:
        LUM = 517.1 + 54.95
    if int(sample) == 4220:
        LUM = 514.6 + 54.60
    if int(sample) == 4230:
        LUM = 44.54 + 1056.4
    if int(sample) == 4237:
        LUM = 530.3
    if int(sample) == 4245:
        LUM = 55.88
    if int(sample) == 4246:
        LUM = 538.1
    if int(sample) == 4260:
        LUM = 828.4
    if int(sample) == 4270:
        LUM = 531.1
    if int(sample) == 4280:
        LUM = 175.7
    if int(sample) == 4290:
        LUM = 502.4
    if int(sample) == 4310:
        LUM = 45.08
    if int(sample) == 4315:
        LUM = 501.2
    if int(sample) == 4340:
        LUM = 505.0
    if int(sample) == 4360:
        LUM = 543.9
    if int(sample) == 4380:
        LUM = 522.7
    if int(sample) == 4390:
        LUM = 55.57
    if int(sample) == 4400:
        LUM = 507.8
    if int(sample) == 4420:
        LUM = 46.8 + 1043.9
    if int(sample) == 4440:
        LUM = 569.9
    if int(sample) == 4470:
        LUM = 111.09
    if int(sample) == 4530:
        LUM = 112.12
    if int(sample) == 4575:
        LUM = 48.93
    if int(sample) == 4600:
        LUM = 586.9
    if int(sample) == 4610:
        LUM = 102.50
    if int(sample) == 4620:
        LUM = 511.06
    if int(sample) == 4640:
        LUM = 541.37
    if int(sample) == 4660:
        LUM = 528.63
    if int(sample) == 4680:
        LUM = 528.46 + 1103.27
    if int(sample) == 4700:
        LUM = 526.20
    return LUM

def ECMS(ecms):
    if int(ecms) == 4190:
        ecm = 4.18880
    if int(ecms) == 4200:
        ecm = 4.19890
    if int(ecms) == 4210:
        ecm = 4.20770
    if int(ecms) == 4220:
        ecm = 4.21710
    if int(ecms) == 4230:
        ecm = 4.22630
    if int(ecms) == 4237:
        ecm = 4.23570
    if int(ecms) == 4245:
        ecm = 4.24170
    if int(ecms) == 4246:
        ecm = 4.24380
    if int(ecms) == 4260:
        ecm = 4.25797
    if int(ecms) == 4270:
        ecm = 4.26680
    if int(ecms) == 4280:
        ecm = 4.27770
    if int(ecms) == 4290:
        ecm = 4.28788
    if int(ecms) == 4310:
        ecm = 4.30790
    if int(ecms) == 4315:
        ecm = 4.31205
    if int(ecms) == 4340:
        ecm = 4.33739
    if int(ecms) == 4360:
        ecm = 4.35826
    if int(ecms) == 4380:
        ecm = 4.37737
    if int(ecms) == 4390:
        ecm = 4.38740
    if int(ecms) == 4400:
        ecm = 4.39645
    if int(ecms) == 4420:
        ecm = 4.41558
    if int(ecms) == 4440:
        ecm = 4.43624
    if int(ecms) == 4470:
        ecm = 4.46710
    if int(ecms) == 4530:
        ecm = 4.52710
    if int(ecms) == 4575:
        ecm = 4.57450
    if int(ecms) == 4600:
        ecm = 4.59953
    if int(ecms) == 4610:
        ecm = 4.61208
    if int(ecms) == 4620:
        ecm = 4.63129
    if int(ecms) == 4640:
        ecm = 4.64366
    if int(ecms) == 4660:
        ecm = 4.66414
    if int(ecms) == 4680:
        ecm = 4.68188
    if int(ecms) == 4700:
        ecm = 4.70044
    return ecm

def param_rm_Dpi(ecms):
    MEAN_LOW = 999.
    MEAN_UP = 999.
    SIGMA_UP = 999.
    if int(ecms == 4190):
        MEAN_LOW = -0.005
        MEAN_UP = 0.0005
        SIGMA_UP = 0.002
    elif int(ecms == 4200):
        MEAN_LOW = -0.0005
        MEAN_UP = 0.0005
        SIGMA_UP = 0.001
    elif int(ecms == 4210):
        MEAN_LOW = -0.0005
        MEAN_UP = 0.0005
        SIGMA_UP = 0.001
    elif int(ecms == 4220):
        MEAN_LOW = -0.0005
        MEAN_UP = 0.0005
        SIGMA_UP = 0.002
    elif int(ecms == 4230):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.002
    elif int(ecms == 4237):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.002
    elif int(ecms == 4245):
        MEAN_LOW = -0.0015
        MEAN_UP = 0.001
        SIGMA_UP = 0.0012
    elif int(ecms == 4246):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.003
    elif int(ecms == 4260):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4270):
        MEAN_LOW = -0.0015
        MEAN_UP = 0.0015
        SIGMA_UP = 0.001
    elif int(ecms == 4280):
        MEAN_LOW = -0.0015
        MEAN_UP = 0.001
        SIGMA_UP = 0.001
    elif int(ecms == 4290):
        MEAN_LOW = -0.002
        MEAN_UP = 0.005
        SIGMA_UP = 0.01
    elif int(ecms == 4310):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.001
    elif int(ecms == 4315):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4340):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.01
    elif int(ecms == 4360):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4380):
        MEAN_LOW = -0.003
        MEAN_UP = 0.0045
        SIGMA_UP = 0.01
    elif int(ecms == 4390):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.006
    elif int(ecms == 4400):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4420):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4440):
        MEAN_LOW = -0.003
        MEAN_UP = 0.006
        SIGMA_UP = 0.008
    elif int(ecms == 4470):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4530):
        MEAN_LOW = -0.002
        MEAN_UP = 0.005
        SIGMA_UP = 0.004
    elif int(ecms == 4575):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.006
    elif int(ecms == 4600):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.008
    elif int(ecms == 4610):
        MEAN_LOW = -0.003
        MEAN_UP = 0.003
        SIGMA_UP = 0.006
    elif int(ecms == 4620):
        MEAN_LOW = -0.003
        MEAN_UP = 0.005
        SIGMA_UP = 0.006
    elif int(ecms == 4640):
        MEAN_LOW = -0.003
        MEAN_UP = 0.005
        SIGMA_UP = 0.004
    elif int(ecms == 4660):
        MEAN_LOW = -0.003
        MEAN_UP = 0.006
        SIGMA_UP = 0.008
    elif int(ecms == 4680):
        MEAN_LOW = -0.003
        MEAN_UP = 0.005
        SIGMA_UP = 0.006
    elif int(ecms == 4700):
        MEAN_LOW = -0.005
        MEAN_UP = 0.005
        SIGMA_UP = 0.006
    return MEAN_LOW, MEAN_UP, SIGMA_UP

def width(sample):
    WIDTH = 999.
    if int(sample) < 4300:
        WIDTH = 0.011*2
    elif int(sample) >= 4300 and int(sample) < 4500:
        WIDTH = 0.011*2
    if int(sample) >= 4500:
        WIDTH = 0.011*2
    return WIDTH

def search(allfile, root, target):
    items = os.listdir(root)
    for item in items:
        if item[0] == '.':
            continue
        path = os.path.join(root, item)
        if os.path.isdir(path):
            search(allfile, path, target)
        else:
            if target in path:
                allfile.append(path)
    return allfile
    
def group_files_by_num(name_list, num_total):
    groups = []
    group = []
    num_sum = 0

    for name in name_list:
        if int(num_sum) < int(num_total):
            group.append(name)
            num_sum = num_sum + 1
        else:
            groups.append(group)
            group = []
            num_sum = 0
            group.append(name)
            num_sum = num_sum + 1

        if name == name_list[-1]:
            groups.append(group)    
    return groups

# ---------------------------------------------
# Class 
# ---------------------------------------------

class UserFile(object):
    '''Class to handle file  '''
    def __init__(self, filename=None, data=None):
        self.data = []
        if data != None:
            self.data = data
            
        if filename:
            self.input(filename)
            self.file = filename

    def append(self, content):
        self.data.append(content)

    def input(self, filename, verbose=0):
        fi = open(filename, 'r')
        for line in fi:
            self.data.append(line)
        fi.close()

    def input_data(self, data):
        self.data = data
        
        
class BossLogFile(UserFile):
    "Handle BOSS log file"

    def __init__(self, filename=None):
        self.terminated = False
        UserFile.__init__(self, filename)
        self.parse()
        
    def parse(self):
        "parse BOSS log file" 
        line_no = -1
        for line in self.data:
            line_no += 1
            line = line.strip()
            if 'INFO Application Manager Terminated successfully' in line:
                self.terminated = True

class EventsLogFile(UserFile):
    "Handle Events log file"

    def __init__(self, filename=None):
        self.terminated = False
        UserFile.__init__(self, filename)
        self.parse()
        
    def parse(self):
        "parse Events log file" 
        line_no = -1
        for line in self.data:
            line_no += 1
            line = line.strip()
            if 'Done ' in line:
                self.terminated = True
