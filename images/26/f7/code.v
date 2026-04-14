module FourBitAdder(  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] S  
);  
    assign S = A + B;  
endmodule