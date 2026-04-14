module binary_less_than_comparator (
    input [3:0] a,
    input [3:0] b,
    output reg lt);always @(*) begin
        lt = (a < b);
    end

endmodule