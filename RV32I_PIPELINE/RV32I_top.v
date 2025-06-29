`include "MUX4to1.v"
`include "PC.v"
`include "IMEM.v"
`include "ADD.v"
`include "IF_ID.v"
`include "CONTROL_PIPELINE.v"
`include "ID_EX.v"
`include "REGISTERFILE.v"
`include "EXTEND.v"
`include "EX_MEM.v"
`include "ALU.v"
`include "MUX2to1.v"
`include "DMEM.v"
`include "MEM_WB.v"
`include "BTB.v"
`include "GHSR.v"
`include "PHT.v"
`include "CONTROL_UNITv1.v"
`include "HAZARD_UNIT.v"

module RV32I_top(
    input clk, rst_n
);

wire [1:0] PC_src;
wire [31:0] PC_target_btb;
wire predict;
wire [7:0] addr_PHT;
wire [31:0] PC_next;
wire [31:0] F_PC_next;
wire [31:0] E_PC_branch;

MUX4to1 MUX4to1_inst0(
    .i_data0(PC_target_btb),
    .i_data1(F_PC_next),
    .i_data2(E_PC_branch),
    .i_data3(E_PC_next),
    .i_select(PC_src),
    .o_data(PC_next)
);

//PC
wire PC_stall, PC_flush;
wire [1:0] F_PC_src;
wire [31:0] F_PC_target_btb;
wire F_predict;
wire [7:0] F_addr_PHT;
wire [31:0] F_PC_cur;
PC PC_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(PC_stall),
    .flush(PC_flush),
    .PC_src(PC_src),
    .PC_target_btb(PC_target_btb),
    .i_predict(predict),
    .i_addr_PHT(addr_PHT),
    .F_PC_src(F_PC_src),
    .F_PC_target_btb(F_PC_target_btb),
    .F_predict(F_predict),
    .F_addr_PHT(F_addr_PHT),
    .i_PC_next(PC_next),
    .F_PC_cur(F_PC_cur)
);

//FETCH
wire [31:0] instruction;
IMEM IMEM_inst(
    .i_addr(F_PC_cur),
    .o_ins(instruction)
);

ADD ADD_inst0(
    .i_data0(F_PC_cur),
    .i_data1(32'd4),
    .o_data(F_PC_next)
);

//IF_ID
wire D_stall, D_flush;
wire [1:0] D_PC_src;
wire [31:0] D_PC_targer_btb;
wire D_predict;
wire [7:0] D_addr_PHT;
wire [31:0] D_ins;
wire [31:0] D_PC_cur;
wire [31:0] D_PC_next;

IF_ID IF_ID_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(D_stall),
    .flush(D_flush),
    .F_PC_src(F_PC_src),
    .F_PC_target_btb(F_PC_target_btb),
    .F_predict(F_predict),
    .F_addr_PHT(F_addr_PHT),
    .F_ins(instruction),
    .F_PC_cur(F_PC_cur),
    .F_PC_next(F_PC_next),
    .D_PC_src(D_PC_src),
    .D_PC_targer_btb(D_PC_targer_btb),
    .D_predict(D_predict),
    .D_addr_PHT(D_addr_PHT),
    .D_ins(D_ins),
    .D_PC_cur(D_PC_cur),
    .D_PC_next(D_PC_next)
);

//DECODE
wire D_jump;
wire D_branch;
wire D_wen_rf;
wire [2:0] D_Imm;
wire D_alu_src;
wire [3:0] D_alucontrol;
wire D_endmem;
wire D_load_store;
wire [2:0] D_funct3;
wire [1:0] D_wb;
CONTROL_PIPELINE CONTROL_PIPELINE_inst(
    .i_opcode(D_ins[6:0]),
    .i_funct3(D_ins[14:12]),
    .i_funct7(D_ins[31:25]),

    .o_jum(D_jump),
    .o_branch(D_branch),
    .o_wen_rf(D_wen_rf),
    .o_Imm(D_Imm),
    .o_alu_src(D_alu_src),
    .o_ALU_control(D_alucontrol),
    .o_en_dmem(D_endmem),
    .o_load_store(D_load_store),
    .o_funct3_dmem(D_funct3),
    .o_writeback(D_wb)
);

//REGISTERFILE
wire [4:0] W_rd;
wire [31:0] W_result;
wire W_wen_rf;
wire [31:0] D_rdata1, D_rdata2;
REGISTERFILE REGISTERFILE_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_raddr1(D_ins[19:15]),
    .i_raddr2(D_ins[24:20]),
    .i_waddr(W_rd),
    .i_wdata(W_result),
    .i_wen_rf(W_wen_rf),
    .o_rdata1(D_rdata1),
    .o_rdata2(D_rdata2)
);

wire[31:0] D_extend;
EXTEND EXTEND_inst(
    .i_Imm(D_Imm),
    .i_data(D_ins[31:7]),
    .o_data(D_extend)
);

//ID_EX
wire E_stall, E_flush;
wire E_predict;
wire [7:0] E_addr_PHT;
wire E_jump;
wire E_branch;
wire [1:0] E_wb;
wire [2:0] E_funct3;
wire E_load_store;
wire E_endmem;
wire [3:0] E_alucontrol;
wire E_alu_src;
wire E_wen_rf;

wire [31:0] E_rdata1;
wire [31:0] E_rdata2;
wire [31:0] E_extend;
wire [31:0] E_PC_cur;
wire [31:0] E_PC_next;

wire [4:0] E_rd;
wire [4:0] E_rs1;
wire [4:0] E_rs2;
ID_EX ID_EX_inst(
    .clk(clk),
    .rst_n(rst_n),
    .flush(E_flush),

    .D_predict(D_predict),
    .D_addr_PHT(D_addr_PHT),
    .D_jump(D_jump),
    .D_branch(D_branch),
    .D_wb(D_wb),
    .D_funct3(D_funct3),
    .D_load_store(D_load_store),
    .D_endmem(D_endmem),
    .D_alucontrol(D_alucontrol),
    .D_alu_src(D_alu_src),
    .D_wen_rf(D_wen_rf),
    
    .D_rdata1(D_rdata1),
    .D_rdata2(D_rdata2),
    .D_extend(D_extend),
    .D_PC_cur(D_PC_cur),
    .D_PC_next(D_PC_next),

    .D_rd(D_ins[11:7]),
    .D_rs1(D_ins[19:15]),
    .D_rs2(D_ins[24:20]),
    
    .E_predict(E_predict),
    .E_addr_PHT(E_addr_PHT),
    .E_jump(E_jump),
    .E_branch(E_branch),
    .E_wb(E_wb),
    .E_funct3(E_funct3),
    .E_load_store(E_load_store),
    .E_endmem(E_endmem),
    .E_alucontrol(E_alucontrol),
    .E_alu_src(E_alu_src),
    .E_wen_rf(E_wen_rf),
    
    .E_rdata1(E_rdata1),
    .E_rdata2(E_rdata2),
    .E_extend(E_extend),
    .E_PC_cur(E_PC_cur),
    .E_PC_next(E_PC_next),
    
    .E_rd(E_rd),
    .E_rs1(E_rs1),
    .E_rs2(E_rs2)
);

//EXCUTE
wire [31:0] M_ALUresult;
wire [31:0] E_rdata1_SrcA, E_rdata2_SrcB_tmp, E_rdata2_SrcB;
wire [1:0] E_FWA, E_FWB;

MUX4to1 MUX4to1_inst1(
    .i_data0(E_rdata1),
    .i_data1(M_ALUresult),
    .i_data2(W_result),
    .i_data3(32'd0),
    .i_select(E_FWA),
    .o_data(E_rdata1_SrcA)
);

MUX4to1 MUX4to1_inst2(
    .i_data0(E_rdata2),
    .i_data1(M_ALUresult),
    .i_data2(W_result),
    .i_data3(32'd0),
    .i_select(E_FWB),
    .o_data(E_rdata2_SrcB_tmp)
);

MUX2to1 MUX2to1_inst0(
    .i_data1(E_rdata2_SrcB_tmp),
    .i_data2(E_extend),
    .i_select(E_alu_src),
    .o_data(E_rdata2_SrcB)
);

wire [31:0] E_ALUresult;
wire E_zero;
ALU ALU_inst(
    .i_opcode(E_alucontrol),
    .i_data1(E_rdata1_SrcA),
    .i_data2(E_rdata2_SrcB),
    .o_result(E_ALUresult),
    .o_zero(E_zero)
);

ADD ADD_inst1(
    .i_data0(E_extend),
    .i_data1(E_PC_cur),
    .o_data(E_PC_branch)
);

//EX_MEM
wire [1:0] M_wb;
wire [2:0] M_funct3;
wire M_load_store;
wire M_endmem;
wire M_wen_rf;
//wire [31:0] M_ALUresult;
wire [31:0] M_wdata;
wire [31:0] M_PC_next;
wire [4:0] M_rd;

EX_MEM EX_MEM_inst(
    .clk(clk),
    .rst_n(rst_n),
    .E_wb(E_wb),
    .E_funct3(E_funct3),
    .E_load_store(E_load_store),
    .E_endmem(E_endmem),
    .E_wen_rf(E_wen_rf),
    .E_ALUresult(E_ALUresult),
    .E_wdata(E_rdata2),
    .E_PC_next(E_PC_next),
    .E_rd(E_rd),

    .M_wb(M_wb),
    .M_funct3(M_funct3),
    .M_load_store(M_load_store),
    .M_endmem(M_endmem),
    .M_wen_rf(M_wen_rf),
    .M_ALUresult(M_ALUresult),
    .M_wdata(M_wdata),
    .M_PC_next(M_PC_next),
    .M_rd(M_rd)
);

//MEMORY
wire [31:0] M_DMEMresult;
DMEM DMEM_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_cs(M_endmem),
    .i_load_store(M_load_store),
    .i_funct3(M_funct3),
    .i_addr(M_ALUresult[7:0]),
    .i_wdata(M_wdata),
    .o_rdata(M_DMEMresult)
);

//MEM_WB
wire [1:0] W_wb;
//wire W_wen_rf,
wire [31:0] W_ALUresult;
wire [31:0] W_DMEMresult;
wire [31:0] W_PC_next;
//wire [4:0] W_rd
MEM_WB MEM_WB_inst(
    .clk(clk),
    .rst_n(rst_n),

    .M_wb(M_wb),
    .M_wen_rf(M_wen_rf),
    .M_ALUresult(M_ALUresult),
    .M_DMEMresult(M_DMEMresult),
    .M_PC_next(M_PC_next),
    .M_rd(M_rd),
    
    .W_wb(W_wb),
    .W_wen_rf(W_wen_rf),
    .W_ALUresult(W_ALUresult),
    .W_DMEMresult(W_DMEMresult),
    .W_PC_next(W_PC_next),
    .W_rd(W_rd)
);

MUX4to1 MUX4to1_inst3(
    .i_data0(W_ALUresult),
    .i_data1(W_DMEMresult),
    .i_data2(W_PC_next),
    .i_data3(32'd0),
    .i_select(W_wb),
    .o_data(W_result)
);

//Branch Prediction Unit

//BTB
wire i_update_BTB;
wire o_hit_btb;
wire i_jump_btb;
wire o_jump_btb;
//wire [31:0] o_PC_target;
BTB BTB_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_E_PC_cur(E_PC_cur),
    .i_E_PC_branch(E_PC_branch),
    .i_update_btb(i_update_BTB),
    .i_F_PC(F_PC_cur),
    .o_PC_target(PC_target_btb),
    .o_hit_btb(o_hit_btb),
    .i_jump(i_jump_btb),
    .o_jump(o_jump_btb)
);

//GHSR
wire actual_branch;
wire update_ghsr;
wire [7:0] o_ghsr;
GHSR GHSR_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_ac(actual_branch),
    .i_update(update_ghsr),
    .o_ghsr(o_ghsr) 
);

assign addr_PHT = F_PC_cur[9:2] ^ o_ghsr;

//PHT
wire update_PHT;
wire o_predict_PHT;
PHT PHT_inst(
    .clk(clk),
    .rst_n(rst_n),
    .i_update(update_PHT),
    .i_actual_taken(actual_branch),
    .i_addr_update(D_addr_PHT),
    .i_addr(addr_PHT),
    .o_predict(o_predict_PHT)
);

//Compare BTB
reg compare_btb;
//assign compare_btb = (D_PC_targer_btb == E_PC_branch) && (D_PC_src == 2'd0); 
always @(*) begin
    if(D_PC_src == 2'd0) begin
        if(D_PC_targer_btb == E_PC_branch) begin
            compare_btb = 1;
        end
        else begin
            compare_btb = 0;
        end
    end
    else begin
        compare_btb = 1;
    end
end

//Control Unit
wire branch_jump;
assign branch_jump = E_jump | E_branch;
wire E_actual_branch;
assign E_actual_branch = (E_branch & E_zero) | E_jump;

wire o_update_PHT_GHSR;
assign update_PHT = o_update_PHT_GHSR;
assign update_ghsr = o_update_PHT_GHSR;
wire mispre;
CONTROL_UNITv1 CONTROL_UNITv1_inst(
    .i_branch(E_branch),
    .i_jump_E(E_jump),
    .i_jump_btb(o_jump_btb),
    .E_actual_branch(E_actual_branch),
    .D_predict(D_predict),
    .compare_btb(compare_btb),
    .i_hit_btb(o_hit_btb),
    .i_predict_PHT(o_predict_PHT),
    .o_jump_btb(i_jump_btb),
    .o_predict_PHT(predict),
    .o_actual_branch(actual_branch),
    .o_update_PHT_GHSR(o_update_PHT_GHSR),
    .o_update_BTB(i_update_BTB),
    .o_PC_src(PC_src),
    .mispre(mispre)
);
/*
CONTROL_UNIT CONTROL_UNIT_inst(
    .branch_jump(branch_jump),
    .E_actual_branch(E_actual_branch),
    .D_predict(D_predict),
    .compare_btb(compare_btb),
    .i_hit_btb(o_hit_btb),
    .i_predict_PHT(o_predict_PHT),
    .o_predict_PHT(predict),
    .o_actual_branch(actual_branch),
    .o_update_PHT_GHSR(o_update_PHT_GHSR),
    .o_update_BTB(i_update_BTB),
    .o_PC_src(PC_src),
    .mispre(mispre)
);
*/

HAZARD_UNIT HAZARD_UNIT_inst(
    .D_rs1(D_ins[19:15]),
    .D_rs2(D_ins[24:20]),
    .branch_jump(branch_jump),
    .mispre(mispre),
    .E_rs1(E_rs1),
    .E_rs2(E_rs2),
    .E_rd(E_rd),
    .E_wb(E_wb),
    .M_rd(M_rd),
    .M_wen_rf(M_wen_rf),
    .W_wen_rf(W_wen_rf),
    .W_rd(W_rd),
    .F_stall(PC_stall),
    .F_flush(PC_flush),
    .D_stall(D_stall),
    .D_flush(D_flush),
    .E_flush(E_flush),
    .E_FWA(E_FWA),
    .E_FWB(E_FWB)
);

endmodule