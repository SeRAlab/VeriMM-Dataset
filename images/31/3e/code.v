module dma_controller (  
    input wire clk,  
    input wire [2:0] channel_select,  
    input wire enable,  
    output reg [7:0] channel_output  
);  
  
    always @(posedge clk) begin  
        if (enable) begin  
            channel_output <= (1 << channel_select);  
        end else begin  
            channel_output <= 8'b00000000;  
        end  
    end  
endmodule