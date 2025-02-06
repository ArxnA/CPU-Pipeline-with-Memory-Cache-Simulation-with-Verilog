`timescale 1ns / 1ps

`include "AddModule.v"
`include "ALU.v"
`include "ALUControl.v"
`include "Cache.v"
`include "ControlUnit.v"
`include "DataMemory.v"
`include "EXMEMReg.v"
`include "fetch.v"
`include "IDEXReg.v"
`include "IFIDReg.v"
//`include "InstructionMemory.v"
`include "MEMWBReg.v"
//`include "Mux.v"
`include "Mux5.v"
//`include "PC.v"
`include "RegisterFile.v"
`include "SignExtend.v"


module CPU (
    input clk
);
    
    wire hit;

    ////////

    wire cache_hit;
    assign hit = cache_hit | ~mem_read_outControl_unit;

    ////////


	wire [31:0]nextPC_outFetch_inIF_ID_Register;
	wire [31:0]instruction_outFetch_inIF_ID_Register;

    wire [31:0]instruction_outIF_ID_Register;
	wire [31:0]nextPC_outIF_ID_Register_inID_EX_Register;

    wire [31:0]sign_extend_out;

    wire [2:0]alu_op_outControl_unit_inAlu_control;
	
	wire reg_write_outControl_unit;
	wire mem_to_reg_outControl_unit;
	wire mem_write_outControl_unit;
	wire mem_read_outControl_unit;
	wire branch_outControl_unit;
	wire [2:0] alu_ctr_outAlu_control;
	wire alu_src_outControl_unit;
	wire reg_dst_outControl_unit;

    wire [9:0] controlUnit_outControlUnit_inID_EX_Register;

    assign controlUnit_outControlUnit_inID_EX_Register = {
        reg_dst_outControl_unit,
        alu_src_outControl_unit,
        alu_ctr_outAlu_control,
        branch_outControl_unit,
        mem_write_outControl_unit,
        mem_read_outControl_unit,
        mem_to_reg_outControl_unit,
        reg_write_outControl_unit
	};

    wire [31:0]data_out1_outRegister_file_inID_EX_Register;
	wire [31:0]data_out2_outRegister_file_inID_EX_Register;
	
	wire [31:0]outNextPC_outID_EX_Register;
	wire [31:0]outSignExt_outID_EX_Register;
	wire [31:0]outRD1_outID_EX_Register;
	wire [31:0]outRD2_outID_EX_Register;
	wire [4:0]outrd_outID_EX_Register;
	wire [4:0]outrs2_outID_EX_Register;
	wire [9:0]outControlUnit_outID_EX_Register;

    wire [4:0]writeReg_outMux_2_1_regDst;
	
	wire [31:0]srcB_outMux_2_1_ALUsrc;
	
	wire [31:0]alu_out_outAlu_inEX_Mem_Register;
	wire zero_outAlu_inEX_Mem_Register;
	
	wire [31:0]outadder_outAdder_inEX_Mem_Register;
	
	wire [4:0]controlSignals_outID_EX_Register_inEX_Mem_Register;
	
	assign controlSignals_outID_EX_Register_inEX_Mem_Register = {
			outControlUnit_outID_EX_Register[4],
			outControlUnit_outID_EX_Register[3],
			outControlUnit_outID_EX_Register[2],
			outControlUnit_outID_EX_Register[1],
			outControlUnit_outID_EX_Register[0]
	};

    wire [31:0] outALUout_outEX_Mem_Register;
	wire [31:0] outRD2_outEX_Mem_Register;
	wire [31:0] outPCBranch_outEX_Mem_Register;
	wire [4:0] outWriteReg_outEX_Mem_Register;
	wire [4:0] outControlSignals_outEX_Mem_Register;//
	wire outZero_outEX_Mem_Register;

    wire isBranch;
	assign isBranch = outZero_outEX_Mem_Register  &  outControlSignals_outEX_Mem_Register[4];

    wire [31:0]outDataMemory_inMem_WB_Register;
	
	wire [1:0]controlSignals_outEX_Mem_Register_inMem_WB_Register;
	
	assign controlSignals_outEX_Mem_Register_inMem_WB_Register = {
			outControlUnit_outID_EX_Register[1],
			outControlUnit_outID_EX_Register[0]
	};
	
	wire [31:0]outALUot_outMem_WB_Register;
	wire [31:0]outMemoryOut_outMem_WB_Register;
	wire [4:0]outWriteReg_outMem_WB_Register;
	wire [1:0]outControlSig_outMem_WB_Register;
	
	wire [31:0]outDataWriteBack;



