#!/usr/bin/python

'''
        Copyright (c) 2013 Samsung Electronics Co., Ltd.

        This software is licensed under the terms of the GNU General Public
        License version 2, as published by the Free Software Foundation, and
        may be copied, distributed, and modified under those terms.

        Authors:
            David Seunghan Kim(hyenakim@samsung.com)

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'''

import os, sys, re, time

def usage():
    print('')
    print('Usage: \x1b[1mlogviewer.py [<cmd> [<cmd_arg>]]... [<pattern>[:<color inform>]]...\x1b[0m')
    print('')
    print('\x1b[1;4m[<cmd> and <cmd_arg>]\x1b[0m...')
    print('    -f <filename>')
    print('       Coloring the message in the specified file')
    print('    -c <shell_command>')
    print('       Coloring the ourput of executing the specified shell command')
    print('       This is useful for coloring of "make" or "build.sh" command')
    print('    -d')
    print('       Coloring the output of "\x1b[7madb shell dmesg\x1b[0m"')
    print('    -k')
    print('       Coloring the output of "\x1b[7madb shell cat /proc/kmsg\x1b[0m"')
    print('    -l')
    print('       Coloring the output of "\x1b[7madb shell logcat\x1b[0m"')
    print('    -s <adb_device_id>')
    print('       (Optional) Specify the device ID(16 hex digit) for the specific ADB device')
    print('    -p <pattern_desc_file>')
    print('       Specify the pattern description file which contains the colored pattern')
    print('       See below in more detail')
    print('    -t')
    print('       Test for pattern color')
    print('    -h')
    print('       Display this usage')
    print('')
    print('[\x1b[1;4m<pattern>[:<color inform>]]\x1b[0m...')
    print('<pattern>')
    print('       Specify string which is displayed with colors which you want')
    print('       <pattern> should be enclosed with double quato. (e.g. "error:")')
    print('<color inform> => "<pattern>":<fg>:<br>:<br>:<bo>:<un>:<re>')
    print('       fg=0..7 : Foregound color. Refer to the <value of color>')
    print('       bg=0..7 : Backgound color. Refer to the <value of color>')
    print('       br=0,1  : \x1b[2mBright\x1b[0m.')
    print('       bo=0,1  : \x1b[1mBold\x1b[0m.')
    print('       un=0,1  : \x1b[4mUnderline\x1b[0m.')
    print('       re=0,1  : \x1b[7mReverse\x1b[0m.')
    print('<value of color>')
    print('       0: BLACK, 1: RED,     2: GREEN, 3: YELLOW')
    print('       4: BLUE,  5: MAGENTA, 6: CYAN,  7: WHITE')
    print('<example of <pattern> and <color inform>')
    print('       $ logviewer.py -c "./build.sh smdk3470 all" "error:":1:3:1:1:0:0')
    print('       ...')
    print('       nos/libcsc/csc.c:797: \x1b[91;103;1merror:\x1b[0m undefined reference to \'exynos_gsc')
    print('       ...')
    print('       => In output of "build.sh" command, the string("error:") will be colored like the above')
    print('       => fg = RED, bg = YELLOW, Bright = True, Bold = True')
    print('')
    print('\x1b[1;4m<pattern_desc_file>\x1b[0m')
    print('       You can easily use the pre-defined coloring pattern with a file.')
    print('       The syntax used in this file is similar <pattern> and <color info>')
    print('Syntax:')
    print('       pattern="<pattern>",fg=<color>,bg=<color>,br=<bool>,bo=<bool>,un=<bool>,re=<bool>')
    print('       where:')
    print('           <color> : 0..7 : BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE')
    print('           <bool>  : 0, 1, true, false')
    print('')

BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)
ColorString = ['BLACK', 'RED', 'GREEN', 'YELLOW', 'BLUE', 'MAGENTA', 'CYAN', 'WHITE']
ColorValue  = ['0', '1', '2', '3', '4', '5', '6', '7']
MapColorFromString = { 'BLACK': '0', 'RED': '1', 'GREEN': '2', 'YELLOW': '3', 'BLUE': '4', 'MAGENTA': '5', 'CYAN': '6', 'WHITE': '7'}
MapColorFromValue  = { '0': 'BLACK', '1': 'RED', '2': 'GREEN', '3': 'YELLOW', '4': 'BLUE', '5': 'MAGENTA', '6': 'CYAN', '7': 'WHITE'}

