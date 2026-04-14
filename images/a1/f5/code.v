module top_module(
    input [1:0] in,
    output [3:0] out
);wire and_out;
wire not1_out;
wire not2_out;
wire not3_out;
wire not4_out;

assign and_out = ~(in[0] & in[1]);
assign not1_out = ~and_out;
assign not2_out = ~and_out;
assign not3_out = ~and_out;
assign not4_out = ~and_out;

assign out[0] = not1_out;
assign out[1] = not2_out;
assign out[2] = not3_out;
assign out[3] = not4_out;

endmodule