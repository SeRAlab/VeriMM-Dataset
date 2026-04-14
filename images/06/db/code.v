module CORDIC (
    input clk,
    input reset,
    input [15:0] angle, // Fixed-point angle input
    output reg [15:0] sine,
    output reg [15:0] cosine,
    output reg ready
);
    reg [15:0] x, y, z;
    reg [3:0] iteration;
    parameter NUM_ITERATIONS = 16;

    // CORDIC gains
    reg [15:0] K [0:NUM_ITERATIONS-1];
    initial begin
        K[0] = 16'h26DD; // K0
        K[1] = 16'h1A6A; // K1
        K[2] = 16'h0D6E; // K2
        K[3] = 16'h06B4; // K3
        K[4] = 16'h0333; // K4
        K[5] = 16'h0199; // K5
        K[6] = 16'h00CC; // K6
        K[7] = 16'h0067; // K7
        K[8] = 16'h0033; // K8
        K[9] = 16'h001A; // K9
        K[10] = 16'h000D; // K10
        K[11] = 16'h0006; // K11
        K[12] = 16'h0003; // K12
        K[13] = 16'h0002; // K13
        K[14] = 16'h0001; // K14
        K[15] = 16'h0001; // K15
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'h26DD; // Initial x = K0
            y <= 16'h0000; // Initial y = 0
            z <= angle;    // Initialize z with angle
            iteration <= 0;
            ready <= 0;
            sine <= 0;
            cosine <= 0;
        end else if (iteration < NUM_ITERATIONS) begin
            if (z < 0) begin
                // Rotate counter-clockwise
                x <= x + (y >>> iteration);
                y <= y - (x >>> iteration);
                z <= z + (16'h1D2C >> iteration); // atan(2^-i)
            end else begin
                // Rotate clockwise
                x <= x - (y >>> iteration);
                y <= y + (x >>> iteration);
                z <= z - (16'h1D2C >> iteration); // atan(2^-i)
            end
            iteration <= iteration + 1;
        end else begin
            sine <= y; // Final y is sine
            cosine <= x; // Final x is cosine
            ready <= 1; // Set ready flag
        end
    end
endmodule