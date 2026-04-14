module alu_32bit(
    input [31:0] A,
    input [31:0] B,
    input [1:0] opcode,
    output reg [31:0] Y
);

always @(*)
begin
    case (opcode)
        2'b00: Y = A + B;  // ADD
        2'b01: Y = A - B;  // SUB
        2'b10: Y = A & B;  // AND
        default: Y = 32'b0;
    endcase
end

endmodule