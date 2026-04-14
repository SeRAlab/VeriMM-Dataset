module butterworth_filter (
    input [4:0] x,        // Input signal
    output reg [4:0] y    // Output signal
);
    // Filter coefficients (example coefficients for a 2nd order Butterworth filter)
    parameter a1 = 5'b00011; // Example coefficient
    parameter a2 = 5'b00001; // Example coefficient
    parameter b0 = 5'b00010; // Example coefficient

    reg [4:0] x_delayed1;    // Delay line for input
    reg [4:0] x_delayed2;    // Delay line for input
    
    always @(*) begin
        // Update delayed signals
        x_delayed1 = x;
        x_delayed2 = x_delayed1;

        // Calculate output using the filter equation
        y = (b0 * x + a1 * x_delayed1 + a2 * x_delayed2) >> 2; // Simple filter equation
    end
endmodule