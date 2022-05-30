#!/usr/bin/env python3

import os
import re
from tabulate import tabulate 

# Config
dir_tcl = "../Test"
doc_file = "CommandRef.md"

pattern_funcname = "[a-zA-Z_][a-zA-Z_0-9]*"

# Get list of package tcl files:
tcl_files = {}
dirlisting = sorted(os.listdir(dir_tcl))
for fname in [f for f in dirlisting if f.lower().startswith("ippackage")]:
    match = re.search("[a-zA-Z]+_([0-9_\-]+)\.tcl", fname)
    if (match):
        tcl_files[fname] = match.group(1)


doc_index = []
doc_func = []
tcl_func = {}

with open(doc_file, 'r') as fdoc:
    index_section = False
    for line in fdoc:
        if(re.search(f"#+\s*Command Links", line)):
           index_section = True 
        if (index_section):
            match = re.search(f"\*.*\(\s*#({pattern_funcname})\s*\)", line) 
            if (match):
                doc_index.append(match.group(1))

        match = re.search(f"#+\s*({pattern_funcname})", line) 
        if (match):
            doc_func.append(match.group(1))

# Filter all relevant functions from Package Tcl files:
for tcl_file, tcl_version in tcl_files.items():
    func_list = []
    import_tcl_version = ""
    with open(dir_tcl+"/"+tcl_file, 'r') as f:
        for line in f:
            match = re.search(f"::PSTU::(\S+)::", line) 
            if (match):
                import_tcl_version = match.group(1)
            match = re.search(f"\s*proc\s({pattern_funcname})", line) 
            # Found function:
            if (match):
                func_list.append(match.group(1))
    tcl_func[tcl_version] = {'funclist': func_list, 'import': import_tcl_version};

# Check inheritance:
for version, data in tcl_func.items():
    if(data['import']):
        for imported_func in tcl_func[data['import']]['funclist']:
            if imported_func not in data['funclist']:
                func_list.append("=" + imported_func)


# Output:
table = {}
for version, data in tcl_func.items():
    print (f"{version}: import {data['import']} to {data['funclist']}")
    table = {}

#print(doc_index)
