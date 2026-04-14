module binary_nand (
    input [4:0] a,
    input [4:0] b,
    output reg [4:0] out);always @(*) begin
        out = ~(a & b);
    end

endmodule