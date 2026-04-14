module top_module(
    input [7:0] a,
    input [7:0] b,
    input select,
    output [8:0] s,
    output overflow,
    output out
);wire [7:0] xor_out;
wire [7:0] add_out;
wire [7:0] a_inv;
wire [7:0] b_inv;
wire [7:0] s_inv;

assign xor_out = a ^ b;
assign a_inv = ~a;
assign b_inv = ~b;
assign s_inv = ~(a + b);

assign add_out[0] = a[0] & b[0];
assign add_out[1] = a[0] ^ b[0];
assign add_out[2] = add_out[1] & a[1];
assign add_out[3] = add_out[1] & b[1] | add_out[2];
assign add_out[4] = add_out[1] & a[2] | add_out[2] & b[2] | a[2] & b[2];
assign add_out[5] = add_out[1] & b[2] & a[3] | add_out[1] & a[2] & b[3] | add_out[2] & a[3] & b[3] | add_out[4];
assign add_out[6] = add_out[1] & a[4] | add_out[2] & b[4] | a[4] & b[4] | add_out[3] & a[4] | add_out[3] & b[4] | add_out[5];
assign add_out[7] = add_out[1] & b[4] & a[5] | add_out[1] & a[4] & b[5] | add_out[2] & a[5] & b[5] | add_out[3] & a[5] & b[4] | add_out[3] & a[4] & b[5] | add_out[4] & a[5] & b[5] | add_out[5] & a[5] & b[5] | add_out[6];

assign s = select ? {1'b0, add_out} : {1'b0, s_inv};
assign out = xor_out;

assign overflow = (a[7] == b[7] && s[8] != a[7]) ? 1'b1 : 1'b0;

endmodule