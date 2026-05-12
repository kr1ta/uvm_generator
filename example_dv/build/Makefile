#---------------------------------------------------------
# Settings
#---------------------------------------------------------

include ../../../veriflib/verifutils/make/makeutils.mk

# Target SHELL

SHELL := bash

# Output directory

OUT = ./out

# Testlist

TESLIST = ./testlist.yaml

# Simulator settings

SIMULATOR_YAML = ./rtl_simulation.yaml

# Test

TEST = test

# Iterations

ITERS = 1

# Jobs number

JOBS = 8

# Seed

SEED = $$RANDOM

# Verbosity

v = @

# Simulator to use: questa, xlm

SIMULATOR = xlm

# GUI/batch switch

ifeq ($(GUI), 1)
	GUI_BATCH = --gui
else
	GUI_BATCH = --batch
endif

# Veriflib path

veriflib_dir := ../../../veriflib

# Compilation options

COMP_OPTS += +incdir+../uvm/env
COMP_OPTS += +incdir+../uvm/test
COMP_OPTS += +incdir+../uvm/agent
COMP_OPTS += +incdir+$(veriflib_dir)/reset_agent/dv/uvm/agent
COMP_OPTS += +incdir+$(veriflib_dir)/reset_agent/dv/uvm/seq
COMP_OPTS += +incdir+$(veriflib_dir)/watchdog/dv/uvm

#---------------------------------------------------------
# Internal variables
#---------------------------------------------------------

verifbuilder_run = $(veriflib_dir)/verifbuilder/run.py

# All sources

srcs = $(shell cat dv.f | envsubst)

# All verilog

verilog = $(srcs) $(shell find ../uvm -name "*.*v")

# Compilation dependencies

comp_deps = $(TESLIST) $(SIMULATOR_YAML) $(verilog) $(call deps,SIMULATOR COMP_OPTS TEST,$(OUT)/deps)


#---------------------------------------------------------
# Targets
#---------------------------------------------------------

# Run

run: $(OUT)/compile.stamp
	$(v)python3 -B $(verifbuilder_run) --sim_only --tool=$(SIMULATOR) --out=$(OUT) \
		--seed=$(SEED) --testlist=$(TESLIST) --rtl_sim=$(SIMULATOR_YAML) --tests $(TEST) \
			--iters=$(ITERS) --rlog=$(OUT)/regr.log  --rexp "UVM_ERROR :    0" "UVM_FATAL :    0"  \
				--jobs $(JOBS) $(GUI_BATCH)

# Compile

$(OUT)/compile.stamp: $(comp_deps) | $(OUT)
	$(v)python3 -B $(verifbuilder_run) --comp_only --tool=$(SIMULATOR) --out=$(OUT) \
		--seed=$(SEED) --testlist=$(TESLIST) --rtl_sim=$(SIMULATOR_YAML) --tests $(TEST) \
			--jobs $(JOBS) --comp_opts "$(COMP_OPTS)"
	@touch $@

# Output directory

$(OUT):
	@mkdir -p $@

# Clean

.PHONY: clean

clean:
	rm -rf $(OUT)
	rm -rf ./xcelium.shm
	rm -rf ./.simvision
