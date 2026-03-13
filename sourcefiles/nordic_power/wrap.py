#!/usr/bin/env python3
import sys
import textwrap

text = sys.stdin.read()
print(textwrap.fill(text, width=75, initial_indent='', subsequent_indent=''), end='')
