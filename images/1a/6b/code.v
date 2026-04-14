module polynomial_evaluator(  
    input [3:0] x,  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] d,  
    output [11:0] result  
);  
    wire [11:0] x2, x3;  
    wire [11:0] term_a, term_b, term_c, term_d;  
    
    assign x2 = x * x;  
    assign x3 = x2 * x;  
    
    assign term_a = a * x3;  
    assign term_b = b * x2;  
    assign term_c = c * x;  
    assign term_d = d;  
    
    assign result = term_a + term_b + term_c + term_d;  
endmodule