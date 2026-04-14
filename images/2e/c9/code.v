module butterworth_filter (
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    // Coefficients for a simple 2nd order Butterworth filter
    reg [4:0] a1 = 5'b00011; // Example coefficient
    reg [4:0] a2 = 5'b00010; // Example coefficient
    reg [4:0] b0 = 5'b00001; // Example coefficient

    reg [4:0] x1, x2; // Previous inputs
    reg [4:0] y1, y2; // Previous outputs

    always @* begin
        // Implementing the filter output equation: y[n] = b0*x[n] + a1*y[n-1] + a2*y[n-2]
        signal_out = b0 * signal_in + a1 * y1 + a2 * y2;
        // Update previous values
        x2 = x1;
        x1 = signal_in;
        y2 = y1;
        y1 = signal_out;
    end
endmodule