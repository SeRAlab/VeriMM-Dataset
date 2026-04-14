module binary_equality_checker (
    input [6:0] a,
    input [6:0] b,
    output reg equal);always @(*) begin
        equal = (a == b) ? 1 : 0;
    end

endmodule