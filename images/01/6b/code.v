module fixed_point_multiplier(  
    input [15:0] a,  
    input [15:0] b,  
    output [15:0] result  
);  
    wire [31:0] product;  
    assign product = a * b;  
    assign result = product[23:8]; // Shift right to adjust the fixed-point format  
endmodule