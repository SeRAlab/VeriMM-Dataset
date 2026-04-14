module ECC_PointAddition (
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
    reg [15:0] lambda;  // Slope
    reg [15:0] x_temp;
    reg [15:0] y_temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x3 <= 0;
            y3 <= 0;
            valid <= 0;
        end else begin
            if (x1 == x2 && y1 == y2) begin
                // Use the tangent slope for point doubling
                lambda <= (3 * x1 * x1) / (2 * y1); // Simplified assuming no division by zero
            end else begin
                // Use the slope for point addition
                lambda <= (y2 - y1) / (x2 - x1); // Simplified assuming no division by zero
            end

            x_temp <= lambda * lambda - x1 - x2;
            y_temp <= lambda * (x1 - x_temp) - y1;

            // Assign output
            x3 <= x_temp;
            y3 <= y_temp;
            valid <= 1;
        end
    end
endmodule