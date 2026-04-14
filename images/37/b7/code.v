module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [3:0] req, // request signals for 4 channels  
    output reg [1:0] channel, // current active channel  
    output reg busy // indicates if a transfer is in progress  
);  
    reg [1:0] current_channel;  
    reg [3:0] channel_mask; // to keep track of active channels  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_channel <= 0;  
            busy <= 0;  
            channel <= 0;  
        end else if (start) begin  
            channel_mask <= req;  
            busy <= 1;  
            current_channel <= 0;  
            channel <= 0;  
        end else if (busy) begin  
            if (channel_mask[current_channel]) begin  
                channel <= current_channel;  
                // Simulate transfer complete after one clock cycle for simplicity  
                busy <= 0;  
                channel_mask[current_channel] <= 0;  
            end else begin  
                current_channel <= (current_channel + 1) % 4;  
            end  
        end  
    end  
endmodule