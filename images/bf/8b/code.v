module binary_comparator (
    input [3:0] p,
    input [3:0] q,
    output reg gt);always @(*) begin
        gt = (p > q) ? 1 : 0;
    end

endmodule