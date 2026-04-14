module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ALUOp,
    output reg [7:0] Result
);
    
    always @(*) begin
        case(ALUOp)
            3'b000: Result = A & B;      // AND
            3'b001: Result = A | B;      // OR
            3'b010: Result = A ^ B;      // XOR
            3'b011: Result = A + B;      // ADD
            3'b100: Result = A - B;      // SUBTRACT
            3'b101: Result = (A < B) ? 8'b00000001 : 8'b00000000; // SLT
            3'b110: Result = ~(A | B);    // NOR
            3'b111: Result = ~(A & B);    // NAND
            default: Result = 8'b00000000; // Invalid operation
        endcase
    end
endmodule