module binary_equality_checker (
    input [3:0] a,
    input [3:0] b,
    output reg eq);always @(*) begin
        eq = (a == b) ? 1'b1 : 1'b0;
    end

endmodule