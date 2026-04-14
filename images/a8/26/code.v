module top_module(
    input [3:0] A, B, C, D,
    input [1:0] SEL,
    input EN,
    output reg Y
);always @(*) begin
    case (SEL)
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
        default: Y = 1'b0;
    endcase
end

always @(posedge EN) begin
    if (!EN) begin
        Y <= 1'b0;
    end
end

endmodule