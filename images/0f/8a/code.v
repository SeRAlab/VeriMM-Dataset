module alu (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] result,
    output reg carry_out
);
    
    always @(*) begin
        carry_out = 0;
        case (opcode)
            3'b000: result = A & B;            // AND
            3'b001: result = A | B;            // OR
            3'b010: {carry_out, result} = A + B; // ADD
            3'b011: {carry_out, result} = A - B; // SUBTRACT
            3'b100: result = ~(A | B);         // NOR
            3'b101: result = ~(A & B);         // NAND
            3'b110: result = A ^ B;            // XOR
            3'b111: result = ~(A ^ B);         // XNOR
            default: result = 32'b0;           // Default case
        endcase
    end
endmodule