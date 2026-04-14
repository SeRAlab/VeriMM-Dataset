module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_control,
    output reg [31:0] result,
    output reg zero
);
    
    always @(*) begin
        case(ALU_control)
            3'b000: result = A + B;                     // Addition
            3'b001: result = A - B;                     // Subtraction
            3'b010: result = A & B;                     // Bitwise AND
            3'b011: result = A | B;                     // Bitwise OR
            3'b100: result = A ^ B;                     // Bitwise XOR
            3'b101: result = A << 1;                    // Logical left shift
            3'b110: result = A >> 1;                    // Logical right shift
            3'b111: result = (A < B) ? 32'b1 : 32'b0;   // Set on less than
            default: result = 32'b0;
        endcase
        
        zero = (result == 32'b0);
    end
    
endmodule