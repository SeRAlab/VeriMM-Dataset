module butterworth_filter (
    input [3:0] x,        // 4-bit input signal
    output reg [3:0] y    // 4-bit output signal
);
    // Butterworth filter coefficients (example values)
    reg [3:0] b0 = 4'b0001; // Coefficient for x[n]
    reg [3:0] b1 = 4'b0010; // Coefficient for x[n-1]
    reg [3:0] b2 = 4'b0001; // Coefficient for x[n-2]
    reg [3:0] a1 = 4'b0011; // Coefficient for y[n-1]
    reg [3:0] a2 = 4'b0001; // Coefficient for y[n-2]

    reg [3:0] x_delayed1, x_delayed2; // Delayed input samples
    reg [3:0] y_delayed1, y_delayed2; // Delayed output samples

    always @(*) begin
        // Calculate filtered output
        y = b0*x + b1*x_delayed1 + b2*x_delayed2 - a1*y_delayed1 - a2*y_delayed2;
        
        // Update delayed signals
        x_delayed2 = x_delayed1; 
        x_delayed1 = x;
        y_delayed2 = y_delayed1; 
        y_delayed1 = y;
    end
endmodule