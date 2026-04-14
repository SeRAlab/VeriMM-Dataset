module median_filter(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output reg [7:0] median
);

always @(*) begin
    if ((a <= b && b <= c) || (c <= b && b <= a))
        median = b;
    else if ((b <= a && a <= c) || (c <= a && a <= b))
        median = a;
    else
        median = c;
end

endmodule