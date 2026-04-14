module dma_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] channel_select,
    output reg [2:0] selected_channel
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        selected_channel <= 3'b000; // Reset state
    end else begin
        selected_channel <= channel_select; // Update channel
    end
end

endmodule