def format(fg=None, bg=None, bright=False, bold=False, underline=False, reverse=False, reset=False):
    codes = []
    if reset:
        codes.append("0")
    else:
        if not bright:
            if not fg is None: codes.append("3%d" % (fg))
            if not bg is None: codes.append("4%d" % (bg))
        else:
            if not fg is None: codes.append("9%d" % (fg))
            else: codes.append("99")
            if not bg is None: codes.append("10%d" % (bg))
            else: codes.append("109")
        if bold: codes.append("1")
        if underline: codes.append("4")
        if reverse: codes.append("7")
        if len(codes) == 0: codes.append("22")
    return "\033[%sm" % (";".join(codes))


def checking_of_connecting_adb(DevId = None):
    input = os.popen('adb devices 2>&1')
    line = input.readline()
    if cmp(line, "List of devices attached \n"):
        print ('Android SDK was not installed this machine. Please install this first')
        sys.exit()
    line = input.readline()
    while True:
        if line == '': break
        if not cmp(line, '\n'): break
        if DevId is None: return
        line = line[0:16]
        if not cmp(line, DevId.upper()): return
        line = input.readline()

    print('- waiting for device -')
    while True:
        try:
            input = os.popen('adb devices 2>&1')
            line = input.readline()
            line = input.readline()
            while True:
                if line == '': break
                if not cmp(line, '\n'): break
                if DevId is None: return
                line = line[0:16]
                if not cmp(line, DevId.upper()): return
                line = input.readline()
            time.sleep(1)
        except KeyboardInterrupt:
            print('')
            sys.exit()
    return
 
def get_input(CmdType, CmdArg = None, DevId = None):
    if CmdType == CMD_FILE:
        if CmdArg is None: 
            print('[Error] Invalid command argument. Couldn\'t found <filename>')
            sys.exit() 
        print('Input: filename = %s' % CmdArg)
        try:
            return open(CmdArg, 'r')
        except:
            print('[Error] Can\'t open file: "%s"' % CmdArg)
            sys.exit()

    if CmdType == CMD_SHELL:
        if CmdArg is None: 
            print('Invalid command argument. Couldn\'t found <shell_command>')
            sys.exit() 
        try:
            return os.popen(CmdArg + ' 2>&1')    
        except:
            print('[Error] Can\'t execute the shell command: "%s"' % CmdArg)
            sys.exit()

    cmd = None
    if DevId is None: cmd = 'adb shell'
    else:             cmd = 'adb -s %s shell' % DevId

    if   CmdType == CMD_DMESG:    cmd = cmd + ' dmesg'
    elif CmdType == CMD_CAT_KMSG: cmd = cmd + ' cat /proc/kmsg'
    elif CmdType == CMD_LOGCAT:   cmd = cmd + ' logcat'
    else:
        print('Invalid command type: %d' % CmdType)
        usage()
        sys.exit()
    if not cmd is None:
        print('Command: "\x1b[1m%s\x1b[0m"' % cmd)
        checking_of_connecting_adb(DevId)
        return os.popen(cmd + ' 2>&1')
    else:
        return None

def insert_pattern_into_table(pattern, fg, bg, br, bo, un, re):
    global PatternTable
    global PatternCount

    for i in range(PatternCount):
        min_len = min(len(PatternTable[i][0]), len(pattern))
        if not cmp(PatternTable[i][0][:min_len], pattern[:min_len]):
            print('[Warning] Ignore "%s" pattern due to the new one' % PatternTable[i][0])
            PatternTable[i] = [pattern, fg, bg, br, bo, un, re, '%s%s%s' % (format(fg,bg,br,bo,un,re), pattern, format(reset = True))]
            return

    PatternTable[PatternCount] = [pattern, fg, bg, br, bo, un, re, '%s%s%s' % (format(fg,bg,br,bo,un,re), pattern, format(reset = True))]
    PatternCount = PatternCount + 1
    return

def parse_pattern_arguement(Buffer = None):
    pattern = None
    fg = None
    bg = None
    br = '0'
    bo = '0'
    un = '0'
    ne = '0'

    while True:
        if Buffer is None: break

        exp = "(.*):([0-9]):([0-9]):([01]):([01]):([01]):([01])$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern, fg, bg, br, bo, un, ne = match.groups()
            break

        exp = "(.*):([0-9]):([0-9]):([01]):([01]):([01])$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern, fg, bg, br, bo, un = match.groups()
            break

        exp = "(.*):([0-9]):([0-9]):([01]):([01])$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern, fg, bg, br, bo = match.groups()
            break

        exp = "(.*):([0-9]):([0-9]):([01])$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern, fg, bg, br = match.groups()
            break

        exp = "(.*):([0-9]):([0-9])$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern, fg, bg = match.groups()
            break

        exp = "(.*):([0-9])$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern, fg = match.groups()
            break

        exp = "(.*)$"
        rep = re.compile(exp)
        match = rep.match(Buffer)
        if not match is None:
            pattern = match.groups()
            break
        break

    if not fg is None: fg = int(fg)
    if not bg is None: bg = int(bg)
    if int(br): br = True
    else:       br = False
    if int(bo): bo = True
    else:       bo = False
    if int(un): un = True
    else:       un = False
    if int(ne): ne = True
    else:       ne = False

    if not pattern is None:
        insert_pattern_into_table(pattern, fg, bg, br, bo, un, ne)
    return

