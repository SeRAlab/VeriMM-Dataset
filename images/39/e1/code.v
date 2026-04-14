module dma_controller(
    input clk,
    input reset,
    input enable,
    input [2:0] channel_select,
    output reg data_valid
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_valid <= 0;
    end else if (enable) begin
        data_valid <= 1; // Data is valid for the selected channel
    end else begin
        data_valid <= 0; // Data is not valid if not enabled
    end
end

endmodule