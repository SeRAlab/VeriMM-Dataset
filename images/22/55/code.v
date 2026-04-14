module dma_controller (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [2:0] channel_select,
    output reg [7:0] active_channel
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        active_channel <= 8'b00000000;
    end else if (enable) begin
        active_channel <= 8'b00000000; // Clear previous channel
        active_channel[channel_select] <= 1'b1; // Set active channel
    end
end

endmodule