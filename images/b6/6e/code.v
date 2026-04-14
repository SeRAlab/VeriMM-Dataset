module top_module(a, b, cin, sum, cout);input [3:0] a, b;
input cin;
output [3:0] sum;
output cout;

wire [3:0] xor1_out, and1_out, and2_out;
wire xor2_out, xor3_out;
wire and3_out, or1_out, or2_out;

// XOR gates for each bit of the inputs
assign xor1_out = a ^ b;
assign xor2_out = xor1_out[1] ^ cin;
assign xor3_out = xor1_out[2] ^ xor2_out;

// AND gates for each bit of the inputs
assign and1_out = a & b;
assign and2_out = xor1_out[1] & cin;
assign and3_out = xor1_out[2] & xor2_out;

// OR gates for each bit of the inputs
assign or1_out = and1_out | and2_out;
assign or2_out = and3_out | xor1_out[3];

// Output sum and carry-out
assign sum = xor3_out | (xor1_out & cin);
assign cout = or1_out | or2_out;

endmodule