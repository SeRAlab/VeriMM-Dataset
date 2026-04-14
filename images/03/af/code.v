module ALU_64bit(
    input [63:0] A,
    input [63:0] B,
    input [2:0] opcode,
    output reg [63:0] result,
    output reg carry_borrow
);

always @(*) begin
    case (opcode)
        3'b000: {carry_borrow, result} = A + B; // Add
        3'b001: {carry_borrow, result} = A - B; // Subtract
        3'b010: result = A & B; // AND
        3'b011: result = A | B; // OR
        3'b100: result = A ^ B; // XOR
        3'b101: result = A << 1; // Shift Left
        3'b110: result = A >> 1; // Shift Right
        3'b111: result = (A < B) ? 64'b1 : 64'b0; // Compare
        default: result = 64'b0; // Default case
    endcase
end

endmodule