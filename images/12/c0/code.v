module alu_32bit (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] Result
);

always @(*) begin
    case (ALUOp)
        3'b000: Result = A + B;      // Addition
        3'b001: Result = A - B;      // Subtraction
        3'b010: Result = A & B;      // AND
        3'b011: Result = A | B;      // OR
        3'b100: Result = A ^ B;      // XOR
        default: Result = 32'b0;      // Default case
    endcase
end

endmodule