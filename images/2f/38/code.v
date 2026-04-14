module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] Y,
    output reg Z
);

always @(*) begin
    case(opcode)
        3'b000: Y = A + B;           // Addition
        3'b001: Y = A - B;           // Subtraction
        3'b010: Y = A & B;           // Bitwise AND
        3'b011: Y = A | B;           // Bitwise OR
        3'b100: Y = A ^ B;           // Bitwise XOR
        default: Y = 32'b0;          // Default case
    endcase
    Z = (Y == 32'b0);                // Zero flag
end
endmodule