module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] result,
    output reg carry_out
);
    always @(*) begin
        case (opcode)
            3'b000: {carry_out, result} = A + B;                  // Addition
            3'b001: {carry_out, result} = A - B;                  // Subtraction
            3'b010: result = A & B;                               // Bitwise AND
            3'b011: result = A | B;                               // Bitwise OR
            3'b100: result = A ^ B;                               // Bitwise XOR
            3'b101: result = ~A;                                  // Bitwise NOT (only A)
            3'b110: result = A << 1;                              // Logical Shift Left
            3'b111: result = A >> 1;                              // Logical Shift Right
            default: result = 8'b00000000;                        // Default case
        endcase
    end
endmodule