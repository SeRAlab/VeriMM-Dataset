module linear_regression (
    input [15:0] x1, y1,
    input [15:0] x2, y2,
    input [15:0] x3, y3,
    output reg [15:0] slope,
    output reg [15:0] intercept
);
    wire signed [31:0] numerator_m, denominator_m;
    wire signed [31:0] sum_x, sum_y;

    assign sum_x = x1 + x2 + x3;
    assign sum_y = y1 + y2 + y3;

    assign numerator_m = ( (x1 * y1) + (x2 * y2) + (x3 * y3) ) - ( (sum_y * sum_x) / 3 );
    assign denominator_m = ( (x1 * x1) + (x2 * x2) + (x3 * x3) ) - ( (sum_x * sum_x) / 3 );

    always @(*) begin
        if (denominator_m != 0) begin
            slope = numerator_m / denominator_m;
        end else begin
            slope = 0; // Handle vertical line case
        end
        intercept = (sum_y / 3) - (slope * (sum_x / 3));
    end
endmodule