module dma_controller (
    input wire clk,
    input wire rst_n,
    input wire [7:0] req, // Request lines for 8 channels
    output reg [7:0] ack, // Acknowledge lines for 8 channels
    output reg busy,       // Signal to indicate busy status
    output reg transfer_complete // Signal to indicate transfer completion
);
    reg [2:0] current_channel; // Channel currently being serviced

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ack <= 8'b0;
            busy <= 1'b0;
            transfer_complete <= 1'b0;
            current_channel <= 3'b0;
        end else begin
            if (busy) begin
                ack <= 8'b0; // Clear all acknowledges
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                // Move to the next channel
                if (current_channel == 3'b111) begin
                    current_channel <= 3'b0; // Wrap around
                end else begin
                    current_channel <= current_channel + 1;
                end
                // Check if the current channel requested transfer
                if (req[current_channel]) begin
                    transfer_complete <= 1'b1; // Indicate transfer is complete
                end else begin
                    transfer_complete <= 1'b0; // No transfer if no request
                end
            end else begin
                // Check for any active requests
                if (req != 8'b0) begin
                    busy <= 1'b1; // Set busy if any request is active
                    current_channel <= 3'b0; // Start from the first channel
                end
            end
        end
    end
endmodule