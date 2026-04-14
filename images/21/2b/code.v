module polynomial_evaluator(  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    input [3:0] x,  
    output [7:0] result  
);  
    wire [7:0] x_squared;  
    wire [7:0] ax_squared;  
    wire [7:0] bx;  
    wire [7:0] temp_result;  

    assign x_squared = x * x;  
    assign ax_squared = a * x_squared;  
    assign bx = b * x;  
    assign temp_result = ax_squared + bx + c;  
    assign result = temp_result;  
endmodule