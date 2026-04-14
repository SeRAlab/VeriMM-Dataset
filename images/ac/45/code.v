module binary_adder (
    input [5:0] a,
    input [5:0] b,
    output reg [5:0] out);always @(*) begin
        out = a + b;
    end

endmodule