module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input SEL0,
    input SEL1,
    output reg [3:0] Y
);always @ (SEL1 or SEL0 or A or B or C or D)
    case ({SEL1, SEL0})
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
    endcase

endmodule