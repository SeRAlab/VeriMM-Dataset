module elliptic_curve_add(
    input clk,
    input rst,
    input [31:0] x1, y1, x2, y2,
    output reg [31:0] x3, y3,
    output reg valid
);
    reg [31:0] m, x_diff, y_diff;
    reg point_at_infinity;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x3 <= 32'b0;
            y3 <= 32'b0;
            valid <= 1'b0;
        end else begin
            // Check for points at infinity
            if ((x1 == 32'b0 && y1 == 32'b0) || (x2 == 32'b0 && y2 == 32'b0)) begin
                x3 <= x1 | x2;
                y3 <= y1 | y2;
                valid <= 1'b1;
            end else if (x1 == x2 && y1 == y2) begin
                // Doubling case
                m <= (3 * x1 * x1) / (2 * y1); // slope m = (3 * x1^2) / (2 * y1)
                x3 <= (m * m - 2 * x1);        // x3 = m^2 - 2*x1
                y3 <= (m * (x1 - x3) - y1);    // y3 = m*(x1 - x3) - y1
                valid <= 1'b1;
            end else begin
                // General case
                x_diff <= x2 - x1;
                y_diff <= y2 - y1;
                m <= y_diff / x_diff;          // slope m = (y2 - y1) / (x2 - x1)
                x3 <= (m * m - x1 - x2);       // x3 = m^2 - x1 - x2
                y3 <= (m * (x1 - x3) - y1);    // y3 = m*(x1 - x3) - y1
                valid <= 1'b1;
            end
        end
    end
endmodule