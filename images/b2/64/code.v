module top_module(input [3:0] A, input [3:0] B, output [3:0] S, output carry);// Basic 4-bit adder implementation
    assign {carry, S} = A + B;
endmodule