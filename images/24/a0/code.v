module dma_controller(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [2:0] channel_select,
    output reg [2:0] channel_out,
    output reg busy
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        channel_out <= 3'b000;
        busy <= 1'b0;
    end else if (enable) begin
        channel_out <= channel_select;
        busy <= 1'b1; // Indicate that a channel is in use
    end else begin
        busy <= 1'b0; // No channel is in use
    end
end

endmodule