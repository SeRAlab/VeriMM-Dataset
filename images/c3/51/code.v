module INV3 (
    input [2:0] in,
    output out
);

wire [2:0] not_in;
assign not_in = ~in;

wire and_out;
assign and_out = not_in[0] & not_in[1] & not_in[2];

assign out = and_out;

endmodule