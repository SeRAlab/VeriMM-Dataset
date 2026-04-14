module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S
);always @(*) begin
    S = A + B;
    if (S > 15) begin
        S = S - 16;
    end
end

endmodule