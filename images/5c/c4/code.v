module top_module(
    input [8:0] a,
    input [8:0] b,
    input [8:0] c,
    output reg [8:0] out
);always @(*) begin
        out = (a << 0) | (b << 9) | (c << 18);
    end

endmodule