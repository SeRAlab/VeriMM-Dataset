module dma_controller (
    input clk,
    input [3:0] req, // Request signals for 4 channels
    output reg [3:0] ack, // Acknowledge signals for 4 channels
    output reg [7:0] data_out // Data output
);
    reg [1:0] current_channel;

    always @(posedge clk) begin
        // Round-robin channel selection
        if (req != 4'b0000) begin
            ack <= 4'b0000; // Clear ack signals
            current_channel <= (current_channel + 1) % 4; // Next channel
            if (req[current_channel]) begin
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                data_out <= 8'hFF; // Example data output
            end
        end else begin
            ack <= 4'b0000; // No requests, clear ack
        end
    end
endmodule