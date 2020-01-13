#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
.PHONY: clean
GHDL=ghdl
GHDLFLAGS=--std=08 --ieee=synopsys
SIMULATION_WAVEFORM=ghw
SOURCE_FOLDER=../vhdl_source

PIPELINE_SIGNED_BASED_MULTIPLIER_257=\
	$(SOURCE_FOLDER)/wide_adder_carry_select.o\
	$(SOURCE_FOLDER)/adder_compressor_3_2.o\
	$(SOURCE_FOLDER)/adder_compressor_4_3.o\
	$(SOURCE_FOLDER)/adder_compressor_5_3.o\
	$(SOURCE_FOLDER)/adder_compressor_6_3.o\
	$(SOURCE_FOLDER)/adder_compressor_30_5.o\
	$(SOURCE_FOLDER)/adder_compressor_31_5.o\
	$(SOURCE_FOLDER)/pipeline_signed_base_multiplier_257.o\
	$(SOURCE_FOLDER)/pipeline_signed_base_multiplier_257_tiled.o

TB_PIPELINE_SIGNED_BASED_MULTIPLIER_257=tb_pipeline_signed_base_multiplier_257

PIPELINE_SIGNED_BASED_MULTIPLIER_129=\
	$(SOURCE_FOLDER)/wide_adder_carry_select.o\
	$(SOURCE_FOLDER)/adder_compressor_3_2.o\
	$(SOURCE_FOLDER)/adder_compressor_4_3.o\
	$(SOURCE_FOLDER)/adder_compressor_5_3.o\
	$(SOURCE_FOLDER)/adder_compressor_6_3.o\
	$(SOURCE_FOLDER)/adder_compressor_30_5.o\
	$(SOURCE_FOLDER)/adder_compressor_31_5.o\
	$(SOURCE_FOLDER)/pipeline_signed_base_multiplier_129.o

SYNTH_RAM=\
	$(SOURCE_FOLDER)/synth_ram.o\
	$(SOURCE_FOLDER)/synth_double_ram.o\
	$(SOURCE_FOLDER)/synth_dist_ram.o\
	$(SOURCE_FOLDER)/program_instructions_v3.o\
	$(SOURCE_FOLDER)/synth_mac_ram_v4.o\
	$(SOURCE_FOLDER)/synth_base_alu_ram_v3.o\
	$(SOURCE_FOLDER)/synth_rd_ram.o

CARMELA_WITH_CONTROL_UNIT_v256=\
	$(PIPELINE_SIGNED_BASED_MULTIPLIER_257)\
	$(SOURCE_FOLDER)/base_address_circular_shift_input_v2.o\
	$(SOURCE_FOLDER)/base_address_circular_shift_output_v2.o\
	$(SOURCE_FOLDER)/carmela_state_machine_v256.o\
	$(SOURCE_FOLDER)/carmela_state_machine_v256_compact.o\
	$(SOURCE_FOLDER)/carmela_v256.o\
	$(SOURCE_FOLDER)/carmela_with_control_unit_v256.o\

TB_CARMELA_WITH_CONTROL_UNIT_v256=tb_carmela_with_control_unit_v256

CARMELA_WITH_CONTROL_UNIT_v128=\
	$(PIPELINE_SIGNED_BASED_MULTIPLIER_129)\
	$(SOURCE_FOLDER)/base_address_circular_shift_input_v2.o\
	$(SOURCE_FOLDER)/base_address_circular_shift_output_v2.o\
	$(SOURCE_FOLDER)/carmela_state_machine_v128.o\
	$(SOURCE_FOLDER)/carmela_state_machine_v128_compact.o\
	$(SOURCE_FOLDER)/carmela_v128.o\
	$(SOURCE_FOLDER)/carmela_with_control_unit_v128.o\

TB_CARMELA_WITH_CONTROL_UNIT_v128=tb_carmela_with_control_unit_v128

SIKE_CORE_256_OBJ=\
	$(CARMELA_WITH_CONTROL_UNIT_v256)\
	$(SYNTH_RAM)\
	$(SOURCE_FOLDER)/keccak_chi_iota_theta.o\
	$(SOURCE_FOLDER)/keccak_rho_pi.o\
	$(SOURCE_FOLDER)/keccak_round_constants_gen.o\
	$(SOURCE_FOLDER)/keccak.o\
	$(SOURCE_FOLDER)/keccak_small_bus.o\
	$(SOURCE_FOLDER)/base_alu.o\
	$(SOURCE_FOLDER)/sike_core_state_machine_v256.o\
	$(SOURCE_FOLDER)/sike_core_v256.o

TB_SIKE_CORE_256_INSTRUCTIONS_ISOLATED=tb_sike_core_v256_instructions_isolated
TB_SIKE_CORE_256_SIDH_BASIC_PROCEDURES=tb_sike_core_v256_sidh_basic_procedures
TB_SIKE_CORE_256_SIDH_FUNCTIONS=tb_sike_core_v256_sidh_functions
TB_SIKE_CORE_256_SIKE_FUNCTIONS=tb_sike_core_v256_sike_functions

SIKE_CORE_128_OBJ=\
	$(CARMELA_WITH_CONTROL_UNIT_v128)\
	$(SYNTH_RAM)\
	$(SOURCE_FOLDER)/keccak_chi_iota_theta.o\
	$(SOURCE_FOLDER)/keccak_rho_pi.o\
	$(SOURCE_FOLDER)/keccak_round_constants_gen.o\
	$(SOURCE_FOLDER)/keccak.o\
	$(SOURCE_FOLDER)/keccak_small_bus.o\
	$(SOURCE_FOLDER)/base_alu.o\
	$(SOURCE_FOLDER)/sike_core_state_machine_v128.o\
	$(SOURCE_FOLDER)/sike_core_v128.o

