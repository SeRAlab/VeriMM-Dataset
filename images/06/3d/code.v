module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] result
);
    always @(*) begin
        case (opcode)
            3'b000: result = A & B;         // AND
            3'b001: result = A | B;         // OR
            3'b010: result = A + B;         // ADD
            3'b011: result = A - B;         // SUBTRACT
            3'b100: result = A << 1;        // LEFT SHIFT
            3'b101: result = A >> 1;        // RIGHT SHIFT
            default: result = 32'b0;        // Default case
        endcase
    end
endmodule