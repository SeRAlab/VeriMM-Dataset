module dma_controller (
    input clk,
    input reset,
    input [7:0] req,
    output reg [7:0] grant
);
    reg [2:0] current_channel; // To keep track of the current channel to grant

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 8'b00000000; // No grants on reset
            current_channel <= 3'b000; // Start from channel 0
        end else begin
            // Grant the current channel if there is a request
            if (req[current_channel]) begin
                grant <= 8'b00000000; // Clear previous grants
                grant[current_channel] <= 1'b1; // Grant current channel
            end else begin
                // Move to the next channel in round-robin fashion
                current_channel <= (current_channel + 1) % 8;
            end
        end
    end
endmodule