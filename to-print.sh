#!/usr/bin/env bash

set -ex

OUT=to_print.pdf

convert -append $@ -page A4 $OUT
