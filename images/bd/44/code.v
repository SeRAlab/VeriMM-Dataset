module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] SEL,
    input EN,
    output reg [3:0] Y
);always @(*) begin
    case (SEL)
        2'b00: Y = EN ? A : 4'bZ;
        2'b01: Y = EN ? B : 4'bZ;
        2'b10: Y = EN ? C : 4'bZ;
        2'b11: Y = EN ? D : 4'bZ;
    endcase
end

endmodule