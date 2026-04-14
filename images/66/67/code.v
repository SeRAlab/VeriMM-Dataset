module binary_xnor (
    input [2:0] a,
    input [2:0] b,
    output reg [2:0] out);always @(*) begin
        out = ~(a ^ b);
    end

endmodule