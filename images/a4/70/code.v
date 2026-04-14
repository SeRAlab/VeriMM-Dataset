module top_module(
    input [3:0] D,
    input EN,
    input [1:0] SEL,
    output reg Y
);always @ (SEL or D or EN) begin
    if (EN) begin
        case (SEL)
            2'b00: Y = D[0];
            2'b01: Y = D[1];
            2'b10: Y = D[2];
            2'b11: Y = D[3];
        endcase
    end else begin
        Y = 0;
    end
end

endmodule