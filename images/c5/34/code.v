module Adder(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output [31:0] out
);

always @(*) begin
    case (op)
        2'b00: out = a + b;
        2'b01: out = a - b;
        2'b10: out = a & b;
        2'b11: out = a | b;
        default: out = 0;
    endcase
end

endmodule