module polynomial_evaluator (  
    input signed [3:0] a,  
    input signed [3:0] b,  
    input signed [3:0] c,  
    input signed [3:0] x,  
    output signed [7:0] result  
);  
    wire signed [7:0] ax2;  
    wire signed [7:0] bx;  
    assign ax2 = a * x * x;  
    assign bx = b * x;  
    assign result = ax2 + bx + c;  
endmodule