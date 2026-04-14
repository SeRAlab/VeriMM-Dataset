module dma_controller(
    input clk,
    input rst,
    input [7:0] req,          // Request lines for 8 channels
    output reg [7:0] ack,     // Acknowledge lines for 8 channels
    input mode                // Mode control (0: read, 1: write)
);
    reg [2:0] current_channel; // 3-bit channel index

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 3'b000;
            ack <= 8'b00000000;
        end else begin
            if (req != 8'b00000000) begin
                ack <= 8'b00000000; // Reset all acknowledges
                ack[current_channel] <= 1'b1; // Acknowledge current channel
                // Move to next channel in round-robin
                current_channel <= (current_channel == 3'b111) ? 3'b000 : current_channel + 3'b001;
            end else begin
                ack <= 8'b00000000; // No requests
            end
        end
    end
endmodule