module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [2:0] opcode,
    output reg [63:0] result,
    output reg carry_out
);
    
    always @(*) begin
        carry_out = 0;
        case (opcode)
            3'b000: {carry_out, result} = A + B; // Addition
            3'b001: {carry_out, result} = A - B; // Subtraction
            3'b010: result = A & B;               // AND
            3'b011: result = A | B;               // OR
            3'b100: result = A ^ B;               // XOR
            3'b101: result = A << 1;              // Shift Left
            3'b110: result = A >> 1;              // Shift Right
            3'b111: result = (A < B) ? 64'b1 : 64'b0; // SLT
            default: result = 64'b0;              // Default case
        endcase
    end
    
endmodule