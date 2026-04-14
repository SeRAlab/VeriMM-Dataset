module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [2:0] op, // 3-bit operation code
    output reg [63:0] result
);

    always @(*) begin
        case (op)
            3'b000: result = A + B;       // Addition
            3'b001: result = A - B;       // Subtraction
            3'b010: result = A & B;       // AND
            3'b011: result = A | B;       // OR
            3'b100: result = A ^ B;       // XOR
            default: result = 64'b0;      // Default case
        endcase
    end
endmodule