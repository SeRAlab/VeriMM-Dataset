module cordic (
    input clk,
    input reset,
    input start,
    input [15:0] angle,  // Fixed-point representation of angle
    output reg [15:0] sin_out,  // Fixed-point sine output
    output reg [15:0] cos_out,  // Fixed-point cosine output
    output reg ready
);
    reg [15:0] x;  // Initial value for x (cos(0))
    reg [15:0] y;  // Initial value for y (sin(0))
    reg [15:0] z;  // Angle accumulator
    reg [3:0] iter;  // Iteration counter

    // CORDIC constants
    reg [15:0] atan_table [0:15]; // Lookup table for arctangent values

    initial begin
        // Initialize atan_table with fixed-point values
        atan_table[0] = 16'h3C90; // atan(2^-0)
        atan_table[1] = 16'h3C40; // atan(2^-1)
        atan_table[2] = 16'h3C20; // atan(2^-2)
        atan_table[3] = 16'h3C10; // atan(2^-3)
        atan_table[4] = 16'h3C08; // atan(2^-4)
        atan_table[5] = 16'h3C04; // atan(2^-5)
        atan_table[6] = 16'h3C02; // atan(2^-6)
        atan_table[7] = 16'h3C01; // atan(2^-7)
        atan_table[8] = 16'h3C00; // atan(2^-8)
        atan_table[9] = 16'h3C00; // atan(2^-9)
        atan_table[10] = 16'h3C00; // atan(2^-10)
        atan_table[11] = 16'h3C00; // atan(2^-11)
        atan_table[12] = 16'h3C00; // atan(2^-12)
        atan_table[13] = 16'h3C00; // atan(2^-13)
        atan_table[14] = 16'h3C00; // atan(2^-14)
        atan_table[15] = 16'h3C00; // atan(2^-15)
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'h4000; // Initial value for cosine (1.0)
            y <= 16'h0000; // Initial value for sine (0.0)
            z <= 0; // Angle accumulator
            iter <= 0;
            ready <= 0;
            sin_out <= 0;
            cos_out <= 0;
        end else if (start) begin
            if (iter < 16) begin
                if (z < 0) begin
                    x <= x + (y >> iter); // x = x + y * 2^-i
                    y <= y - (x >> iter); // y = y - x * 2^-i
                    z <= z + atan_table[iter]; // z = z + atan(i)
                end else begin
                    x <= x - (y >> iter); // x = x - y * 2^-i
                    y <= y + (x >> iter); // y = y + x * 2^-i
                    z <= z - atan_table[iter]; // z = z - atan(i)
                end
                iter <= iter + 1;
            end else begin
                sin_out <= y;
                cos_out <= x;
                ready <= 1; // Computation is done
            end
        end
    end
endmodule