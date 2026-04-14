module cordic(clk, reset, angle, sine, cosine);
    input clk, reset;
    input [15:0] angle; // 16-bit input angle in radians
    output reg [15:0] sine, cosine; // 16-bit output for sine and cosine

    reg [15:0] x, y, z; // x and y for coordinates, z for angle
    reg [15:0] atan_table [0:15]; // Lookup table for arctangent values

    integer i;

    initial begin
        // Initialize the atan_table for CORDIC
        atan_table[0] = 16'h2000; // atan(2^-0) in fixed-point
        atan_table[1] = 16'h199A; // atan(2^-1)
        atan_table[2] = 16'h1333; // atan(2^-2)
        atan_table[3] = 16'h0D60; // atan(2^-3)
        atan_table[4] = 16'h0A3D; // atan(2^-4)
        atan_table[5] = 16'h052E; // atan(2^-5)
        atan_table[6] = 16'h0266; // atan(2^-6)
        atan_table[7] = 16'h0139; // atan(2^-7)
        atan_table[8] = 16'h009A; // atan(2^-8)
        atan_table[9] = 16'h004E; // atan(2^-9)
        atan_table[10] = 16'h0027; // atan(2^-10)
        atan_table[11] = 16'h0013; // atan(2^-11)
        atan_table[12] = 16'h0009; // atan(2^-12)
        atan_table[13] = 16'h0004; // atan(2^-13)
        atan_table[14] = 16'h0002; // atan(2^-14)
        atan_table[15] = 16'h0001; // atan(2^-15)
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'h2000; // Initial x value (1.0 in fixed-point)
            y <= 16'h0000; // Initial y value (0.0 in fixed-point)
            z <= angle; // Load angle
            sine <= 16'h0000;
            cosine <= 16'h0000;
        end else begin
            x <= 16'h2000; // Reset x
            y <= 16'h0000; // Reset y
            z <= angle; // Reset z
            for (i = 0; i < 16; i = i + 1) begin
                if (z < 0) begin
                    // Rotation in the negative direction
                    x <= x + (y >> i);
                    y <= y - (x >> i);
                    z <= z + atan_table[i];
                end else begin
                    // Rotation in the positive direction
                    x <= x - (y >> i);
                    y <= y + (x >> i);
                    z <= z - atan_table[i];
                end
            end
            sine <= y;
            cosine <= x;
        end
    end
endmodule