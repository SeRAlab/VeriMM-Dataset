module dma_controller (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] data_in,  
    output reg [2:0] channel_out  
);  
    reg [2:0] current_channel;  
    reg [7:0] data_buffer;  
    reg active;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_channel <= 3'b000;  
            active <= 1'b0;  
            channel_out <= 3'b000;  
        end else if (start && !active) begin  
            active <= 1'b1;  
            data_buffer <= data_in;  
            channel_out <= current_channel;  
        end else if (active) begin  
            channel_out <= current_channel;  
            // Transfer data logic (simulation of transfer done after one clock)  
            current_channel <= current_channel + 1;  
            if (current_channel == 3'b111) begin  
                active <= 1'b0;  
                current_channel <= 3'b000;  
            end  
        end  
    end  
endmodule