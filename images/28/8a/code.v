module dma_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [2:0] channel_select,
    output reg [2:0] selected_channel
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        selected_channel <= 3'b000;
    end else if (enable) begin
        selected_channel <= channel_select;
    end
end

endmodule