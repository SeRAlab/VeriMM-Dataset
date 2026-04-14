module ALU (
    input [31:0] A,
    input [31:0] B,
    input [1:0] op,  // 00: add, 01: subtract, 10: AND, 11: OR
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
        case (op)
            2'b00: result = A + B;          // Addition
            2'b01: result = A - B;          // Subtraction
            2'b10: result = A & B;          // Bitwise AND
            2'b11: result = A | B;          // Bitwise OR
            default: result = 32'b0;        // Default case
        endcase
        zero = (result == 32'b0);          // Set zero flag
    end
endmodule