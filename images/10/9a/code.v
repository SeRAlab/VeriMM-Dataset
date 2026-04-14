module fixed_point_multiply(  
    input [15:0] a,  
    input [15:0] b,  
    output [31:0] result  
);  
    wire signed [23:0] a_extended = {a, 8'b0}; // Extend a to 24 bits  
    wire signed [23:0] b_extended = {b, 8'b0}; // Extend b to 24 bits  
    assign result = a_extended * b_extended;  
endmodule