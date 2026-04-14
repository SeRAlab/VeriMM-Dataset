module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] out
);always @*
    begin
        case (opcode)
            3'b000: out = A + B; // addition
            3'b001: out = A - B; // subtraction
            3'b010: out = A * B; // multiplication
            3'b011: out = A / B; // division
            3'b100: out = A & B; // bitwise AND
            3'b101: out = A | B; // bitwise OR
            3'b110: out = A ^ B; // bitwise XOR
            default: out = 8'h00; // default to 0
        endcase
    end

endmodule