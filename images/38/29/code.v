module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] channel_enable,
    output reg [7:0] channel_data_out,
    output reg [2:0] active_channel
);
    reg [2:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 3'b000;
            active_channel <= 3'b000;
            channel_data_out <= 8'b00000000;
        end
        else if (start) begin
            active_channel <= current_channel;
            if (channel_enable[current_channel]) begin
                channel_data_out <= current_channel; // Mock data for demonstration
                current_channel <= (current_channel + 1) % 8; // Round-robin
            end
        end
    end
endmodule