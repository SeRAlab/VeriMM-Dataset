module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output reg [3:0] smallest
);always @(*) begin
    if (A <= B && A <= C) begin
        smallest = A;
    end else if (B <= A && B <= C) begin
        smallest = B;
    end else begin
        smallest = C;
    end
end

endmodule