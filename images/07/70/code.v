module dynamic_range_compressor (
    input [4:0] in_signal,
    output reg [4:0] out_signal
);

always @(*) begin
    if (in_signal > 5'd15) begin
        out_signal = 5'd15; // Compress to max value of 15
    end else begin
        out_signal = in_signal; // No compression
    end
end

endmodule