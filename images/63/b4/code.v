module top_module(
    input [4:0] in,
    output out_and,
    output out_or,
    output out_xor
);wire [3:0] and_wire;
wire [3:0] or_wire;
wire [3:0] xor_wire;

assign and_wire = in[0] & in[1] & in[2] & in[3];
assign or_wire = in[0] | in[1] | in[2] | in[3];
assign xor_wire = in[0] ^ in[1] ^ in[2] ^ in[3];

assign out_and = and_wire[0] & and_wire[1] & and_wire[2] & and_wire[3];
assign out_or = or_wire[0] | or_wire[1] | or_wire[2] | or_wire[3];
assign out_xor = xor_wire[0] ^ xor_wire[1] ^ xor_wire[2] ^ xor_wire[3];

endmodule