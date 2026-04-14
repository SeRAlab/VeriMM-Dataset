module dynamic_range_compressor (
    input [4:0] in_signal,
    output reg [4:0] out_signal
);

always @(*) begin
    if (in_signal < 5'b01000) begin
        out_signal = in_signal; // Unchanged
    end else if (in_signal < 5'b10000) begin
        out_signal = in_signal >> 1; // Halved
    end else begin
        out_signal = 5'b11111; // Clamped to 15
    end
end

endmodule