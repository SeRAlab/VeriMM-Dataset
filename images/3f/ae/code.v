module dma_controller (
    input clk,
    input reset,
    input [1:0] channel_enable, // Channel 0 and Channel 1 enable signals
    input [7:0] src_addr_0,     // Source address for channel 0
    input [7:0] src_addr_1,     // Source address for channel 1
    input [7:0] dest_addr_0,    // Destination address for channel 0
    input [7:0] dest_addr_1,    // Destination address for channel 1
    input [7:0] data_in_0,      // Data input for channel 0
    input [7:0] data_in_1,      // Data input for channel 1
    output reg transfer_done_0,  // Transfer done signal for channel 0
    output reg transfer_done_1   // Transfer done signal for channel 1
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_done_0 <= 0;
            transfer_done_1 <= 0;
        end else begin
            if (channel_enable[0]) begin
                // Simulate data transfer for channel 0
                // (In a real scenario, you would write data to an address in memory)
                transfer_done_0 <= 1; // Indicate transfer done
            end else begin
                transfer_done_0 <= 0; // Reset done signal if not enabled
            end

            if (channel_enable[1]) begin
                // Simulate data transfer for channel 1
                transfer_done_1 <= 1; // Indicate transfer done
            end else begin
                transfer_done_1 <= 0; // Reset done signal if not enabled
            end
        end
    end
endmodule