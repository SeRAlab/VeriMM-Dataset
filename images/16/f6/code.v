module linear_regression(  
    input [15:0] x,  
    input [15:0] m,  
    input [15:0] b,  
    output reg [15:0] y_pred  
);  

    always @(*) begin  
        y_pred = (m * x) + b;  
    end  
endmodule