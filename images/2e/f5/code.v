module polynomial_evaluator (  
    input [3:0] a, // Coefficient a  
    input [3:0] b, // Coefficient b  
    input [3:0] c, // Coefficient c  
    input [3:0] d, // Coefficient d  
    input [3:0] x, // Variable x  
    output [15:0] result // Result of the polynomial evaluation  
);  
    wire [15:0] x2, x3;  
    wire [15:0] term1, term2, term3, term4;  
   
    assign x2 = x * x;  
    assign x3 = x2 * x;  
   
    assign term1 = a * x3;  
    assign term2 = b * x2;  
    assign term3 = c * x;  
    assign term4 = d;  
   
    assign result = term1 + term2 + term3 + term4;  
endmodule