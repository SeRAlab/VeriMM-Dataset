module top_module(
    input [7:0] D0,
    input [7:0] D1,
    input [7:0] D2,
    input [7:0] D3,
    input [1:0] SEL,
    input EN,
    output reg [7:0] Y
);always @(SEL, D0, D1, D2, D3, EN) begin
    if (EN) begin
        case (SEL)
            2'b00: Y <= D0;
            2'b01: Y <= D1;
            2'b10: Y <= D2;
            2'b11: Y <= D3;
        endcase
    end
    else begin
        Y <= 8'b0;
    end
end

endmodule