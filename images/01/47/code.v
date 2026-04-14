module butterworth_filter (
    input [7:0] x,         // Input signal
    output reg [7:0] y     // Output signal
);

    // Define Butterworth filter coefficients
    parameter [7:0] b0 = 8'd1;
    parameter [7:0] b1 = 8'd2;
    parameter [7:0] b2 = 8'd3;
    parameter [7:0] b3 = 8'd4;
    parameter [7:0] b4 = 8'd5;

    reg [15:0] z0, z1, z2, z3, z4; // Intermediate storage

    always @(*) begin
        // Apply the filter calculation
        z0 = b0 * x;
        z1 = b1 * (z0 >> 8);
        z2 = b2 * (z1 >> 8);
        z3 = b3 * (z2 >> 8);
        z4 = b4 * (z3 >> 8);
        y = (z0 + z1 + z2 + z3 + z4) >> 8; // Final output
    end
endmodule