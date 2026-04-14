module butterworth_filter (
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    // Coefficients for a simple 5th-order Butterworth filter (for demonstration purposes)
    parameter a0 = 5'b00001; // Example coefficient for 1st term
    parameter a1 = 5'b00010; // Example coefficient for 2nd term
    parameter a2 = 5'b00011; // Example coefficient for 3rd term
    parameter a3 = 5'b00100; // Example coefficient for 4th term
    parameter a4 = 5'b00101; // Example coefficient for 5th term

    always @(*) begin
        signal_out = (a0 * signal_in + a1 * signal_in + a2 * signal_in + a3 * signal_in + a4 * signal_in) >> 2; // simple accumulation with shift
    end
endmodule