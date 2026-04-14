module bitwise_and_3inputs(  
    input [4:0] A,  
    input [4:0] B,  
    input [4:0] C,  
    output [4:0] Y  
);  
    assign Y = A & B & C;  
endmodule