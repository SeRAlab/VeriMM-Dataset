module adder_32bit(  
    input [31:0] A,  
    input [31:0] B,  
    output [31:0] S,  
    output CO  
);  
    assign {CO, S} = A + B;  
endmodule