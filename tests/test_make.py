#!/usr/bin/env python

import os
import logging
import pytest
import subprocess
import dload
import shutil


# ----------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------
def call_make(arguments=""):
  make_command = "make "+arguments
  print(make_command)
  make_proc = subprocess.Popen(
    make_command,
    shell=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    cwd=os.getcwd()
  )

  stdout, stderr = make_proc.communicate()
  print("stdout: {}".format(stdout))
  print("stderr: {}".format(stderr))
  print("Return code: {}".format(make_proc.returncode))

  return stdout, stderr, make_proc.returncode


# ----------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------
def setup_env():
  os.makedirs("test_repo", exist_ok=True)
  dload.save_unzip("https://github.com/vborchsh/make-fpga/archive/refs/heads/master.zip", ".")
  shutil.copytree("../template", "test_repo/template")
  shutil.move("make-fpga-master", "test_repo/template/make-fpga")


# ----------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------
def run_test():
    setup_env()
    os.chdir("test_repo/template")
    call_make(" synth")


# ----------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------
def test_bline_calc(request):
  run_test()


# ----------------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------------
if __name__ == "__main__":
  run_test()
