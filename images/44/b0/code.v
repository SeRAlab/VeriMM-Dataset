module top_module(A, B, Ci, R, Co);input wire A, B, Ci;
output wire R, Co;

assign {Co, R} = A + B + Ci;endmodule