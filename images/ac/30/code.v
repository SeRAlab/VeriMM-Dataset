module alu_32bit(
    input [31:0] A,       // 32-bit input operand A.
    input [31:0] B,       // 32-bit input operand B.
    input [1:0] ctrl,     // 2-bit control signal.
    output reg [31:0] result // 32-bit output result.
);

always @(*) begin
    case (ctrl)
        2'b00: result = A + B;     // Addition.
        2'b01: result = A - B;     // Subtraction.
        2'b10: result = A & B;     // Bitwise AND.
        default: result = 32'b0;   // Default to zero.
    endcase
end

endmodule