module fp_multiplier (  
    input [31:0] a,  
    input [31:0] b,  
    output [31:0] result  
);  
    wire [7:0] exponent_a = a[30:23];  
    wire [7:0] exponent_b = b[30:23];  
    wire [23:0] mantissa_a = {1'b1, a[22:0]}; // Implicit leading 1  
    wire [23:0] mantissa_b = {1'b1, b[22:0]}; // Implicit leading 1  
    wire [47:0] mantissa_product = mantissa_a * mantissa_b;  
    wire [7:0] exponent_product = exponent_a + exponent_b - 8'h7F;  
    wire [22:0] result_mantissa = mantissa_product[46:24]; // Take the upper 23 bits  
    assign result = {  
        a[31] ^ b[31],                      // Sign  
        exponent_product,                   // Exponent  
        result_mantissa                     // Mantissa  
    };  
endmodule