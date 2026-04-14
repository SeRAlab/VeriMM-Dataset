module dynamic_range_compressor (
    input [7:0] in_signal,
    input [7:0] threshold,
    output reg [7:0] out_signal
);
    parameter COMPRESSION_RATIO = 4; // Compression ratio

    always @(*) begin
        if (in_signal > threshold) begin
            out_signal = threshold + (in_signal - threshold) / COMPRESSION_RATIO;
        end else begin
            out_signal = in_signal;
        end
    end
endmodule