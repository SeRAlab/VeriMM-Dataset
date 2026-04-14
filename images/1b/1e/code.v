module cordic_sine_cosine (
    input wire clk,
    input wire reset,
    input wire [15:0] angle, // Fixed-point representation of angle in radians
    output reg [15:0] sine,   // Fixed-point representation of sine
    output reg [15:0] cosine   // Fixed-point representation of cosine
);
    reg [15:0] x, y, z;
    reg [4:0] i; // Number of iterations
    parameter K = 16'h5A82; // Scaling factor (K = 0.6072 in fixed point)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sine <= 16'h0000;
            cosine <= 16'h0000;
            x <= K; // Initial x = K
            y <= 0; // Initial y = 0
            z <= angle; // Angle input
            i <= 0; // Iteration counter
        end else if (i < 16) begin
            if (z[15]) begin
                x <= x + (y >> i);
                y <= y - (x >> i);
                z <= z + (16'h0001 << i);
            end else begin
                x <= x - (y >> i);
                y <= y + (x >> i);
                z <= z - (16'h0001 << i);
            end
            i <= i + 1;
        end else begin
            sine <= y;   // Final sine value
            cosine <= x; // Final cosine value
        end
    end
endmodule