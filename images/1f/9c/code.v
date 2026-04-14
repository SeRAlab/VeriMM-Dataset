module clock_gating_reset(  
    input wire clk,  
    input wire rst,  
    input wire clk_gating_ctrl,  
    output reg gated_rst  
);  
    always @(posedge clk) begin  
        if (clk_gating_ctrl) begin  
            gated_rst <= rst;  
        end else begin  
            gated_rst <= 1'b0;  
        end  
    end  
endmodule