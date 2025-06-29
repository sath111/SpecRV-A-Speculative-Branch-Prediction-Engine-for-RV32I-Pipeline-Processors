module HAZARD_UNIT(
    input [4:0] D_rs1,
    input [4:0] D_rs2,
    
    input branch_jump,
    input mispre,
    
    input [4:0] E_rs1,
    input [4:0] E_rs2,
    input [4:0] E_rd,
    input [1:0] E_wb,

    input [4:0] M_rd,
    input M_wen_rf,

    input W_wen_rf,
    input [4:0] W_rd,

    output reg F_stall, F_flush,
    output reg D_stall, D_flush,
    output reg E_flush,
    output reg [1:0] E_FWA, E_FWB
);


//forward
always @(*) begin
    if(M_rd == E_rs1 && M_wen_rf && E_rs1 != 0) begin
        E_FWA = 2'd1;
    end
    else if(W_rd == E_rs1 && W_wen_rf && E_rs1 != 0) begin
        E_FWA = 2'd2;
    end
    else begin
        E_FWA = 2'd0;
    end
end

always @(*) begin
    if(M_rd == E_rs2 && M_wen_rf && E_rs2 != 0) begin
        E_FWB = 2'd1;
    end
    else if(W_rd == E_rs2 && W_wen_rf && E_rs2 != 0) begin
        E_FWB = 2'd2;
    end
    else begin
        E_FWB = 2'd0;
    end
end

//lw
wire lw_hazard = (((E_rd == D_rs1) || (E_rd == D_rs2)) && (E_wb == 2'd1) && (E_rd != 0));

always @(*) begin
    F_stall = 1'd1;
    D_stall = 1'd1;

    F_flush = 1'd0;
    D_flush = 1'd0;
    E_flush = 1'd0;

    if(lw_hazard) begin
        F_stall = 1'd0;
        D_stall = 1'd0;
        E_flush = 1'd1;
    end

    if(mispre && branch_jump) begin
//        F_flush = 1'd1;
        D_flush = 1'd1;
        E_flush = 1'd1;
    end
end


endmodule