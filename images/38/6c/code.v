module linear_regression #(parameter W1 = 1, W2 = 1, parameter B = 0) (  
    input wire [31:0] x1,  
    input wire [31:0] x2,  
    output wire [31:0] y  
);  
    assign y = W1 * x1 + W2 * x2 + B;  
endmodule