module dma_controller(  
    input clk,  
    input reset,  
    input [2:0] channel_select,  
    input start,  
    output reg transfer_complete,  
    output reg [2:0] active_channel  
);  
  
    reg [7:0] channel_enable;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            transfer_complete <= 0;  
            active_channel <= 3'b000;  
            channel_enable <= 8'b00000000;  
        end else begin  
            if (start) begin  
                channel_enable[channel_select] <= 1;  
                active_channel <= channel_select;  
                // Simulate data transfer
                // In a real case, we would have a data transfer delay
                // Here we just set transfer_complete after one clock cycle for simulation
                transfer_complete <= 1;  
            end else begin  
                transfer_complete <= 0;  
            end  
  
            // Disable channel after completion
            if (transfer_complete) begin  
                channel_enable[active_channel] <= 0;  
            end  
        end  
    end  
endmodule