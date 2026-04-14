module dynamic_range_compressor (
    input [9:0] input_signal,
    input [9:0] threshold,
    input [9:0] compression_ratio,
    output reg [9:0] output_signal
);
    always @(*) begin
        if (input_signal < threshold) begin
            output_signal = input_signal;
        end else begin
            output_signal = threshold + ((input_signal - threshold) / compression_ratio);
        end
    end
endmodule