module butterworth_filter (
    input wire [7:0] x,        // Current input sample
    input wire [7:0] y_prev,   // Previous output sample
    output wire [7:0] y        // Filtered output sample
);
    // Coefficients for the 2nd order Butterworth filter
    parameter K1 = 8'd70; // Example coefficient for the first stage
    parameter K2 = 8'd30; // Example coefficient for the second stage

    assign y = (K1 * x + K2 * y_prev) >> 8; // Shift right to avoid overflow
endmodule