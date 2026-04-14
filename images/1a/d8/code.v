module polynomial_evaluator(  
    input [3:0] x,  
    input [3:0] a0,  
    input [3:0] a1,  
    input [3:0] a2,  
    input [3:0] a3,  
    output [7:0] P  
);  
    wire [7:0] x_squared;  
    wire [7:0] x_cubed;  
    wire [7:0] term1;  
    wire [7:0] term2;  
    wire [7:0] term3;  
    wire [7:0] term4;  

    assign x_squared = x * x;  
    assign x_cubed = x_squared * x;  

    assign term1 = a0;  
    assign term2 = a1 * x;  
    assign term3 = a2 * x_squared;  
    assign term4 = a3 * x_cubed;  

    assign P = term1 + term2 + term3 + term4;  
endmodule