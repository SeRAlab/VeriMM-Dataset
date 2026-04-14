module adder_8bit(A, B, Sum, CarryOut);
input [7:0] A;
input [7:0] B;
output [7:0] Sum;
output CarryOut;

assign {CarryOut, Sum} = A + B;

endmodule