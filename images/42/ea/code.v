module binary_comparator (
    input [4:0] p,
    input [4:0] q,
    output reg greater);always @(*) begin
        greater = (p > q);
    end

endmodule