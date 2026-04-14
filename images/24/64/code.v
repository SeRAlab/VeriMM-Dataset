module ALU16(
    input [15:0] A,
    input [15:0] B,
    input [3:0] opcode,
    output reg [15:0] result,
    output reg zero_flag
);
    always @(*) begin
        case(opcode)
            4'b0000: result = A + B;       // ADD
            4'b0001: result = A - B;       // SUBTRACT
            4'b0010: result = A & B;       // AND
            4'b0011: result = A | B;       // OR
            default: result = 16'b0000000000000000; // Default case
        endcase
        zero_flag = (result == 16'b0000000000000000) ? 1'b1 : 1'b0; // Set zero flag
    end
endmodule