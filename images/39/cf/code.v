module butterworth_filter (
    input  [4:0] signal_in,
    output [4:0] signal_out
);
    // Fixed filter coefficients for a 4th-order Butterworth filter
    reg [4:0] b0 = 5'b00001; // Coefficient for x[n]
    reg [4:0] b1 = 5'b00010; // Coefficient for x[n-1]
    reg [4:0] b2 = 5'b00001; // Coefficient for x[n-2]
    reg [4:0] b3 = 5'b00010; // Coefficient for x[n-3]
    reg [4:0] b4 = 5'b00001; // Coefficient for x[n-4]

    reg [4:0] x [0:4]; // Input signal history
    reg [4:0] y;       // Filter output

    always @(*) begin
        // Shift history
        x[0] = signal_in;
        x[1] = x[0];
        x[2] = x[1];
        x[3] = x[2];
        x[4] = x[3];

        // Compute the filter output using the coefficients
        y = (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] + b4 * x[4]) >> 2; // Adjusting for scaling
    end

    assign signal_out = y;
endmodule