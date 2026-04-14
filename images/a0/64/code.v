module top_module(
    input clk,
    input reset,
    input [11:0] sensor_signal,
    output reg [15:0] output_signal
);always @(posedge clk) begin
        if (reset) begin
            output_signal <= 16'h0000;
        end else begin
            output_signal[15:12] <= 4'b0000;
            output_signal[11:0] <= sensor_signal;
        end
    end

endmodule