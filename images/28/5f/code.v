module dma_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] channel_select,
    input wire channel_request,
    output reg [7:0] busy
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        busy <= 8'b00000000; // Clear all busy channels
    end else begin
        if (channel_request) begin
            busy[channel_select] <= 1'b1; // Set the selected channel to busy
        end else begin
            busy[channel_select] <= 1'b0; // Clear the busy status for the selected channel
        end
    end
end

endmodule