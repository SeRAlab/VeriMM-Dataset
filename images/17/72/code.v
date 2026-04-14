module linear_regression (
    input [15:0] x1,
    input [15:0] x2,
    input [15:0] y1,
    input [15:0] y2,
    output reg signed [31:0] m,
    output reg signed [31:0] b
);
    reg signed [31:0] numerator_m;
    reg signed [31:0] denominator_m;
    reg signed [31:0] sum_x;
    reg signed [31:0] sum_y;

    always @(*) begin
        // Calculate slope (m)
        numerator_m = (y2 - y1) * (x2 - x1);
        denominator_m = (x2 - x1) * (x2 - x1);
        if (denominator_m != 0) begin
            m = numerator_m / denominator_m;
        end else begin
            m = 0; // Handle vertical line case
        end

        // Calculate intercept (b)
        sum_x = x1 + x2;
        sum_y = y1 + y2;
        b = (sum_y - m * sum_x) / 2;
    end
endmodule