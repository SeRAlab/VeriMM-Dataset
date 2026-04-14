module dma_controller (
    input clk,
    input reset,
    input [7:0] req,
    output reg [7:0] ack
);
    reg [2:0] current_channel;
    reg [7:0] service_mask;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 8'b0;
            current_channel <= 3'b0;
            service_mask <= 8'b0;
        end else begin
            ack <= 8'b0; // Clear ack for this cycle
            // Check for requests and service the next available one in round-robin
            if (service_mask != 8'b0) begin
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                service_mask[current_channel] <= 1'b0; // Clear the serviced channel
            end else begin
                // Find the next channel to service
                current_channel <= (current_channel + 1) % 8; // Move to next channel
                if (req[current_channel]) begin
                    ack[current_channel] <= 1'b1; // Acknowledge if there's a request
                    service_mask[current_channel] <= 1'b1; // Mark this channel as serviced
                end
            end
        end
    end
endmodule