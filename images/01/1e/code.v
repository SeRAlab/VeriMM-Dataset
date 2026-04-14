module cordic (
    input wire clk,
    input wire reset,
    input wire [3:0] angle,
    input wire start,
    output reg [3:0] sine,
    output reg [3:0] cosine,
    output reg done
);
    reg [3:0] x, y, z;
    reg [3:0] angle_reg;
    reg [2:0] count;

    // CORDIC gain
    parameter K = 4'b0110; // Approximation of 1/sqrt(2)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sine <= 0;
            cosine <= K; // Initial cosine value corresponds to K
            z <= 0;
            count <= 0;
            done <= 0;
        end else if (start) begin
            if (count < 4) begin
                angle_reg <= angle;
                x <= cosine;
                y <= sine;

                if (angle_reg[count]) begin
                    // Perform CORDIC rotation
                    x <= x + (y >> count);
                    y <= y - (x >> count);
                    z <= z + (1 << count);
                end else begin
                    x <= x - (y >> count);
                    y <= y + (x >> count);
                    z <= z - (1 << count);
                end
                count <= count + 1;
            end else begin
                sine <= y;
                cosine <= x;
                done <= 1;
            end
        end
    end
endmodule