#!/bin/bash

# Rewrites our .scss files to be compatible with closure-stylesheets
# in our internal Blaze infrastructure.

##
# Copyright 2017 Google Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

set -e

function log() {
  echo -e "\033[36m[closure-rewriter]\033[0m" "$@"
}

CLOSURE_TMP=.closure-tmp
CLOSURE_PKGDIR=$CLOSURE_TMP/packages

log "Prepping packages for rewrite"

rm -fr $CLOSURE_TMP/**
mkdir -p $CLOSURE_PKGDIR
PACKAGE_NAMES=$(ls packages)
for pkg in $PACKAGE_NAMES ; do
  if [[ $pkg != *"mdc-"* ]]; then
    continue
  fi
  cp -r "packages/$pkg" $CLOSURE_PKGDIR
done
rm -fr $CLOSURE_PKGDIR/**/{node_modules,dist}

log "Rewriting all import statements to be closure compatible"
node scripts/rewrite-sass-import-statements-for-closure.js $CLOSURE_PKGDIR
