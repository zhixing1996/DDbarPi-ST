#!/usr/bin/env python
"""
Apply cuts on root files
"""

__author__ = "Maoqiang JING <jingmq@ihep.ac.cn>"
__copyright__ = "Copyright (c) Maoqiang JING"
__created__ = "[2019-10-03 Tue 17:06]"

import math
from array import array
import ROOT
from ROOT import TCanvas, gStyle, TLorentzVector, TTree
from ROOT import TFile, TH1F, TLegend, TArrow, TChain, TVector3
import sys, os
import logging
from math import *
from tools import *
logging.basicConfig(level=logging.DEBUG, format=' %(asctime)s - %(levelname)s- %(message)s')

def usage():
    sys.stdout.write('''
NAME
    apply_cuts.py

SYNOPSIS
    ./apply_cuts.py [file_in] [file_out] [ecms]

AUTHOR
    Maoqiang JING <jingmq@ihep.ac.cn>

DATE
    October 2019
\n''')

def save_before(file_in, file_out, ecms):
    try:
        chain = TChain('save')
        chain.Add(file_in)
    except:
        logging.error(file_in + ' is invalid!')
        sys.exit()

    cut = ''
    width_low = 1.86965 - width(ecms)/2.
    width_up = 1.86965 + width(ecms)/2.

    cut_base = '(m_rawm_D > ' + str(width_low) + ' && m_rawm_D < ' + str(width_up) + ')'
    cut = cut_base 

    t = chain.CopyTree(cut)
    t.SaveAs(file_out)

def main():
    args = sys.argv[1:]
    if len(args)<3:
        return usage()
    file_in = args[0]
    file_out = args[1]
    ecms = int(args[2])

    print '--> Begin to process file: ' + file_in
    save(file_in, file_out, ecms)
    print '--> End of processing file: ' + file_out

if __name__ == '__main__':
    main()
