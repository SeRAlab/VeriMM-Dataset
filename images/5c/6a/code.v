module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] C,
    input D,
    output reg [3:0] out
);always @(*) begin
    if (C == 2'b00) begin
        if (D == 1) begin
            out = ~(A | B);
        end else begin
            out = ~(A & B);
        end
    end else begin
        if (D == 1) begin
            out = A | B;
        end else begin
            out = A & B;
        end
    end
end

endmodule