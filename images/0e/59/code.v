module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] control,
    output reg [31:0] result,
    output reg less_than
);

always @(*) begin
    case (control)
        3'b000: result = A + B;            // Addition
        3'b001: result = A - B;            // Subtraction
        3'b010: result = A & B;            // AND
        3'b011: result = A | B;            // OR
        3'b100: result = A ^ B;            // XOR
        3'b101: result = ~(A | B);         // NOR
        3'b110: result = ~(A & B);         // NAND
        3'b111: begin                       // Set on less than
            less_than = (A < B) ? 1'b1 : 1'b0;
            result = 32'b0;                 // result is not used in comparison
        end
        default: result = 32'b0;           // Default case
    endcase
end

endmodule