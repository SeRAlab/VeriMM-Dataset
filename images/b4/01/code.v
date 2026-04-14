module top_module(
    input [15:0] A,
    input [3:0] S,
    input C,
    output reg [15:0] B
);always @(*) begin
    if (C == 0) begin
        B = A << S;
    end else begin
        B = A >> S;
    end
end

endmodule