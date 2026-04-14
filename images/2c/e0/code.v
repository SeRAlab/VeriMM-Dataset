module linear_regression (  
    input [7:0] a,  
    input [7:0] b,  
    input [7:0] x,  
    output reg [9:0] y  
);  
    always @(*) begin  
        y = (a * x) + b;  
    end  
endmodule