///////////////////////////////////////////////////////////////////////////////


Cache cache(
    .clk(clk),
    .address(outALUout_outEX_Mem_Register),
    .inData(Data_memory_out_Cache_in),
    .out(outDataMemory_inMem_WB_Register),
    .hit(cache_hit)
    
);

///////////////////////////////////////////////////////////////////////////////

wire [3:0] out_aluControl_to_alu;

Mux5 finalMux5 (
	.A(outrs2_outID_EX_Register), 
	.B(outrd_outID_EX_Register), 
	.select(outControlUnit_outID_EX_Register[9]), 
	.result(writeReg_outMux_2_1_regDst)
	);

Mux finalMux (
	.in1(outRD2_outID_EX_Register), 
	.in2(outSignExt_outID_EX_Register), 
	.sel(outControlUnit_outID_EX_Register[8]), 
	.out(srcB_outMux_2_1_ALUsrc)
);

ALUControl aluControl (
	.ALUOp(outControlUnit_outID_EX_Register[7:5]),
	.in1(outSignExt_outID_EX_Register[5:0]),
	.ALUcnt(out_aluControl_to_alu)
);

ALU final_ALU (
	.in1(outRD1_outID_EX_Register), 
	.in2(srcB_outMux_2_1_ALUsrc), 
	.aluControl(out_aluControl_to_alu),
    .shamt(), 
	.out(alu_out_outAlu_inEX_Mem_Register), 
	.zero(zero_outAlu_inEX_Mem_Register)
	);

