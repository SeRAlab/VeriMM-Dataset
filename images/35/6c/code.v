module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ALU_control,
    output reg [7:0] ALU_result
);
    always @(*) begin
        case (ALU_control)
            3'b000: ALU_result = A & B;           // AND
            3'b001: ALU_result = A | B;           // OR
            3'b010: ALU_result = A + B;           // ADD
            3'b011: ALU_result = A - B;           // SUBTRACT
            3'b100: ALU_result = A ^ B;           // XOR
            3'b101: ALU_result = ~(A & B);        // NAND
            3'b110: ALU_result = ~(A | B);        // NOR
            3'b111: ALU_result = ~(A ^ B);        // XNOR
            default: ALU_result = 8'b00000000;    // Default case
        endcase
    end
endmodule