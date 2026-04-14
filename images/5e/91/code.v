module top_module(
    input [7:0] a,
    input [7:0] b,
    input [1:0] opcode,
    output reg [7:0] result
);always @*
begin
    case (opcode)
        2'b00: result = a + b; // Addition
        2'b01: result = a - b; // Subtraction
        2'b10: result = a & b; // Bitwise AND
        2'b11: result = a | b; // Bitwise OR
        default: result = 8'b0; // Invalid opcode, output 0
    endcase
end

endmodule