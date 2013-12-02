TOPMODULE = Pipe_CPU_1
SUBMODULE_FILES = ProgramCounter.v Instr_Memory.v Reg_File.v ${ALU_MODULE_FILES} Data_Memory.v Decoder.v ALU_Ctrl.v Pipe_Reg.v MUX_2to1.v Sign_Extend.v ${PC_MODULE_FILES} 
TESTER_MODULE = TestBench
TESTER = ${TESTER_MODULE}.v

PC_MODULE_FILES = Adder.v 
ALU_MODULE_FILES = alu.v alu_top.v FA_1b.v

all: ${TOPMODULE}.vvp
	
simulate: ${TOPMODULE}.vcd

waveform: ${TOPMODULE}.vcd
	gtkwave ${TOPMODULE}.vcd

${TOPMODULE}.vvp: ${TOPMODULE}.v ${TESTER} ${SUBMODULE_FILES}
	iverilog -o $@ $^

${TOPMODULE}.vcd: ${TOPMODULE}.vvp
	vvp ${TOPMODULE}.vvp

clean:
	rm -f *.vvp *.vcd

.PHONY: clean simulate waveform 
