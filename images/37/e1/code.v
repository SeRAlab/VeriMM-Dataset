module chebyshev_filter (
    input [3:0] in_signal,
    output [3:0] out_signal
);
    // Example filter coefficients for Chebyshev filter
    parameter a1 = 4'b0001; // Example coefficient
    parameter a2 = 4'b0011; // Example coefficient

    reg [3:0] temp;

    always @(*) begin
        temp = (a1 * in_signal + a2 * in_signal) >> 1; // Simple transformation
    end

    assign out_signal = temp;
endmodule