module cordic (
    input wire clk,
    input wire rst,
    input wire [15:0] angle, // Angle in fixed-point format
    output reg signed [15:0] sine,
    output reg signed [15:0] cosine
);
    reg signed [15:0] x;
    reg signed [15:0] y;
    reg signed [15:0] z;
    reg [3:0] i; // Iteration counter

    parameter NUM_ITER = 16; // Number of iterations
    reg signed [15:0] atan_table [0:NUM_ITER-1]; // Arctangent values

    initial begin
        atan_table[0] = 16'h26DD; // atan(2^0)
        atan_table[1] = 16'h1DAC; // atan(2^-1)
        atan_table[2] = 16'h0FAD; // atan(2^-2)
        atan_table[3] = 16'h07F5; // atan(2^-3)
        atan_table[4] = 16'h03FE; // atan(2^-4)
        atan_table[5] = 16'h01FF; // atan(2^-5)
        atan_table[6] = 16'h00FF; // atan(2^-6)
        atan_table[7] = 16'h007F; // atan(2^-7)
        atan_table[8] = 16'h003F; // atan(2^-8)
        atan_table[9] = 16'h001F; // atan(2^-9)
        atan_table[10] = 16'h000F; // atan(2^-10)
        atan_table[11] = 16'h0007; // atan(2^-11)
        atan_table[12] = 16'h0003; // atan(2^-12)
        atan_table[13] = 16'h0001; // atan(2^-13)
        atan_table[14] = 16'h0000; // atan(2^-14)
        atan_table[15] = 16'h0000; // atan(2^-15)
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h4000; // 0.5 in fixed-point
            y <= 16'h0000; // 0.0 in fixed-point
            z <= angle; // Input angle
            i <= 0;
            sine <= 0;
            cosine <= 0;
        end else if (i < NUM_ITER) begin
            if (z < 0) begin
                // Perform rotation
                x <= x + (y >>> i);
                y <= y - (x >>> i);
                z <= z + atan_table[i];
            end else begin
                // Perform rotation
                x <= x - (y >>> i);
                y <= y + (x >>> i);
                z <= z - atan_table[i];
            end
            i <= i + 1;
        end else begin
            sine <= y;
            cosine <= x;
        end
    end
endmodule