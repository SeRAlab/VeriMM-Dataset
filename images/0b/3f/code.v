module adder_32bit(  
    input [31:0] A,  
    input [31:0] B,  
    output [31:0] Sum,  
    output Overflow  
);  
    assign {Overflow, Sum} = A + B;  
endmodule