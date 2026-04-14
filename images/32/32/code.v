module butterworth_filter (
    input [4:0] x,       // 5-bit input signal
    output reg [4:0] y   // 5-bit output filtered signal
);
    reg [4:0] a1, a2;    // internal states for filter coefficients
    reg [4:0] b0, b1, b2; // filter coefficients (to be defined)

    always @(*) begin
        // Butterworth filter coefficients for a 2nd order low-pass filter
        b0 = 5'b00011; // Example coefficients (scaled)
        b1 = 5'b00011;
        b2 = 5'b00000; // No feedback (for simplicity)
        
        // Update filter output
        y = (b0 * x + b1 * a1 + b2 * a2) >> 2; // simple fixed-point arithmetic
        // Update states for next cycle
        a2 = a1;
        a1 = y;
    end
endmodule