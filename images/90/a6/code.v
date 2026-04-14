module top_module(
    input [15:0] in,
    input [3:0] shift_amount,
    output [15:0] out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;

always @(*) begin
    stage1_out = in << shift_amount;
end

always @(*) begin
    stage2_out = stage1_out >> shift_amount;
end

assign out = stage2_out;

endmodule