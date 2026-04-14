module top_module(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    output reg [15:0] product
);always @(*) begin
        if (a == 0 || b == 0 || c == 0 || d == 0 || e == 0) begin
            product <= 16'd0;
        end
        else if (((a * b) / b) != a || ((a * b * c) / (a * b)) != c || ((a * b * c * d) / (a * b * c)) != d || ((a * b * c * d * e) / (a * b * c * d)) != e) begin
            product <= 16'd0;
        end
        else begin
            product <= a * b * c * d * e;
        end
    end

endmodule