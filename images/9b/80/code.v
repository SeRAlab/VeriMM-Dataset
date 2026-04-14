module top_module(A, B, X, Y);input A;
input B;
output X;
output Y;

wire X_wire;
wire Y_wire;

and(X_wire, A, B);
xor(Y_wire, A, B);

assign X = X_wire;
assign Y = Y_wire;

endmodule