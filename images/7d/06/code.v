module top_module(A, B, SUB, R, COUT);input [3:0] A, B;
input SUB;
output [3:0] R;
output COUT;

wire [3:0] B_comp;
wire [3:0] temp;
wire [4:0] result;

// Complement B if SUB is 1
assign B_comp = SUB ? ~B + 1 : B;

// Calculate the result
assign temp = A + B_comp;
assign result = {1'b0, temp};

// Output the result and carry-out
assign R = SUB ? ~temp + 1 : result[3:0];
assign COUT = result[4];

endmodule