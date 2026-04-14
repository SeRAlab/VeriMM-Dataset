module dma_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] req,       // Request signals for 4 channels
    output reg [3:0] ack,       // Acknowledge output for 4 channels
    output reg [1:0] active_channel // Active channel being serviced
);

    reg [1:0] priority_channel; // Channel with highest priority request
    reg [3:0] channel_enable;    // Enables for each channel

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 4'b0000;
            active_channel <= 2'b00;
        end else begin
            channel_enable <= req; // Update enabled channels

            // Find the highest priority channel
            if (channel_enable[3]) priority_channel <= 2'b11;
            else if (channel_enable[2]) priority_channel <= 2'b10;
            else if (channel_enable[1]) priority_channel <= 2'b01;
            else if (channel_enable[0]) priority_channel <= 2'b00;

            // Service the highest priority channel
            if (req[priority_channel]) begin
                ack[priority_channel] <= 1; // Acknowledge the request
                active_channel <= priority_channel; // Set active channel
            end else begin
                ack <= 4'b0000; // Clear ack if no requests
            end
        end
    end
endmodule