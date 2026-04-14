module dynamic_range_compressor(
    input [4:0] in_signal,
    output reg [4:0] out_signal
);

always @(*) begin
    if (in_signal <= 5'd15)
        out_signal = in_signal;
    else
        out_signal = 5'd15;
end

endmodule