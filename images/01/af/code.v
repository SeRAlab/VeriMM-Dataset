module fixed_point_multiplier(  
    input signed [15:0] a,  
    input signed [15:0] b,  
    output signed [31:0] product  
);  
    wire signed [31:0] a_extended;  
    wire signed [31:0] b_extended;  
    assign a_extended = {a, 16'b0};  
    assign b_extended = {b, 16'b0};  
    assign product = a_extended * b_extended >> 15;  
endmodule