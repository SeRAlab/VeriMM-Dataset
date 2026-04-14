module fixed_point_multiplier(  
    input [7:0] a,  
    input [7:0] b,  
    output [15:0] result  
);  
    // Perform multiplication and adjust for fixed-point scaling  
    wire [15:0] product;  
    assign product = a * b;  
    assign result = product >> 4;  // Adjust for scaling (4 bits for fractional part)  
endmodule