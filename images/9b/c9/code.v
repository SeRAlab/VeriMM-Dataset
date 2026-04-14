module adder_16bit(A, B, SUM);
input [15:0] A, B;
output [15:0] SUM;

assign SUM = A + B;

endmodule