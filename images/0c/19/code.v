module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] op_code,
    output reg [7:0] Result,
    output reg zero_flag
);
    always @(*) begin
        case (op_code)
            3'b000: Result = A + B;      // Addition
            3'b001: Result = A - B;      // Subtraction
            3'b010: Result = A & B;      // Bitwise AND
            3'b011: Result = A | B;      // Bitwise OR
            3'b100: Result = A ^ B;      // Bitwise XOR
            default: Result = 8'b00000000; // Default case
        endcase
        zero_flag = (Result == 8'b00000000) ? 1'b1 : 1'b0; // Set zero_flag
    end
endmodule