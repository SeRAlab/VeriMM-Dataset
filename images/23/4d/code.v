module alu_32bit (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] result,
    output reg carry_out
);

always @(*) begin
    case (opcode)
        3'b000: {carry_out, result} = A + B;         // Addition
        3'b001: {carry_out, result} = A - B;         // Subtraction
        3'b010: result = A & B;                       // AND
        3'b011: result = A | B;                       // OR
        3'b100: result = ~A;                          // NOT
        default: result = 32'b0;                      // Default case
    endcase
end

endmodule