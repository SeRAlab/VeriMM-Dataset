module ALU (
    input [15:0] A,
    input [15:0] B,
    input [1:0] opcode,
    output reg [15:0] result
);
    always @(*) begin
        case (opcode)
            2'b00: result = A + B;         // Addition
            2'b01: result = A - B;         // Subtraction
            2'b10: result = A & B;         // Bitwise AND
            2'b11: result = A | B;         // Bitwise OR
            default: result = 16'b0;       // Default case
        endcase
    end
endmodule