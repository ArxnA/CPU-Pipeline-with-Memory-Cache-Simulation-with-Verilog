`timescale 1ns / 1ps
`include "fetch.v"
`include "IDEXReg.v"
`include "RegisterFile.v"
`include "SignExtend.v"
`include "ControlUnit.v"

module CPU (
    input clk
);
    
    wire hit;

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
	wire [3:0] alu_ctr_outAlu_control;
	wire alu_src_outControl_unit;
	wire reg_dst_outControl_unit;

    wire [9:0] controlUnit_outControlUnit_inID_EX_Register;

    assign controlUnit_outControlUnit_inID_EX_Register	= {
        reg_dst_outControl_unit,
        alu_src_outControl_unit,
        alu_op_outControl_unit_inAlu_control,
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
	assign isBranch = zero_outAlu_inEX_Mem_Register && controlSignals_outID_EX_Register_inEX_Mem_Register[4];

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

	//////////////////////////////////////////////////////////////////////////
	// Wire haye tarif shode tavasote keinaz va ilya
	//
	//ilya:
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


	///////////////////////////////////////////////////////////////////////////


IFIDReg IFID_register(
	.clk(clk),
	.instruction(instruction_outFetch_inIF_ID_Register),
	.PCplusFour(nextPC_outFetch_inIF_ID_Register),
	.outInstruction(instruction_outIF_ID_Register),
	.outNextPC(nextPC_outIF_ID_Register_inID_EX_Register)
);

IDEXReg IDEX_register(
	.nextPC(nextPC_outIF_ID_Register_inID_EX_Register),
	.signExt(sign_extend_out),
	.RD1(data_out1_outRegister_file_inID_EX_Register),
	.RD2(data_out2_outRegister_file_inID_EX_Register),
	.rd(register_file_rd),
	.rs2(register_file_rs),
	.controlUnit(controlUnit_outControlUnit_inID_EX_Register),
	.clk(clk),
	.hit(),
	.outNextPC(outNextPC_outID_EX_Register),
	.outSignExt(),
	.outRD1(),
	.outRD2(),
	.outrd(),
	.outrs2(),
	outControlUnit()
);


fetch fetch_stage(
  .clk(clk),
  .sel(isBranch),
  .in(EX_MEM_PC_plus_four_to_fetch),
  .out(instruction_outFetch_inIF_ID_Register),	
  .pc_plus_four(nextPC_outFetch_inIF_ID_Register)
);

RegisterFile registerfile(
	.clk(clk),
	.RegWrite(),
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
	.opCode(),
	.regDst(),
	.aluSrc(),
	.memToReg(),
	.regWrite(),
	.memRead(),
	.memWrite(),
	.branch(),
	.aluOp()
);




MEMWBReg MemWbreg(
	.ALUout(AluOut_EX_MEM_out_MEM_WB_In),
	.MemoryOut(outDataMemory_inMem_WB_Register),
	.writeReg(outWriteReg_outEX_Mem_Register),
	.controlSig(controlSignals_outEX_Mem_Register_inMem_WB_Register),
	.hit(),
	.clk(clk),
	.outALUot(outALUot_outMem_WB_Register),
	.outMemoryOut(outMemoryOut_outMem_WB_Register),
	.outWriteReg(outWriteReg_outMem_WB_Register),
	.outControlSig(outControlSig_outMem_WB_Register)
) 


DataMemory datamemory(
	.clk(),
	.writeSig(),
	.address(),
	.inData(),
	.out(outDataMemory_inMem_WB_Register)
)




endmodule