module top_module(
    input clk,
    input [31:0] data_in,
    input [4:0] shift_amt,
    output reg [31:0] data_out
);reg [31:0] stage1_out, stage2_out, stage3_out, stage4_out;

always @(posedge clk) begin
    stage1_out <= data_in >> 16;
    stage2_out <= stage1_out >> 8;
    stage3_out <= stage2_out >> 4;
    stage4_out <= stage3_out >> 2;
    data_out <= (shift_amt[4]) ? stage4_out : data_in << shift_amt;
end

endmodule