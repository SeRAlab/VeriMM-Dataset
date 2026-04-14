module chebyshev_filter (
    input [4:0] in_signal,
    output reg [4:0] out_signal
);
    always @(*) begin
        // Simple Chebyshev approximation (not a real implementation)
        out_signal = {in_signal[4], in_signal[3] ^ in_signal[2], in_signal[1], in_signal[0], 1'b0};
    end
endmodule