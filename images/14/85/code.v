module cordic_sine_cosine (
    input [15:0] angle, // Input angle in fixed-point format
    output reg [15:0] sine,  // Output sine value in fixed-point format
    output reg [15:0] cosine  // Output cosine value in fixed-point format
);
    parameter N = 16; // Number of iterations
    reg [15:0] x [0:N-1]; // X values
    reg [15:0] y [0:N-1]; // Y values
    reg [15:0] z [0:N-1]; // Z values (angle)
    integer i;

    initial begin
        // Initialize x, y, and z for first iteration
        x[0] = 16'h4000; // x(0) = 1.0 in fixed-point
        y[0] = 16'h0000; // y(0) = 0.0 in fixed-point
        z[0] = angle; // Input angle
        
        // Precompute arctan values for each iteration
        for (i = 1; i < N; i = i + 1) begin
            z[i] = z[i-1] - (16'h4000 >> (i-1)); // Approximation of arctan(1/2^i)
            x[i] = x[i-1] - (y[i-1] >> (i-1)); // x(i) = x(i-1) - (y(i-1)/2^i)
            y[i] = y[i-1] + (x[i-1] >> (i-1)); // y(i) = y(i-1) + (x(i-1)/2^i)
        end
        
        // Final output values
        sine = y[N-1];
        cosine = x[N-1];
    end
endmodule