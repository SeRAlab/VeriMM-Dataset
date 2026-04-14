module cordic (
    input clk,
    input rst,
    input start,
    input [15:0] angle, // Angle in radians fixed point representation
    output reg signed [15:0] sin_out,
    output reg signed [15:0] cos_out,
    output reg done
);
    parameter NUM_ITER = 16;
    reg [15:0] x, y, z;
    reg [3:0] iter;
    reg signed [15:0] angle_table [0:NUM_ITER-1];

    initial begin
        // Initialize angle table (arctan values for CORDIC)
        angle_table[0] = 16'h26DD; // atan(1/2^0)
        angle_table[1] = 16'h1C71; // atan(1/2^1)
        angle_table[2] = 16'h16C9; // atan(1/2^2)
        angle_table[3] = 16'h0E12; // atan(1/2^3)
        angle_table[4] = 16'h0A3D; // atan(1/2^4)
        angle_table[5] = 16'h0519; // atan(1/2^5)
        angle_table[6] = 16'h028D; // atan(1/2^6)
        angle_table[7] = 16'h0143; // atan(1/2^7)
        angle_table[8] = 16'h00A5; // atan(1/2^8)
        angle_table[9] = 16'h0052; // atan(1/2^9)
        angle_table[10] = 16'h0029; // atan(1/2^10)
        angle_table[11] = 16'h0014; // atan(1/2^11)
        angle_table[12] = 16'h000A; // atan(1/2^12)
        angle_table[13] = 16'h0005; // atan(1/2^13)
        angle_table[14] = 16'h0002; // atan(1/2^14)
        angle_table[15] = 16'h0001; // atan(1/2^15)
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h0000; // Initial x coordinate
            y <= 16'h4000; // Initial y coordinate (1.0 in fixed point)
            z <= angle; // Input angle
            iter <= 0;
            done <= 0;
            sin_out <= 0;
            cos_out <= 0;
        end else if (start) begin
            if (iter < NUM_ITER) begin
                if (z < 0) begin
                    x <= x + (y >>> iter);
                    y <= y - (x >>> iter);
                    z <= z + angle_table[iter];
                end else begin
                    x <= x - (y >>> iter);
                    y <= y + (x >>> iter);
                    z <= z - angle_table[iter];
                end
                iter <= iter + 1;
            end else begin
                sin_out <= y;
                cos_out <= x;
                done <= 1;
            end
        end
    end
endmodule