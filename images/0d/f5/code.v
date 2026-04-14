module fir_filter (
    input [3:0] x,        // 4-bit input
    output reg [3:0] y    // 4-bit output
);
    // Coefficients for the 4-tap FIR filter
    parameter [3:0] h0 = 4'b0001; // Coefficient 0
    parameter [3:0] h1 = 4'b0010; // Coefficient 1
    parameter [3:0] h2 = 4'b0011; // Coefficient 2
    parameter [3:0] h3 = 4'b0100; // Coefficient 3

    reg [7:0] accumulator; // Accumulated value for the filter output

    always @(*) begin
        // Compute the FIR filter output
        accumulator = (h0 * x) + (h1 * x) + (h2 * x) + (h3 * x);
        y = accumulator[3:0]; // Take the lower 4 bits as output
    end
endmodule