def parse_pattern_desc_file(DescFile = None):
    if DescFile is None: return
    try:
        f = open(DescFile, 'r')
    except:
        print('Cannot open <pattern_desc_file>: "%s"' % DescFile)
        print('=' * 80)
        sys.exit();
    while True:
        pattern   = None
        fg = None
        bg = None
        br = False
        bo = False
        un = False
        ne = False

        line = f.readline()
        if line == '': break
        if line == '\n': continue
        if line[0] == '#': continue

        pos = line.rfind('"')
        if pos == -1: continue

        subline = line[:pos]
        (lvalue, rvalue) = subline.split('=')
        if cmp(lvalue[:len('pattern')].lower(), 'pattern'):
            print('Invalid line: "%s"' % line)
            continue
        rvalue = rvalue[rvalue.find('"')+1:]
        if len(rvalue): pattern = rvalue

        line = line[pos+1:].replace(' ','')
        for subline in line.split(','):
            if subline == '': continue
            (lvalue, rvalue) = subline.split('=')
            if not cmp(lvalue[:2].lower(), 'fg'):
                if rvalue.upper() in ColorString:
                    fg = int(MapColorFromString[rvalue.upper()])
                if rvalue.upper() in ColorValue:
                    fg = int(MapColorFromValue[rvalue.upper()])
            if not cmp(lvalue[:2].lower(), 'bg'):
                if rvalue.upper() in ColorString:
                    bg = int(MapColorFromString[rvalue.upper()])
                if rvalue.upper() in ColorValue:
                    bg = int(MapColorFromValue[rvalue.upper()])
            else:
                value = False
                if rvalue.upper() in ['TRUE', 'FALSE']:
                    if not cmp(rvalue.upper(), 'TRUE'): value = True
                else:
                   if rvalue[0] == '1': value = True
                if   not cmp(lvalue[:2].lower(), 'br'): br = value 
                elif not cmp(lvalue[:2].lower(), 'bo'): bo = value 
                elif not cmp(lvalue[:2].lower(), 'un'): un = value 
                elif not cmp(lvalue[:2].lower(), 're'): ne = value 

        if not pattern is None:
            insert_pattern_into_table(pattern, fg, bg, br, bo, un, ne)
    return

def change_color(color, prompt):
    print('[0] BLACK, [1] RED, [2] GREEN, [3] YELLOW, [4] BLUE, [5] MAGENTA, [6] CYAN, [7] WHITE')
    try:
        c = raw_input(prompt)
    except KeyboardInterrupt:
        print('')
        return color

    if c >= '0' and c <= '9':
        return int(c)
    return color

def change_value(value, prompt):
    print('[0] False, [1] True')
    try:
        v = raw_input(prompt)
    except KeyboardInterrupt:
        print('')
        return value

    if v >= '0' and v <= '1':
        if int(v): return True
        else     : return False
    return value

def do_color_test():
    fg = WHITE
    bg = BLACK
    br = False
    bo = False
    un = False
    re = False
    while True:
        print("-" * 60)
        print('"%sThis is a colored text%s"' % (format(fg, bg, br, bo, un, re), format(reset=True)))
        print('      fg=%s(%d),bg=%s(%d),br=%s,bo=%s,un=%s,re=%s' % (ColorString[fg],fg,ColorString[bg],bg,br,bo,un,re))
        print("-" * 60)
        print('[1] foreground, [2] background, [3] bright, [4] bold, [5] underline, [6] reverse, [0] reset')
        try:
            item = raw_input('Select change item[1~6, 0:reset] : ')
        except KeyboardInterrupt:
            print('')
            break
        except:
            print ('%sInvlaid item. Select agin%s' % (format(bold=True), format(reset=True)))
            continue

        if item == '0':
            fg = WHITE
            bg = BLACK
            br = False
            bo = False
            un = False
            re = False
        elif item == '1':
            fg = change_color(fg, '[%s] Select new Foreground Color[0~7] : ' % ColorString[fg])
        elif item == '2':
            bg = change_color(bg, '[%s] Select new Boreground Color[0~7] : ' % ColorString[bg])
        elif item == '3':
            br = change_value(br, '[%s] Change Bright value[0~1] : ' % br)
        elif item == '4':
            bo = change_value(bo, '[%s] Change Bold value[0~1] : ' % bo)
        elif item == '5':
            un = change_value(un, '[%s] Change Underline value[0~1] : ' % un)
        elif item == '6':
            re = change_value(re, '[%s] Change Reverse value[0~1] : ' % re)
        else:
            print ('%sInvlaid item. Select agin%s' % (format(bold=True), format(reset=True)))
            continue

    sys.exit()

