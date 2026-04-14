module clock_gating(  
    input clk,  
    input enable,  
    input rst,  
    output gated_clk  
);  
    reg gated_clk_reg;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            gated_clk_reg <= 1'b0;  
        end else if (enable) begin  
            gated_clk_reg <= 1'b1;  
        end else begin  
            gated_clk_reg <= 1'b0;  
        end  
    end  
    assign gated_clk = gated_clk_reg;  
endmodule