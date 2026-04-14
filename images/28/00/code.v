module chebyshev_filter (
    input [1:0] x,    // 2-bit input signal
    input clk,
    output reg [1:0] y // 2-bit output signal
);
    // Coefficients for the Chebyshev filter (example values)
    parameter a0 = 2'b01; // Coefficient for input
    parameter a1 = 2'b10; // Coefficient for previous input
    parameter a2 = 2'b01; // Coefficient for previous output
    reg [1:0] x_prev; // Previous input
    reg [1:0] y_prev; // Previous output

    always @(posedge clk) begin
        // Update previous inputs/outputs
        x_prev <= x;
        y_prev <= y;
        // Filter logic (2nd order)
        y <= a0 * x + a1 * x_prev + a2 * y_prev;
    end

endmodule