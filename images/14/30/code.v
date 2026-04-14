module dma_controller (
    input wire clk,
    input wire rst,
    input wire [2:0] channel_select,
    output reg [7:0] channel_enable
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            channel_enable <= 8'b00000000; // Reset all channels
        end else begin
            channel_enable <= 8'b00000000; // Disable all channels
            channel_enable[channel_select] <= 1'b1; // Enable selected channel
        end
    end
endmodule