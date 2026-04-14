module dma_controller(  
    input wire clk,  
    input wire enable,  
    input wire [2:0] channel_select,  
    output reg [7:0] active_channel  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            active_channel <= (1 << channel_select);  
        end else begin  
            active_channel <= 8'b00000000;  
        end  
    end  
endmodule