#!/usr/bin/env python
"""
Calculate significance and efficiency
"""

__author__ = "Maoqiang JING <jingmq@ihep.ac.cn>"
__copyright__ = "Copyright (c) Maoqiang JING"
__created__ = "[2019-10-13 Thu 00:14]"

import ROOT
from ROOT import TCanvas, gStyle
from ROOT import TFile, TH1F, TLegend, TPaveText
import sys, os
import logging
from math import *
from tools import *
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s- %(message)s')
gStyle.SetOptTitle(0)
gStyle.SetOptTitle(0)

def readN(f_path):
    with open(f_path, 'r') as f:
        for line in f.readlines():
            fargs = map(float, line.strip().split())
    return fargs

def xs(sample, patch, path):
    '''
    Efficiency
    '''
    fargs = readN(path[0])
    N_data, Err_data = fargs[0], fargs[1]

    fargs = readN(path[1])
    N_MC = fargs[0]

    eff = N_MC/100000.

    '''
    ISR_D1_2420, VP, lum, Br
    '''
    xs, xserr, ISR, VP, lum, Br = 0., 0., 0, 1., 1., 0.0938
    ISR_PATH = './txts/factor_info_' + str(sample) + '_DDPI_' + patch + '.txt '
    fargs = readN(ISR_PATH[0])
    ISR = fargs[0]
    VP = fargs[1]
    lum = luminosity(sample)

    '''
    xs calculation
    '''
    xs = N_data/(2*eff*ISR*VP*Br*lum)
    xserr = Err_data/(2*eff*ISR*VP*Br*lum)

    '''
    Output
    '''
    if not os.path.exists('./txts/'):
        os.makedirs('./txts/')

    path_xs = './txts/xs_info_' + str(sample) + '_' + patch + '.txt'
    f_xs = open(path_xs, 'w')
    out = '@' + str(sample) + 'MeV\n'
    out += str(int(N_data)) + ' $\pm$ ' + str(int(Err_data)) + '\n'
    out += str(round(eff*100, 2)) + '\%\n'
    out += str(round(ISR, 2)) + '\n' 
    out += str(round(VP, 2)) + '\n'
    out += str(Br*100) + '\%\n'
    out += str(lum) + '\n'
    out += str(round(xs, 2)) + ' $\pm$ ' + str(round(xs_err, 2)) + '\n'
    f_xs.write(out)
    f_xs.close()

    path_xs_read = './txts/xs_info_' + str(sample) + '_read_' + patch + '.txt'
    f_xs_read = open(path_xs_read, 'w')
    out_read = str(sample) + ' '
    out_read += str(int(N_data)) + ' ' + str(int(Err_data)) + ' '
    out_read += str(round(eff*100, 2)) + ' '
    out_read += str(round(ISR, 2)) + ' '
    out_read += str(round(VP, 2)) + ' '
    out_read += str(lum) + ' ' 
    out_read += str(Br*100) + ' '
    out_read += str(round(xs, 2)) + ' '
    out_read += str(round(xs_err, 2)) + ' '
    out_read += '\n'
    f_xs_read.write(out_read)
    f_xs_read.close()

if __name__ == '__main__':
    try:
        args = sys.argv[1:]
        sample = int(args[0])
        patch = args[1]
    except:
        logging.error('python cal_xs.py [sample] [patch]')
        sys.exit()

    path = []
    path.append('./txts/data_events_' + str(sample) + '_' + patch + '.txt')
    path.append('./txts/MC_events_' + str(sample) + '_' + patch + '.txt')
    xs(sample, patch, path)
