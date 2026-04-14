module linear_regression (
    input [15:0] x1,
    input [15:0] y1,
    input [15:0] x2,
    input [15:0] y2,
    output reg [15:0] m,
    output reg [15:0] b,
    output reg valid
);
    always @(*) begin
        if (x1 == x2) begin
            m = 16'hFFFF; // Indicate undefined slope
            b = 16'hFFFF; // Indicate undefined intercept
            valid = 0;
        end else begin
            m = (y2 - y1) / (x2 - x1);
            b = y1 - m * x1;
            valid = 1;
        end
    end
endmodule