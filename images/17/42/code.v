module ALU_16bit (
    input [15:0] A,
    input [15:0] B,
    input [3:0] opcode,
    output reg [15:0] result
);
    always @(*) begin
        case (opcode)
            4'b0000: result = A + B;         // ADD
            4'b0001: result = A - B;         // SUBTRACT
            4'b0010: result = A & B;         // AND
            4'b0011: result = A | B;         // OR
            4'b0100: result = A ^ B;         // XOR
            default: result = 16'b0;         // Default case
        endcase
    end
endmodule