module CONTROL_PIPELINE(
    input [6:0] i_opcode,
    input [2:0] i_funct3,
    input [6:0] i_funct7,

    output reg o_jum,
    output reg o_branch,
    output reg o_wen_rf,
    output reg [2:0] o_Imm,
    output reg o_alu_src,
    output reg [3:0] o_ALU_control,
    output reg o_en_dmem,
    output reg o_load_store,
    output reg [2:0] o_funct3_dmem,
    output reg [1:0] o_writeback
);

always @(*) begin
    o_jum = 0;
    o_branch = 0;
    o_Imm = 0;
    o_wen_rf = 1;
    o_alu_src = 0;
    o_ALU_control = 0;
    o_en_dmem = 0;
    o_load_store = 0;
    o_funct3_dmem = 0;
    o_writeback = 0;
    
    case(i_opcode) 
        7'b0110111: begin //lui
            o_jum = 0;
            o_branch = 0;
            o_wen_rf = 1;
            o_Imm = 3'd5;
            o_alu_src = 0;
            o_ALU_control = 0;
            o_en_dmem = 0;
            o_load_store = 0;
            o_funct3_dmem = 0;
            o_writeback = 2'd0;
        end
        7'b1101111: begin //jal
            o_jum = 1;
            o_branch = 0;
            o_wen_rf = 1;
            o_Imm = 3'd4;
            o_alu_src = 0;
            o_ALU_control = 0;
            o_en_dmem = 0;
            o_load_store = 0;
            o_funct3_dmem = 0;
            o_writeback = 2'd2;
        end
        7'b1100011: begin //branch
            o_jum = 0;
            o_branch = 1;
            o_wen_rf = 0;
            o_Imm = 3'd2;
            o_alu_src = 0;
            o_ALU_control = 4'b0001;
            o_en_dmem = 0;
            o_load_store = 0;
            o_funct3_dmem = 0;
            o_writeback = 0;
        end

        7'b0000011: begin //load
            o_jum = 0;
            o_branch = 0;
            o_wen_rf = 1;
            o_Imm = 0;
            o_alu_src = 1;
            o_ALU_control = 4'b0000;
            o_en_dmem = 1;
            o_load_store = 0;
            o_funct3_dmem = i_funct3;
            o_writeback = 1;
        end

        7'b0100011: begin //store
            o_jum = 0;
            o_branch = 0;
            o_wen_rf = 0;
            o_Imm = 1;
            o_alu_src = 1;
            o_ALU_control = 4'b0000;
            o_en_dmem = 1;
            o_load_store = 1;
            o_funct3_dmem = i_funct3;
            o_writeback = 0;
        end
        
        7'b0010011: begin //I
            o_jum = 0;
            o_branch = 0;
            o_wen_rf = 1;
            o_alu_src = 1;
            o_en_dmem = 0;
            o_load_store = 0;
            o_funct3_dmem = 0;
            o_writeback = 0;
            case(i_funct3) 
                3'b000: begin
                    o_ALU_control = 4'b0000; // addi
                    o_Imm = 3'b000;
                end
                3'b010: begin
                    o_ALU_control = 4'b0011; // slti
                    o_Imm = 3'b000;
                end
                3'b011: begin
                    o_ALU_control = 4'b0100; // sltiu
                    o_Imm = 3'b000;
                end
                3'b100: begin
                    o_ALU_control = 4'b0101; // xori
                    o_Imm = 3'b000;
                end
                3'b110: begin
                    o_ALU_control = 4'b1000; // ori
                    o_Imm = 3'b000;
                end
                3'b111: begin
                    o_ALU_control = 4'b1001; // andi
                    o_Imm = 3'b000;
                end
                3'b001: begin
                    o_ALU_control = 4'b0010; // slli
                    o_Imm = 3'b011;
                end
                3'b101: begin 
                    o_Imm = 3'b011;
                    if(i_funct7 == 7'd0) begin
                        o_ALU_control = 4'b0110; // srli
                    end else begin
                        o_ALU_control = 4'b0111; // srai
                    end
                end
                default: begin
                    o_jum = 0;
                    o_branch = 0;
                    o_Imm = 0;
                    o_wen_rf = 1;
                    o_alu_src = 0;
                    o_ALU_control = 0;
                    o_en_dmem = 0;
                    o_load_store = 0;
                    o_funct3_dmem = 0;
                    o_writeback = 0;
                end
            endcase
        end
        
        7'b0110011: begin //R
            o_jum = 0;
            o_branch = 0;
            o_Imm = 0;
            o_wen_rf = 1;
            o_alu_src = 0;
            o_en_dmem = 0;
            o_load_store = 0;
            o_funct3_dmem = 0;
            o_writeback = 0;
            case(i_funct3) 
                3'b000: begin 
                    if(i_funct7 == 7'd0) begin
                        o_ALU_control = 4'b0000; // add
                    end else begin
                        o_ALU_control = 4'b0001; // sub
                    end
                end
                3'b001: o_ALU_control = 4'b0010; // sll
                3'b010: o_ALU_control = 4'b0011; // slt
                3'b011: o_ALU_control = 4'b0100; // sltu
                3'b100: o_ALU_control = 4'b0101; // xor
                3'b101: begin
                    if(i_funct7 == 7'd0) begin
                        o_ALU_control = 4'b0110; // srl
                    end else begin
                        o_ALU_control = 4'b0111; // sra
                    end
                end
                3'b110: o_ALU_control = 4'b1000; // or
                3'b111: o_ALU_control = 4'b1001; // and
                default: begin
                    o_jum = 0;
                    o_branch = 0;
                    o_Imm = 0;
                    o_wen_rf = 1;
                    o_alu_src = 0;
                    o_ALU_control = 0;
                    o_en_dmem = 0;
                    o_load_store = 0;
                    o_funct3_dmem = 0;
                    o_writeback = 0;
                end
            endcase
        end
        default: begin
            o_jum = 0;
            o_branch = 0;
            o_wen_rf = 0;
            o_Imm = 3'd0;
            o_alu_src = 0;
            o_ALU_control = 0;
            o_en_dmem = 0;
            o_load_store = 0;
            o_funct3_dmem = 3'd0;
            o_writeback = 0;
        end
    endcase
end

endmodule
