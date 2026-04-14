module two_bit_multiplier (  
    input [1:0] a,  
    input [1:0] b,  
    output [3:0] product  
);  
    assign product = a * b;  
endmodule