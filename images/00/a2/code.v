module Adder64 (
    input [63:0] A, 
    input [63:0] B, 
    output [63:0] SUM, 
    output CARRY_OUT
);
    assign {CARRY_OUT, SUM} = A + B;
endmodule