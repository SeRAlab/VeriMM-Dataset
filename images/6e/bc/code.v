module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output reg [3:0] S
);always @(*) begin
    S = A + B + C;
end

endmodule