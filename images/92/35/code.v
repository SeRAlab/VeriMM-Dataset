module top_module(
    input [3:0] a,
    output reg [5:0] out
);always @ (a) begin
    out = a << 1; // left shift by 1 is equivalent to multiplication by 2
    out = out + a; // add the original number to get multiplication by 3
end

endmodule