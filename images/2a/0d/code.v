module ALU (
    input [63:0] A,
    input [63:0] B,
    input [2:0] ALU_control,
    output reg [63:0] ALU_result,
    output reg zero
);

always @(*) begin
    case (ALU_control)
        3'b000: ALU_result = A + B;                   // Add
        3'b001: ALU_result = A - B;                   // Subtract
        3'b010: ALU_result = A & B;                   // AND
        3'b011: ALU_result = A | B;                   // OR
        3'b100: ALU_result = A ^ B;                   // XOR
        3'b101: ALU_result = A << 1;                  // Shift Left
        3'b110: ALU_result = A >> 1;                  // Shift Right
        3'b111: ALU_result = (A < B) ? 64'b1 : 64'b0; // Set on Less Than
        default: ALU_result = 64'b0;
    endcase
    zero = (ALU_result == 64'b0);
end

endmodule