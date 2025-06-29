module CONTROL_UNITv1(
    input i_branch,
    input i_jump_E,
    input i_jump_btb,
    input E_actual_branch,
    input D_predict,
    input compare_btb,
    input i_hit_btb,
    input i_predict_PHT,

    output reg o_jump_btb,
    output reg o_predict_PHT,
    output reg o_actual_branch,
    output reg o_update_PHT_GHSR,
    output reg o_update_BTB,
    output reg [1:0] o_PC_src,
    output mispre
);

assign mispre = ~((E_actual_branch == D_predict) && compare_btb);

always @(*) begin
/*    if(~(i_jump_E | i_branch)) begin  // 
        o_PC_src = 2'd1;
        o_predict_PHT = 1'd0;
    end */
    o_PC_src = 2'd1;
    o_predict_PHT = 1'd0;
    if(i_branch && E_actual_branch) begin
        if(D_predict) begin
            o_PC_src = 2'd1;
            o_predict_PHT = 1'd0;
        end
        else begin
            o_PC_src = 2'd2;
            o_predict_PHT = 1'd0;
        end
    end
    else if(i_jump_btb && i_hit_btb) begin //jump 
        o_PC_src = 2'd0;
        o_predict_PHT = 1'd1;
    end
    else if(mispre) begin
        if(~E_actual_branch) begin
            o_PC_src = 2'd3;
            o_predict_PHT = 1'd0;
        end
        else begin
            o_PC_src = 2'd2;
            o_predict_PHT = 1'd0;
        end
    end
    else if(i_hit_btb && i_predict_PHT) begin
        o_PC_src = 2'd0;
        o_predict_PHT = 1'd1;
    end
    else begin
        o_PC_src = 2'd1;
        o_predict_PHT = 2'd0;
    end
    /*
    else begin
        if(mispre) begin
            o_PC_src = 2'd2;
            o_predict_PHT = 1'd0;
        end
        else if(i_hit_btb) begin
            if(i_predict_PHT) begin
                o_PC_src = 2'd0;
                o_predict_PHT = 1'd1;
            end
            else begin
                o_PC_src = 2'd1;
                o_predict_PHT = 1'd0;
            end
        end
        else begin
            o_PC_src = 2'd1;
            o_predict_PHT = 2'd0;
        end
    end*/
    
end

always @(*) begin
    o_actual_branch = E_actual_branch;
end

always @(*) begin
    o_update_BTB = 1'd0;
    o_jump_btb = 1'd0;
    if(i_jump_E) begin
        o_update_BTB = 1'd1;
        o_jump_btb = 1'd1;
    end
    else if(i_branch) begin
        o_update_BTB = 1'd1;
        o_jump_btb = 1'd0;
    end
end

always @(*) begin
    o_update_PHT_GHSR = 1'd0;
    if(i_branch) begin
        o_update_PHT_GHSR = 1'd1;
    end
end


endmodule