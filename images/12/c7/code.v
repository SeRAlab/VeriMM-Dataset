module ECC_Point_Addition(
    input clk,
    input rst,
    input [15:0] x1,
    input [15:0] y1,
    input [15:0] x2,
    input [15:0] y2,
    output reg [15:0] x3,
    output reg [15:0] y3
);
    reg [15:0] m; // Slope
    reg [15:0] x_temp, y_temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x3 <= 16'b0;
            y3 <= 16'b0;
        end else begin
            if (x1 == 0 && y1 == 0) begin // Point at infinity case for (x1, y1)
                x3 <= x2;
                y3 <= y2;
            end else if (x2 == 0 && y2 == 0) begin // Point at infinity case for (x2, y2)
                x3 <= x1;
                y3 <= y1;
            end else if (x1 == x2 && y1 == y2) begin // Doubling case
                m <= (3 * x1 * x1) / (2 * y1); // Simplified slope calculation
                x_temp <= (m * m) - x1 - x2;
                y_temp <= m * (x1 - x_temp) - y1;
            end else begin // Normal addition case
                m <= (y2 - y1) / (x2 - x1);
                x_temp <= (m * m) - x1 - x2;
                y_temp <= m * (x1 - x_temp) - y1;
            end
            x3 <= x_temp;
            y3 <= y_temp;
        end
    end
endmodule