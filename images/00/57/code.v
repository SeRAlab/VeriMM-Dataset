module ECC_Point_Addition (
    input clk,
    input reset,
    input [15:0] x1,
    input [15:0] y1,
    input [15:0] x2,
    input [15:0] y2,
    output reg [15:0] x3,
    output reg [15:0] y3,
    output reg valid
);
    parameter P = 17; // A small prime for finite field
    reg [15:0] lambda;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x3 <= 0;
            y3 <= 0;
            valid <= 0;
        end else begin
            if (x1 == 0 && y1 == 0) begin
                x3 <= x2;
                y3 <= y2;
                valid <= 1;
            end else if (x2 == 0 && y2 == 0) begin
                x3 <= x1;
                y3 <= y1;
                valid <= 1;
            end else if (x1 == x2 && y1 == y2) begin
                // Slope for point doubling
                lambda <= (3 * x1 * x1) * (2 * y1) % P;
            end else begin
                // Slope for point addition
                lambda <= (y2 - y1) * (x2 - x1) % P;
            end
            
            // Calculate the resulting point (x3, y3)
            x3 <= (lambda * lambda - x1 - x2) % P;
            y3 <= (lambda * (x1 - x3) - y1) % P;
            valid <= 1;
        end
    end
endmodule