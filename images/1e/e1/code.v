module Adder16Bit(  
    input  [15:0] A,  
    input  [15:0] B,  
    output [15:0] Sum,  
    output        CarryOut  
);  
    assign {CarryOut, Sum} = A + B;  
endmodule