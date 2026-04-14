module dynamic_range_compressor (
    input wire clk,
    input wire reset,
    input wire signed [15:0] input_signal,
    input wire signed [15:0] threshold,
    input wire signed [15:0] compression_ratio,
    output reg signed [15:0] output_signal
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
        end else begin
            if (input_signal > threshold) begin
                output_signal <= (input_signal - threshold) * compression_ratio / 16 + threshold;
            end else begin
                output_signal <= input_signal;
            end
        end
    end
endmodule