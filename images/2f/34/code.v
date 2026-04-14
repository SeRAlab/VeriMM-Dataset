module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] channel_enable, // Enable signals for channels 0 to 3
    input wire request,               // Request signal to start transfer
    output reg [3:0] transfer_complete // Completion signals for channels
);

    reg [1:0] current_channel; // Tracks the currently active channel

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            transfer_complete <= 4'b0000;
            current_channel <= 2'b00;
        end else if (request) begin
            if (channel_enable[current_channel]) begin
                // Simulate data transfer for the current channel
                transfer_complete[current_channel] <= 1'b1;
            end
            // Move to the next channel based on priority
            current_channel <= current_channel + 1;
            if (current_channel == 2'b11) begin
                current_channel <= 2'b00; // Loop back to channel 0
            end
        end
    end
endmodule