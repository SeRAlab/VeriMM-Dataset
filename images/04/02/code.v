module dma_controller(
    input wire clk,
    input wire reset,
    input wire [1:0] channel_select,
    input wire [3:0] req,  // Request lines for 4 channels
    output reg [3:0] ack    // Acknowledge lines for 4 channels
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 4'b0000; // Reset acknowledge lines
            current_channel <= 2'b00; // Reset current channel
        end else begin
            // Check for requests and acknowledge the selected channel
            if (req[channel_select]) begin
                ack <= 4'b0000; // Reset all acknowledges
                ack[channel_select] <= 1'b1; // Acknowledge the selected channel
            end else begin
                ack <= 4'b0000; // No requests, no acknowledges
            end
        end
    end
endmodule