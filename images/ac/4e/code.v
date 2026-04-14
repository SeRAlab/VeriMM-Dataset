module top_module(A, B, Cin, S, Cout);input [3:0] A;
input [3:0] B;
input Cin;
output [3:0] S;
output Cout;

wire [3:0] temp_x;  // renamed from X to temp_x for clarity
wire [3:0] temp_y;  // renamed from Y to temp_y for clarity

// Generate sum bits
assign temp_x[0] = A[0] ^ B[0] ^ Cin;
assign temp_x[1] = A[1] ^ B[1] ^ (A[0] & B[0] | Cin & (A[0] ^ B[0]));
assign temp_x[2] = A[2] ^ B[2] ^ (A[1] & B[1] | (A[0] & B[0] & Cin));
assign temp_x[3] = A[3] ^ B[3] ^ (A[2] & B[2] | (A[1] & B[1] & (A[0] & B[0] | Cin)));

// Assign sum output
assign S = temp_x;

// Generate carry-out bit
assign Cout = (A[3] & B[3]) | (A[2] & B[2] & (A[3] | B[3])) |
               (A[1] & B[1] & (A[2] | B[2]) & (A[3] | B[3])) |
               (A[0] & B[0] & (A[1] | B[1]) & (A[2] | B[2]) & (A[3] | B[3])) |
               (Cin & (A[3] | B[3] | (A[2] & B[2]) | (A[1] & B[1]) | (A[0] & B[0])));

endmodule