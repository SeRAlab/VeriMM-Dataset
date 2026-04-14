module portfolio_optimizer(  
    input [15:0] investment1,  
    input [15:0] investment2,  
    input [15:0] investment3,  
    input [7:0] weight1,  
    input [7:0] weight2,  
    input [7:0] weight3,  
    output reg [15:0] total_value  
);  
    always @(*) begin  
        total_value = (investment1 * weight1 + investment2 * weight2 + investment3 * weight3) / 100;  
    end  
endmodule