AddModule finalAddModule (
	.A({outSignExt_outID_EX_Register[29:0], 2'b00}), 
	.B(outNextPC_outID_EX_Register), 
	.result(outadder_outAdder_inEX_Mem_Register)
	);


EXMEMReg ExMemReg (
	.ALUout(alu_out_outAlu_inEX_Mem_Register), 
    .RD2(outRD2_outID_EX_Register), 
    .PCBranch(outadder_outAdder_inEX_Mem_Register), 
    .writeReg(writeReg_outMux_2_1_regDst), 
    .controlSignals(controlSignals_outID_EX_Register_inEX_Mem_Register), 
    .clk(clk), 
    .hit(hit), 
    .zero(zero_outAlu_inEX_Mem_Register), 
    .outALUout(outALUout_outEX_Mem_Register), 
    .outRD2(outRD2_outEX_Mem_Register), 
    .outPCBranch(outPCBranch_outEX_Mem_Register), 
    .outWriteReg(outWriteReg_outEX_Mem_Register), 
    .outControlSignals(outControlSignals_outEX_Mem_Register), 
    .outZero(outZero_outEX_Mem_Register)
);


////////////////////////////////////////////////////////////////////////

	wire [31:0] EX_MEM_PC_plus_four_to_fetch;
	wire [4:0] register_file_rs;
	wire [4:0] register_file_rt;
	wire [4:0] register_file_rd;
	assign register_file_rs = instruction_outIF_ID_Register[25:21];
	assign register_file_rt = instruction_outIF_ID_Register[20:16];
	assign register_file_rd = instruction_outIF_ID_Register[15:11];
	
	wire [15:0] sign_extend_in;
	assign sign_extend_in = instruction_outIF_ID_Register[15:0];

	wire RegWrite_outMem_Wb_Register;
	assign RegWrite_outMem_Wb_Register = outControlSig_outMem_WB_Register[1];


	//keinaz:
	wire [31:0] AluOut_EX_MEM_out_MEM_WB_In;



    wire [5:0] opcode_inControlUnit;
    assign opcode_inControlUnit = instruction_outIF_ID_Register[31:26];


    wire [127:0] Data_memory_out_Cache_in;


//////////////////////////////////////
IFIDReg IFID_register(
	.clk(clk),
	.instruction(instruction_outFetch_inIF_ID_Register),
	.PCplusFour(nextPC_outFetch_inIF_ID_Register),
	.outInstruction(instruction_outIF_ID_Register),
	.outNextPC(nextPC_outIF_ID_Register_inID_EX_Register),
    .hit(hit)
);

IDEXReg IDEX_register(
	.nextPC(nextPC_outIF_ID_Register_inID_EX_Register),
	.signExt(sign_extend_out),
	.RD1(data_out1_outRegister_file_inID_EX_Register),
	.RD2(data_out2_outRegister_file_inID_EX_Register),
	.rd(register_file_rd),
	.rs2(register_file_rt),
	.controlUnit(controlUnit_outControlUnit_inID_EX_Register),
	.clk(clk),
	.hit(hit),
	.outNextPC(outNextPC_outID_EX_Register), 
    .outSignExt(outSignExt_outID_EX_Register), 
    .outRD1(outRD1_outID_EX_Register), 
    .outRD2(outRD2_outID_EX_Register), 
    .outrd(outrd_outID_EX_Register), 
    .outrs2(outrs2_outID_EX_Register), 
    .outControlUnit(outControlUnit_outID_EX_Register)
);


fetch fetch_stage(
  .clk(clk),
  .sel(isBranch),
  .in(EX_MEM_PC_plus_four_to_fetch),
  .out(instruction_outFetch_inIF_ID_Register),	
  .pc_plus_four(nextPC_outFetch_inIF_ID_Register),
  .hit(hit)
);

RegisterFile registerfile(
	.clk(clk),
	.RegWrite(outControlUnit_outID_EX_Register[0]),
	.rs(register_file_rs),
	.rt(register_file_rt),
	.rd(writeReg_outMux_2_1_regDst),
	.in(outDataWriteBack),
	.out1(data_out1_outRegister_file_inID_EX_Register),
	.out2(data_out2_outRegister_file_inID_EX_Register)
);

SignExtend sign_extend(
	.in(sign_extend_in),
	.out(sign_extend_out)
);

ControlUnit control_unit(
	.opCode(opcode_inControlUnit),
	.regDst(reg_dst_outControl_unit),
	.aluSrc(alu_src_outControl_unit),
	.memToReg(mem_to_reg_outControl_unit),
	.regWrite(reg_write_outControl_unit),
	.memRead(mem_read_outControl_unit),
	.memWrite(mem_write_outControl_unit),
	.branch(branch_outControl_unit),
	.aluOp(alu_ctr_outAlu_control)
);




MEMWBReg MemWbreg(
	.ALUout(outALUout_outEX_Mem_Register),
	.MemoryOut(outDataMemory_inMem_WB_Register),
	.writeReg(outWriteReg_outEX_Mem_Register),
	.controlSig(controlSignals_outEX_Mem_Register_inMem_WB_Register),
	.hit(hit),
	.clk(clk),
	.outALUot(outALUot_outMem_WB_Register),
	.outMemoryOut(outMemoryOut_outMem_WB_Register),
	.outWriteReg(outWriteReg_outMem_WB_Register),
	.outControlSig(outControlSig_outMem_WB_Register)
);


DataMemory datamemory(
	.clk(clk),
	.writeSig(outControlSignals_outEX_Mem_Register[3]),
	.address(outALUout_outEX_Mem_Register),
	.inData(outRD2_outEX_Mem_Register),
	.out(Data_memory_out_Cache_in)
);


Mux wbMux(
    .in1(outMemoryOut_outMem_WB_Register), 
	.in2(outALUot_outMem_WB_Register), 
	.sel(outControlUnit_outID_EX_Register[1]), 
	.out(outDataWriteBack)
);

endmodule
////////////////////////////////////////////////////