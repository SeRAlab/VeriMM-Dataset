module polynomial_evaluator(  
    input signed [7:0] a,  
    input signed [7:0] b,  
    input signed [7:0] c,  
    input signed [7:0] x,  
    output signed [15:0] result  
);  
    wire signed [15:0] x_squared;  
    wire signed [15:0] ax_squared;  
    wire signed [15:0] bx;  
  
    assign x_squared = x * x;  
    assign ax_squared = a * x_squared;  
    assign bx = b * x;  
    assign result = ax_squared + bx + c;  
endmodule