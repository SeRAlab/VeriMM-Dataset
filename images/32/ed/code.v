module dynamic_range_compressor(
    input signed [15:0] in_signal,
    input signed [15:0] threshold,
    input signed [15:0] ratio,
    output reg signed [15:0] out_signal
);
    always @(*) begin
        if (in_signal > threshold) begin
            out_signal = threshold + (in_signal - threshold) / ratio;
        end else if (in_signal < -threshold) begin
            out_signal = -threshold + (in_signal + threshold) / ratio;
        end else begin
            out_signal = in_signal;
        end
    end
endmodule