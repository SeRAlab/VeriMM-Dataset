module ecc_point_addition (
    input wire clk,
    input wire rst,
    input wire [15:0] x1,
    input wire [15:0] y1,
    input wire [15:0] x2,
    input wire [15:0] y2,
    input wire [15:0] a,
    input wire [15:0] p,
    output reg [15:0] x3,
    output reg [15:0] y3
);
    reg [15:0] m;
    reg [15:0] temp_x3, temp_y3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x3 <= 0;
            y3 <= 0;
        end else begin
            if (x1 == x2 && y1 == y2) begin
                // Point doubling case
                m <= (3 * x1 * x1 + a) / (2 * y1); // Slope calculation
            end else begin
                // Point addition case
                m <= (y2 - y1) / (x2 - x1); // Slope calculation
            end
            temp_x3 <= (m * m - x1 - x2) % p; // New x coordinate
            temp_y3 <= (m * (x1 - temp_x3) - y1) % p; // New y coordinate
            x3 <= temp_x3;
            y3 <= temp_y3;
        end
    end
endmodule