module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ALUCtrl,
    output reg [7:0] Result,
    output reg Zero
);

always @(*) begin
    case (ALUCtrl)
        3'b000: Result = A + B;           // Addition
        3'b001: Result = A - B;           // Subtraction
        3'b010: Result = A & B;           // Bitwise AND
        3'b011: Result = A | B;           // Bitwise OR
        3'b100: Result = A ^ B;           // Bitwise XOR
        3'b101: Result = A << 1;          // Logical left shift
        3'b110: Result = A >> 1;          // Logical right shift
        3'b111: Result = ~A;              // Bitwise NOT
        default: Result = 8'b00000000;    // Default case
    endcase
    Zero = (Result == 8'b00000000);       // Set Zero flag
end

endmodule