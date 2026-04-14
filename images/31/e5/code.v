module Adder16Bit (
    input [15:0] A,
    input [15:0] B,
    output [16:0] Sum
);
    assign Sum = A + B;
endmodule