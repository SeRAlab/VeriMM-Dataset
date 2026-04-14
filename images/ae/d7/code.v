module top_module(A, B, sub, S, Cout);input [3:0] A, B;
input sub;
output [3:0] S;
output Cout;

wire [3:0] B_comp;
wire [4:0] temp;

// Complement B if sub is high
assign B_comp = sub ? (~B + 1) : B;

// Calculate the sum or difference
assign temp = {1'b0, A} + {1'b0, B_comp, sub};

// Assign the output
assign S = temp[3:0];
assign Cout = temp[4];

endmodule