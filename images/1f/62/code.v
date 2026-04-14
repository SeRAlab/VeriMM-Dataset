module adder_16bit(  
    input [15:0] A,  
    input [15:0] B,  
    output [15:0] Sum,  
    output Carry  
);  
    assign {Carry, Sum} = A + B;  
endmodule