# Start main function
if len(sys.argv) <= 1:
    usage()
    sys.exit()

PatternTable = {}
PatternCount = 0

CMD_NONE, CMD_FILE, CMD_SHELL, CMD_DMESG, CMD_CAT_KMSG, CMD_LOGCAT, CMD_DEV_ID, CMD_DESC_FILE, CMD_TEST, CMD_HELP = range(10)
MapCmdType = {'f': CMD_FILE, 'c': CMD_SHELL, 'd': CMD_DMESG, 'k': CMD_CAT_KMSG, 'l': CMD_LOGCAT, 's': CMD_DEV_ID, 'p': CMD_DESC_FILE, 't': CMD_TEST, 'h': CMD_HELP}

patterns = []
command  = CMD_NONE
cmd_type = CMD_NONE
cmd_arg  = None
dev_id   = None
desc_file= None

cur_idx  = 0
cur_arg  = 1
while True:
    if cur_arg >= len(sys.argv): break

    arg = sys.argv[cur_arg]
    cur_arg = cur_arg + 1

    if arg[0] == '-':
        try:
            cmd_type = MapCmdType[arg[1].lower()]
        except:
            cmd_type = CMD_NONE
            print('Invalid command type: "%s"' % arg)
            sys.exit()
        if   cmd_type == CMD_FILE:
            command = cmd_type
            if cur_arg == len(sys.argv) or sys.argv[cur_arg][0] == '-':
                print('[Error] Missing <filename> after "-f"')
                sys.exit()
            cmd_arg = sys.argv[cur_arg]
            cur_arg = cur_arg + 1
        elif cmd_type == CMD_SHELL:
            command = cmd_type
            if cur_arg == len(sys.argv) or sys.argv[cur_arg][0] == '-':
                print('[Error] Missing <shell_command> after "-c"')
                sys.exit()
            cmd_arg = sys.argv[cur_arg]
            cur_arg = cur_arg + 1
        elif cmd_type == CMD_DMESG:
            command = cmd_type
        elif cmd_type == CMD_CAT_KMSG:
            command = cmd_type
        elif cmd_type == CMD_LOGCAT:
            command = cmd_type
        elif cmd_type == CMD_DEV_ID:
            if cur_arg == len(sys.argv) or sys.argv[cur_arg][0] == '-':
                print('[Error] Missing <adb_device_id> after "-s"')
                sys.exit()
            dev_id    = sys.argv[cur_arg]
            cur_arg   = cur_arg + 1
            cmd_type  = CMD_NONE
        elif cmd_type == CMD_DESC_FILE:
            if cur_arg == len(sys.argv) or sys.argv[cur_arg][0] == '-':
                print('[Error] Missing <pattern_desc_file> after "-p"')
                sys.exit()
            desc_file = sys.argv[cur_arg]
            cur_arg   = cur_arg + 1
            cmd_type  = CMD_NONE
        elif cmd_type == CMD_TEST:
            do_color_test()
        elif cmd_type == CMD_HELP:
            usage()
            sys.exit()
    else:
        patterns.append(arg)
        cur_idx = cur_idx + 1

if not desc_file is None: parse_pattern_desc_file(desc_file)
else: parse_pattern_arguement('error::1:3:1:1:0:0')

for i in range(len(patterns)):
    parse_pattern_arguement(patterns[i])

print('='*60)
for i in range(PatternCount):
    if PatternTable[i][1] is None: fg = 'None'
    else: fg = ColorString[PatternTable[i][1]]
    if PatternTable[i][2] is None: bg = 'None'
    else: bg = ColorString[PatternTable[i][2]]

    print('Pattern: "%s"' % PatternTable[i][0])
    print('    => Foreground: %s, Background: %s' % (fg, bg))
    print('    => Bright: %s, Bold: %s, Underline: %s, Reverse: %s' %(PatternTable[i][3], PatternTable[i][4], PatternTable[i][5], PatternTable[i][6]))
    print('    => %s' % PatternTable[i][7])
print('='*60)

if command is CMD_NONE:
    print('[Error] the execured command is not specified')
    sys.exit()

input = get_input(command, cmd_arg, dev_id)

while True:
    line = None
    try:
        line = input.readline()
    except KeyboardInterrupt:
        print('')
        break

    if line is None: continue
    if line == '': break

    for i in range(PatternCount):
        try:
            line = line.replace(PatternTable[i][0], PatternTable[i][7])
        except:
            pass

    print line,
