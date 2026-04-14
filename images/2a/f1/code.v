module ecc_point_addition (
    input clk,
    input rst,
    input [7:0] x1, y1, x2, y2, p,
    output reg [7:0] x3, y3,
    output reg valid
);
    reg [7:0] lambda, numerator, denominator;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x3 <= 0;
            y3 <= 0;
            valid <= 0;
        end else begin
            if (x1 == x2 && y1 == y2) begin
                // Point doubling
                numerator <= (3 * x1 * x1) % p;
                denominator <= (2 * y1) % p;
            end else begin
                // Point addition
                numerator <= (y2 - y1) % p;
                denominator <= (x2 - x1) % p;
            end
            
            if (denominator != 0) begin
                // Calculate lambda (slope)
                lambda <= (numerator * denominator) % p;
                x3 <= (lambda * lambda - x1 - x2) % p;
                y3 <= (lambda * (x1 - x3) - y1) % p;
                valid <= 1;
            end else begin
                // If denominator is zero, output invalid
                x3 <= 0;
                y3 <= 0;
                valid <= 0;
            end
        end
    end
endmodule