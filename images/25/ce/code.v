module fir_filter (
    input [3:0] x, // 4-bit input
    output [3:0] y // 4-bit output
);
    // Coefficients for the FIR filter
    reg [3:0] h [0:3]; // Coefficients array
    integer i;

    // Initialize coefficients
    initial begin
        h[0] = 4'b0001; // Coefficient 1
        h[1] = 4'b0010; // Coefficient 2
        h[2] = 4'b0011; // Coefficient 3
        h[3] = 4'b0100; // Coefficient 4
    end

    // Compute the output
    assign y = (x * h[0]) + (x * h[1]) + (x * h[2]) + (x * h[3]);

endmodule