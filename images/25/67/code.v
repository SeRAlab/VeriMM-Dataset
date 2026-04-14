module ecc_point_addition(
    input wire clk,
    input wire rst,
    input wire valid,
    input wire [15:0] x1,
    input wire [15:0] y1,
    input wire [15:0] x2,
    input wire [15:0] y2,
    output reg [15:0] x3,
    output reg [15:0] y3,
    output reg valid_out
);
    
    reg [15:0] lambda;
    reg [15:0] temp_x;
    reg [15:0] temp_y;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x3 <= 0;
            y3 <= 0;
            valid_out <= 0;
        end else if (valid) begin
            if (x1 == x2 && y1 == y2) begin
                // Point doubling case
                // lambda = (3*x1*x1 + a) / (2*y1)
                // For simplicity, assume a=0 and we are working in a prime field.
                lambda <= (3 * x1 * x1) / (2 * y1); 
            end else begin
                // Point addition case
                // lambda = (y2 - y1) / (x2 - x1)
                lambda <= (y2 - y1) / (x2 - x1);
            end
            
            // Calculate new point (x3, y3)
            temp_x <= (lambda * lambda) - x1 - x2; // x3 = lambda^2 - x1 - x2
            temp_y <= (lambda * (x1 - temp_x)) - y1; // y3 = lambda*(x1 - x3) - y1
            
            x3 <= temp_x;
            y3 <= temp_y;
            valid_out <= 1;
        end
    end
endmodule