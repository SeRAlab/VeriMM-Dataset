module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_Sel,
    output reg [31:0] ALU_Result
);

always @(*) begin
    case(ALU_Sel)
        3'b000: ALU_Result = A + B;         // Addition
        3'b001: ALU_Result = A - B;         // Subtraction
        3'b010: ALU_Result = A & B;         // AND
        3'b011: ALU_Result = A | B;         // OR
        3'b100: ALU_Result = A ^ B;         // XOR
        3'b101: ALU_Result = (A < B) ? 32'b1 : 32'b0; // Set on Less Than
        default: ALU_Result = 32'b0;        // Default case
    endcase
end

endmodule