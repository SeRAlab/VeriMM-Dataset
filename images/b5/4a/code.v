module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);wire [3:0] xor1, xor2, xor3;
wire and1, and2, and3, and4, or1, or2;

// Calculate the XORs
assign xor1 = A ^ B;
assign xor2 = {1'b0, A[1:0]} ^ {1'b0, B[1:0]} ^ {3'b0, Cin}; // Changed to ensure correct width
assign xor3 = {1'b0, A[2:0]} ^ {1'b0, B[2:0]} ^ {3'b0, Cin}; // Changed to ensure correct width

// Calculate the ANDs
assign and1 = A[0] & B[0];
assign and2 = A[1] & B[1];
assign and3 = A[2] & B[2];
assign and4 = A[3] & B[3];

// Calculate the ORs
assign or1 = and1 | and2 | and3;
assign or2 = (and2 & and3) | (and1 & and3) | (and1 & and2);

// Calculate the sum and carry-out
assign S = {xor3[2:0], xor2[1:0], xor1[0]} ^ {or1, or2, 1'b0}; // Use 1'b0 for width consistency
assign Cout = or1 | or2;

endmodule