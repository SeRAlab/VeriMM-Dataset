module dynamic_range_compressor (
    input signed [7:0] in_signal,
    input signed [7:0] threshold,
    input signed [7:0] scale_factor,
    output signed [7:0] out_signal
);
    assign out_signal = (in_signal > threshold) ? (in_signal / scale_factor) : in_signal;
endmodule