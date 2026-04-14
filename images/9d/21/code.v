module top_module(
    input [9:0] x1,
    input [9:0] x2,
    input [9:0] x3,
    output reg [9:0] y
);always @(*) begin
        y = x1 + x2 + x3;
    end

endmodule