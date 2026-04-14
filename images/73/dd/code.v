module top_module(
    input clk,
    input reset,
    input [31:0] input_signal,
    output reg [15:0] output_signal
);always @(posedge clk) begin
    if (reset) begin
        output_signal <= 16'd0;
    end else begin
        output_signal <= (input_signal[31:16] + input_signal[15:0]);
    end
end

endmodule