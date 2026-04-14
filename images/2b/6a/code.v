module median_filter (
    input a,
    input b,
    input c,
    output reg median
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