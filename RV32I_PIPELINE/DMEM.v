module DMEM #(
    parameter d_width = 32,
    parameter a_width = 8
)
(
    input clk, rst_n,
    input i_cs,
    input i_load_store,
    input [2:0] i_funct3,
    input [a_width -1 : 0] i_addr,
    input [d_width -1 : 0] i_wdata,
    output reg [d_width -1 : 0] o_rdata
);

reg [d_width -1 : 0] mem [0 : ((1 << a_width) -1 )];

integer i;

// Ghi dữ liệu tại cạnh lên
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < (1 << a_width); i = i + 1) begin
            mem[i] <= 32'd0;
        end
    end
    else if (i_cs && i_load_store) begin // STORE
        case (i_funct3)
            3'b000: begin // sb
                mem[i_addr] <= {{24{i_wdata[7]}}, i_wdata[7:0]};
            end
            3'b001: begin // sh
                mem[i_addr] <= {{16{i_wdata[15]}}, i_wdata[15:0]};
            end
            3'b010: begin // sw
                mem[i_addr] <= i_wdata;
            end
        endcase
    end
end

// Đọc dữ liệu bất đồng bộ 
always @(*) begin
    if (~rst_n) begin
        o_rdata <= 32'd0;
    end
    else if (i_cs && ~i_load_store) begin // LOAD
        case (i_funct3)
            3'b000: begin // lb
                o_rdata <= {{24{mem[i_addr][7]}}, mem[i_addr][7:0]};
            end
            3'b001: begin // lh
                o_rdata <= {{16{mem[i_addr][15]}}, mem[i_addr][15:0]};
            end
            3'b010: begin // lw
                o_rdata <= mem[i_addr];
            end
            3'b100: begin // lbu
                o_rdata <= {{24{1'b0}}, mem[i_addr][7:0]};
            end
            3'b101: begin // lhu
                o_rdata <= {{16{1'b0}}, mem[i_addr][15:0]};
            end
        endcase
    end
end

endmodule
