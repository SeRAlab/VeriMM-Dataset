module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] operation,
    output reg [7:0] result,
    output reg carry
);
    always @(*) begin
        case(operation)
            3'b000: {carry, result} = A + B;         // Addition
            3'b001: {carry, result} = A - B;         // Subtraction
            3'b010: result = A & B;                   // AND
            3'b011: result = A | B;                   // OR
            3'b100: result = A ^ B;                   // XOR
            default: result = 8'b00000000;            // Default case
        endcase
    end
endmodule