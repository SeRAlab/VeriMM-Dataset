module ecc_point_addition(
    input clk,
    input rst,
    input [7:0] x1,
    input [7:0] y1,
    input [7:0] x2,
    input [7:0] y2,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] x3,
    output reg [7:0] y3,
    output reg valid
);
    reg [7:0] lambda;
    reg [7:0] x1_squared;
    reg [7:0] y1_squared;
    reg [7:0] x2_squared;
    reg [7:0] y2_squared;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x3 <= 8'b0;
            y3 <= 8'b0;
            valid <= 0;
        end else begin
            // Check if the points are equal
            if (x1 == x2 && y1 == y2) begin
                // λ = (3*x1^2 + a) / (2*y1)
                x1_squared = x1 * x1; // x1^2
                y1_squared = y1 * y1; // y1^2
                lambda = (3 * x1_squared + a) / (2 * y1); // λ
                x3 = (lambda * lambda - x1 - x2); // x3 = λ^2 - x1 - x2
                y3 = (lambda * (x1 - x3) - y1); // y3 = λ * (x1 - x3) - y1
            end else begin
                // λ = (y2 - y1) / (x2 - x1)
                lambda = (y2 - y1) / (x2 - x1); // λ
                x3 = (lambda * lambda - x1 - x2); // x3 = λ^2 - x1 - x2
                y3 = (lambda * (x1 - x3) - y1); // y3 = λ * (x1 - x3) - y1
            end
            valid <= 1; // Indicate valid output
        end
    end
endmodule