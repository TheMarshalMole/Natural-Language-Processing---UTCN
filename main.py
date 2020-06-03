#!/usr/bin/env python3
from NLID import NLID
import os

def main():
    os.environ.setdefault('PYTHONPATH', './')
    NLID.start()

if __name__ == "__main__":
    main()