module top_module( 
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);wire and1, and2, or1, or2, xor1, xor2;

assign and1 = in[0] & in[1];
assign and2 = in[2] & in[3];
assign or1 = in[0] | in[1];
assign or2 = in[2] | in[3];
assign xor1 = in[0] ^ in[1];
assign xor2 = in[2] ^ in[3];

assign out_and = and1 & or2;
assign out_or = or1 & and2;
assign out_xor = xor1 & and2;

endmodule