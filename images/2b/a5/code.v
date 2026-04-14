module butterworth_filter (
    input [3:0] x, // 4-bit input signal
    output reg [3:0] y // 4-bit output signal
);
    // Butterworth filter coefficients
    parameter a1 = 4'b0001; // Coefficient for x[n-1]
    parameter a2 = 4'b0010; // Coefficient for x[n-2]
    parameter b0 = 4'b0011; // Coefficient for x[n]
    
    always @(*) begin
        // Simple 2nd order Butterworth filter equation
        y = (b0 * x) + (a1 * x) + (a2 * x);
    end
endmodule