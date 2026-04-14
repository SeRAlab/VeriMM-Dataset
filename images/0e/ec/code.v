module dynamic_range_compressor (
    input [7:0] in_signal,
    input [7:0] threshold,
    output reg [7:0] out_signal
);
    always @(*) begin
        if (in_signal > threshold) begin
            out_signal = threshold + (in_signal - threshold) / 2; // Simple compression
        end else begin
            out_signal = in_signal; // No compression
        end
    end
endmodule