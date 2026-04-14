module dma_controller(  
    input wire clk,  
    input wire enable,  
    input wire [2:0] channel_select,  
    output reg [7:0] grant  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            grant <= 8'b00000000;  // Reset all grants  
            grant[channel_select] <= 1'b1;  // Grant the selected channel  
        end else begin  
            grant <= 8'b00000000;  // Reset all grants if not enabled  
        end  
    end  
endmodule