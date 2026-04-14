module fixed_point_multiplier(  
    input [7:0] a,  
    input [7:0] b,  
    output [15:0] product  
);  
    // Multiplication of fixed-point numbers  
    assign product = a * b;  
endmodule