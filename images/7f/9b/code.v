module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] product
);always @(*) begin
    product = {a[0]*b, a[1]*b, a[2]*b, a[3]*b};
end

endmodule