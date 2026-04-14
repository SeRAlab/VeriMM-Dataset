module cordic (
    input clk,
    input rst,
    input start,
    input [31:0] angle, // Fixed-point angle input
    output reg [31:0] sine,
    output reg [31:0] cosine,
    output reg done
);
    parameter N = 16; // Number of iterations
    reg [31:0] x, y, z;
    reg [4:0] i; // Iteration counter
    reg [31:0] atan_lut [0:N-1]; // Arctan lookup table

    initial begin
        // Precompute arctan values for CORDIC
        atan_lut[0] = 32'h20000000; // atan(2^-0)
        atan_lut[1] = 32'h13333333; // atan(2^-1)
        atan_lut[2] = 32'h0A3D70A4; // atan(2^-2)
        atan_lut[3] = 32'h052B85B0; // atan(2^-3)
        atan_lut[4] = 32'h028B0B50; // atan(2^-4)
        atan_lut[5] = 32'h0144CB80; // atan(2^-5)
        atan_lut[6] = 32'h00A2C0E0; // atan(2^-6)
        atan_lut[7] = 32'h0051E4F0; // atan(2^-7)
        atan_lut[8] = 32'h0028F5C0; // atan(2^-8)
        atan_lut[9] = 32'h00147A80; // atan(2^-9)
        atan_lut[10] = 32'h000A3D70; // atan(2^-10)
        atan_lut[11] = 32'h0005190C; // atan(2^-11)
        atan_lut[12] = 32'h00028B0B; // atan(2^-12)
        atan_lut[13] = 32'h000145C9; // atan(2^-13)
        atan_lut[14] = 32'h0000A2C0; // atan(2^-14)
        atan_lut[15] = 32'h000051E4; // atan(2^-15)
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sine <= 0;
            cosine <= 0;
            done <= 0;
            x <= 32'h26DD3B6A; // Initial x = 1 (fixed-point)
            y <= 0; // Initial y = 0
            z <= 0; // Initial z = 0
            i <= 0;
        end else if (start) begin
            z <= angle;
            x <= 32'h26DD3B6A; // Initial x = 1
            y <= 0; // Initial y = 0
            i <= 0;
            done <= 0;
        end else if (i < N) begin
            if (z < 0) begin
                // Rotate clockwise
                x <= x + (y >>> i);
                y <= y - (x >>> i);
                z <= z + atan_lut[i];
            end else begin
                // Rotate counter-clockwise
                x <= x - (y >>> i);
                y <= y + (x >>> i);
                z <= z - atan_lut[i];
            end
            i <= i + 1;
        end else begin
            sine <= y;
            cosine <= x;
            done <= 1;
        end
    end
endmodule