TB_SIKE_CORE_128_INSTRUCTIONS_ISOLATED=tb_sike_core_v128_instructions_isolated
TB_SIKE_CORE_128_SIDH_BASIC_PROCEDURES=tb_sike_core_v128_sidh_basic_procedures
TB_SIKE_CORE_128_SIDH_FUNCTIONS=tb_sike_core_v128_sidh_functions
TB_SIKE_CORE_128_SIKE_FUNCTIONS=tb_sike_core_v128_sike_functions

ALL_TESTBENCHES=\
	$(TB_PIPELINE_SIGNED_BASED_MULTIPLIER_257)\
	$(TB_CARMELA_WITH_CONTROL_UNIT_v256)\
	$(TB_CARMELA_WITH_CONTROL_UNIT_v128)\
	$(TB_SIKE_CORE_256_INSTRUCTIONS_ISOLATED)\
	$(TB_SIKE_CORE_256_SIDH_BASIC_PROCEDURES)\
	$(TB_SIKE_CORE_256_SIDH_FUNCTIONS)\
	$(TB_SIKE_CORE_256_SIKE_FUNCTIONS)\
	$(TB_SIKE_CORE_128_INSTRUCTIONS_ISOLATED)\
	$(TB_SIKE_CORE_128_SIDH_BASIC_PROCEDURES)\
	$(TB_SIKE_CORE_128_SIDH_FUNCTIONS)\
	$(TB_SIKE_CORE_128_SIKE_FUNCTIONS)

tb_pipeline_signed_based_multiplier_257 : $(PIPELINE_SIGNED_BASED_MULTIPLIER_257)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_PIPELINE_SIGNED_BASED_MULTIPLIER_257).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_PIPELINE_SIGNED_BASED_MULTIPLIER_257)
	$(GHDL) -r $(GHDLFLAGS) $(TB_PIPELINE_SIGNED_BASED_MULTIPLIER_257) --wave=$(TB_PIPELINE_SIGNED_BASED_MULTIPLIER_257).$(SIMULATION_WAVEFORM)

tb_carmela_with_control_unit_v256 : $(CARMELA_WITH_CONTROL_UNIT_v256) $(SYNTH_RAM)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_CARMELA_WITH_CONTROL_UNIT_v256).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_CARMELA_WITH_CONTROL_UNIT_v256)
	$(GHDL) -r $(GHDLFLAGS) $(TB_CARMELA_WITH_CONTROL_UNIT_v256)

tb_carmela_with_control_unit_v128 : $(CARMELA_WITH_CONTROL_UNIT_v128) $(SYNTH_RAM)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_CARMELA_WITH_CONTROL_UNIT_v128).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_CARMELA_WITH_CONTROL_UNIT_v128)
	$(GHDL) -r $(GHDLFLAGS) $(TB_CARMELA_WITH_CONTROL_UNIT_v128)

tb_sike_core_256_instructions_isolated : $(SIKE_CORE_256_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_256_INSTRUCTIONS_ISOLATED).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_256_INSTRUCTIONS_ISOLATED)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_256_INSTRUCTIONS_ISOLATED)

tb_sike_core_256_sidh_basic_procedures : $(SIKE_CORE_256_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_256_SIDH_BASIC_PROCEDURES).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_256_SIDH_BASIC_PROCEDURES)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_256_SIDH_BASIC_PROCEDURES)

tb_sike_core_256_sidh_functions : $(SIKE_CORE_256_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_256_SIDH_FUNCTIONS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_256_SIDH_FUNCTIONS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_256_SIDH_FUNCTIONS)

tb_sike_core_256_sike_functions : $(SIKE_CORE_256_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_256_SIKE_FUNCTIONS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_256_SIKE_FUNCTIONS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_256_SIKE_FUNCTIONS)

tb_sike_core_128_instructions_isolated : $(SIKE_CORE_128_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_128_INSTRUCTIONS_ISOLATED).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_128_INSTRUCTIONS_ISOLATED)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_128_INSTRUCTIONS_ISOLATED)

tb_sike_core_128_sidh_basic_procedures : $(SIKE_CORE_128_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_128_SIDH_BASIC_PROCEDURES).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_128_SIDH_BASIC_PROCEDURES)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_128_SIDH_BASIC_PROCEDURES)

tb_sike_core_128_sidh_functions : $(SIKE_CORE_128_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_128_SIDH_FUNCTIONS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_128_SIDH_FUNCTIONS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_128_SIDH_FUNCTIONS)

tb_sike_core_128_sike_functions : $(SIKE_CORE_128_OBJ)
	$(GHDL) -a $(GHDLFLAGS) $(SOURCE_FOLDER)/$(TB_SIKE_CORE_128_SIKE_FUNCTIONS).vhd
	$(GHDL) -e $(GHDLFLAGS) $(TB_SIKE_CORE_128_SIKE_FUNCTIONS)
	$(GHDL) -r $(GHDLFLAGS) $(TB_SIKE_CORE_128_SIKE_FUNCTIONS)

# Binary depends on the object file
%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Object file depends on source
%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<


clean:
	@echo "Cleaning up..."
	rm -f $(ALL_TESTBENCHES)
	rm -f work*.cf
	@echo "Cleaning done."