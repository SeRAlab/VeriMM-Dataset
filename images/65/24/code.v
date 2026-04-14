module top_module(
    input [1:0] in,
    output out
);wire [1:0] inv_in;
assign inv_in = ~in;

wire and_out;
assign and_out = inv_in[0] & inv_in[1];

wire or_out;
assign or_out = in[0] | in[1];

assign out = and_out | or_out;

endmodule