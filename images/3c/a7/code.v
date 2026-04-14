module median_filter (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output reg [7:0] median
);

always @(*) begin
    if ((a >= b && a <= c) || (a <= b && a >= c))
        median = a;
    else if ((b >= a && b <= c) || (b <= a && b >= c))
        median = b;
    else
        median = c;
end

endmodule