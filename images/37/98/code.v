module portfolio_optimizer(  
    input clk,  
    input reset,  
    input [15:0] asset1_return,  
    input [15:0] asset2_return,  
    input [15:0] asset3_return,  
    input [15:0] asset1_risk,  
    input [15:0] asset2_risk,  
    input [15:0] asset3_risk,  
    output reg [15:0] weight1,  
    output reg [15:0] weight2,  
    output reg [15:0] weight3  
);  
    reg [15:0] total_return;  
    reg [15:0] total_risk;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            weight1 <= 0;  
            weight2 <= 0;  
            weight3 <= 0;  
        end  
        else begin  
            total_return = asset1_return + asset2_return + asset3_return;  
            total_risk = asset1_risk + asset2_risk + asset3_risk;  
            weight1 <= (asset1_return * 100) / total_return;  
            weight2 <= (asset2_return * 100) / total_return;  
            weight3 <= (asset3_return * 100) / total_return;  
        end  
    end  
endmodule