module dma_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] req, // request lines for 8 channels
    output reg [7:0] ack, // acknowledge lines for 8 channels
    output reg [7:0] data // data bus for transferring 8 bits of data
);

    reg [2:0] current_channel; // 3-bit channel selector

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 8'b0;
            current_channel <= 3'b0;
        end else begin
            ack <= 8'b0; // Clear all acknowledges
            if (req != 8'b0) begin // If there are any requests
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                data <= 8'hFF; // Simulated data transfer (example data)
                current_channel <= (current_channel + 1) % 8; // Round-robin
            end
        end
    end
endmodule