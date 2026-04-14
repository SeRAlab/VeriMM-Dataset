module cordic_sine_cosine (
    input clk,
    input rst,
    input [15:0] angle,
    output reg [15:0] sine,
    output reg [15:0] cosine
);
    reg [15:0] x, y, z;
    reg [3:0] iter;
    parameter ITERATIONS = 16;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h26B8; // Initial x = 0.6 (scaled)
            y <= 16'h0000; // Initial y = 0
            z <= angle;    // Input angle
            sine <= 0;
            cosine <= 0;
            iter <= 0;
        end else if (iter < ITERATIONS) begin
            if (z < 0) begin
                // Rotate negative
                x <= x + (y >> iter);
                y <= y - (x >> iter);
                z <= z + (atan_table[iter]);
            end else begin
                // Rotate positive
                x <= x - (y >> iter);
                y <= y + (x >> iter);
                z <= z - (atan_table[iter]);
            end
            iter <= iter + 1;
        end else begin
            sine <= y;
            cosine <= x;
        end
    end

    // arctangent lookup table for CORDIC
    reg [15:0] atan_table [0:ITERATIONS-1];
    initial begin
        atan_table[0] = 16'h3243; // atan(1) = pi/4
        atan_table[1] = 16'h1DAC; // atan(0.5)
        atan_table[2] = 16'h0FAE; // atan(0.25)
        atan_table[3] = 16'h07F5; // atan(0.125)
        // ... (fill up to 16 iterations)
    end
endmodule