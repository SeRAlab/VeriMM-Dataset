module linear_regression(  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] w1,  
    input [15:0] w2,  
    input [15:0] b,  
    output reg [31:0] y  
);  
    always @(*) begin  
        y = (w1 * x1) + (w2 * x2) + b;  
    end  
endmodule