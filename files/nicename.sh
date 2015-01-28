#!/bin/bash

grep `/bin/hostname` /cul/share/nicenames  | awk '{print $2}'
