module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] request,  // Request signals for 4 channels
    output reg [1:0] grant      // Grant signal indicating which channel is granted access
);
    reg [1:0] current_channel; // To keep track of the current channel

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 2'b00; // Reset to first channel
            grant <= 2'b00;
        end else begin
            if (request[current_channel]) begin
                grant <= current_channel; // Grant current channel
            end else begin
                // Round-robin logic to find next channel to grant
                current_channel <= current_channel + 1;
                if (current_channel == 2'b11) begin
                    current_channel <= 2'b00; // Wrap around
                end
                if (request[current_channel]) begin
                    grant <= current_channel; // Grant new channel if requested
                end
            end
        end
    end
endmodule