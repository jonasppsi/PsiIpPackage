#!/usr/bin/env python3

import os
import re
from tabulate import tabulate 
from pprint import pprint

FLAG_NEW         = 0 
FLAG_IMPORT      = 1 
FLAG_OVERWRITE   = 2 
FLAG_DEPRECATED  = 3 

flagstr = { FLAG_NEW : "new",
            FLAG_IMPORT : "import",
            FLAG_OVERWRITE : "overwrite",
            FLAG_DEPRECATED : "deprecated"}
# Config
dir_tcl = "../Test"
doc_file = "CommandRef.md"
pattern_procname = "[a-zA-Z_][a-zA-Z_0-9]*"

# ------------------------------------------
# Functions
# ------------------------------------------
def tableline():
    print(f"{10*'-':<10} {20*'-':<20} {15*'-':<15} {20*'-':<20}")

def printAllProc():
    tableline()
    print(f"{'Version':<10} {'Procedure':<20} {'Flag':<15} {'DocCmdRef':<20}")
    tableline()
    for version, data in tcl_proc.items():
        for proc in data['proclist']:
            if proc['name'] in doc_index:
                doc = proc['name']
            else:
                doc = ""
            print(f"{version:<10} {proc['name']:<20} {flagstr[proc['flag']]:<15} {doc:<20}")
        tableline()

# ------------------------------------------
# Main
# ------------------------------------------

# Get list of package tcl files:
# ------------------------------
tcl_files = {}
dirlisting = sorted(os.listdir(dir_tcl))
for fname in [f for f in dirlisting if f.lower().startswith("ippackage")]:
    match = re.search("[a-zA-Z]+_([0-9_\-]+)\.tcl", fname)
    if (match):
        tcl_files[fname] = match.group(1)

pprint(tcl_files)

doc_index = []
doc_proc = []
tcl_proc = {}

# Parse command.ref:
# -----------------------------------------------
with open(doc_file, 'r') as fdoc:
    index_section = False
    for line in fdoc:
        if(re.search(f"#+\s*Command Links", line)):
           index_section = True 
        if (index_section):
            match = re.search(f"\*.*\(\s*#({pattern_procname})\s*\)", line) 
            if (match):
                doc_index.append(match.group(1))
        ## After index has detected, continue with captions:
        #match = re.search(f"##+\s*({pattern_procname})", line) 
        #if (match):
        #    print(match.group(1))
        #    doc_proc.append(match.group(1))

pprint(doc_index)

# Filter all relevant functions from Tcl files:
# -----------------------------------------------------
for tcl_file, tcl_version in tcl_files.items():
    proc_list = []
    import_tcl_version = ""
    with open(dir_tcl+"/"+tcl_file, 'r') as f:
        for line in f:
            match = re.search(f"::PSTU::(\S+)::", line) 
            if (match):
                import_tcl_version = match.group(1)
            match = re.search(f"\s*proc\s({pattern_procname})", line) 
            # Found procedure:
            if (match):
                proc_list.append({'name': match.group(1), 'flag': FLAG_NEW})
            # Check for "deprecated" proc:
            match = re.search(f"\s*error\s+\"DEPRECATED", line) 
            if (match):
                proc_list[-1]['flag'] = FLAG_DEPRECATED
    tcl_proc[tcl_version] = {'proclist': proc_list, 'import': import_tcl_version};


# Check inheritance:
# -----------------------------------------------------
for version, data in tcl_proc.items():
    # search imported tcl:
    #print(f"* Check version: {version}:")
    if(data['import']):
        #print(f"    * Imports: {data['import']}:")
        for imported_proc in tcl_proc[data['import']]['proclist']:
            proc_found = False;
            for index, proc in enumerate(data['proclist']):
                # overwrite proc:
                if imported_proc['name'] == proc['name']:
                    flag = FLAG_OVERWRITE if proc['flag'] != FLAG_DEPRECATED else FLAG_DEPRECATED
                    data['proclist'][index]['flag'] = flag;
                    proc_found = True;
            # import proc, check if deprecated:
            if not proc_found:
                flag = FLAG_IMPORT if imported_proc['flag'] != FLAG_DEPRECATED else FLAG_DEPRECATED
                data['proclist'].append({'name': imported_proc['name'], 'flag': flag})

# Output:
# ------------------------------------------------------
printAllProc()

