module top_module(
    input OF,
    input ZF,
    input [2:0] SW,
    input [31:0] ALU_F,
    output reg [7:0] LED
);always @(*) begin
    case (SW)
        3'b000: LED = ALU_F;
        3'b001: LED = ~ALU_F;
        3'b010: LED = ALU_F << 1;
        3'b011: LED = ALU_F >> 1;
        3'b100: LED = ALU_F + 1;
        3'b101: LED = ALU_F - 1;
        3'b110: LED = ALU_F & 8'h55;
        3'b111: LED = ALU_F | 8'hAA;
    endcase
end

always @(OF, ZF) begin
    if (OF == 1)
        LED[7] = 1;
    else
        LED[7] = 0;

    if (ZF == 1)
        LED = 8'b0000_0000;
end

endmodule