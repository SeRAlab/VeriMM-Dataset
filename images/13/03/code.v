module Adder_5bit(  
    input [4:0] A,  
    input [4:0] B,  
    output [5:0] Sum  
);  
    assign Sum = A + B;  
endmodule