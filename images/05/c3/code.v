module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [2:0] opcode,
    output reg [63:0] result,
    output reg zero_flag
);
    
    always @(*) begin
        case (opcode)
            3'b000: result = A + B;          // Addition
            3'b001: result = A - B;          // Subtraction
            3'b010: result = A & B;          // AND
            3'b011: result = A | B;          // OR
            3'b100: result = A ^ B;          // XOR
            default: result = 64'b0;         // Default case
        endcase
        
        zero_flag = (result == 64'b0) ? 1'b1 : 1'b0; // Set zero flag if result is zero
    end
endmodule