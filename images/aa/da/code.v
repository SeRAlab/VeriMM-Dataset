module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] c
);always @ (a, b) begin
    c = a * b;
end

endmodule