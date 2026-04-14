module top_module(
    clk_i,
    rst_i,
    start_i,
    IF_IDWrite_i,
    IF_IDflush_i,
    pc_i,
    instr_i,
    pc_o,
    instr_o
);input               clk_i;
input               rst_i;
input               start_i;
input               IF_IDWrite_i;
input               IF_IDflush_i;
input       [31:0]  pc_i;
input       [31:0]  instr_i;
output reg  [31:0]  pc_o;
output reg  [31:0]  instr_o;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
        instr_o <= 32'b0;
    end
    else if(~IF_IDWrite_i) begin
        pc_o <= pc_o;
        instr_o <= instr_o;
    end
    else if(IF_IDflush_i) begin
        pc_o <= 32'b0;
        instr_o <= 32'b0;
    end
    else begin
        pc_o <= pc_i;
        instr_o <= instr_i;
    end end

endmodule