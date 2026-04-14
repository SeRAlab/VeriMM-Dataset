module dma_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] req,
    output reg [7:0] grant,
    output reg [7:0] ack
);

    reg [2:0] current_channel; // To keep track of the current channel

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 8'b0;
            ack <= 8'b0;
            current_channel <= 3'b0;
        end else begin
            // Clear current grant and ack signals
            grant <= 8'b0;
            ack <= 8'b0;
            
            // Round-robin grant logic
            if (req != 8'b0) begin
                // Grant the current channel if the request is active
                if (req[current_channel]) begin
                    grant[current_channel] <= 1'b1;
                    ack[current_channel] <= 1'b1; // Acknowledge the grant
                end else begin
                    // Move to the next channel
                    current_channel <= (current_channel + 1) % 8;
                end
            end
        end
    end
endmodule