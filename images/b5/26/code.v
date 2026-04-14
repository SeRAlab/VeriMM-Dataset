module binary_comparator (
    input [3:0] a,
    input [3:0] b,
    output reg gt);always @(*) begin
        gt = (a > b) ? 1'b1 : 1'b0;
    end

endmodule