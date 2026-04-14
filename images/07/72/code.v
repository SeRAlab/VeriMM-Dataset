module cordic (
    input clk,
    input rst,
    input [15:0] angle, // Fixed-point representation of the angle in radians
    output reg [15:0] sine,
    output reg [15:0] cosine,
    output reg ready
);
    parameter NUM_ITERATIONS = 16;
    reg [15:0] x, y;
    reg [15:0] z;
    reg [3:0] iteration;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h26DD; // Initial value for cos(0) = 1.0 in fixed-point
            y <= 16'h0000; // Initial value for sin(0) = 0.0 in fixed-point
            z <= angle;    // Input angle
            iteration <= 0;
            ready <= 0;
        end else if (iteration < NUM_ITERATIONS) begin
            if (z < 0) begin
                // Rotation in the clockwise direction
                x <= x + (y >> iteration);
                y <= y - (x >> iteration);
                z <= z + (16'h1C71 >> iteration); // arctan(2^-iteration)
            end else begin
                // Rotation in the counter-clockwise direction
                x <= x - (y >> iteration);
                y <= y + (x >> iteration);
                z <= z - (16'h1C71 >> iteration); // arctan(2^-iteration)
            end
            iteration <= iteration + 1;
        end else begin
            sine <= y;
            cosine <= x;
            ready <= 1;
        end
    end
endmodule