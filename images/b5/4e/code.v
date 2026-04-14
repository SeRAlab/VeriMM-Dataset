module top_module(A1, A2, A3, O);input   A1;
input   A2;
input   A3;
output  O;

wire or1;

assign or1 = A1 | A2 | A3;
assign O = or1;

endmodule