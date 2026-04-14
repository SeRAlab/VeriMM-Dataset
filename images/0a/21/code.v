module ALU (
    input [31:0] A,
    input [31:0] B,
    input [1:0] opcode,
    output reg [31:0] result
);
    always @(*) begin
        case (opcode)
            2'b00: result = A + B;        // Addition
            2'b01: result = A - B;        // Subtraction
            2'b10: result = A & B;        // Bitwise AND
            default: result = 32'b0;       // Default case
        endcase
    end
endmodule