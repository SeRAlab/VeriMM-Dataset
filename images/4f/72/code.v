module top_module(
    input [7:0] a,
    input [7:0] b,
    input [3:0] op,
    output [7:0] result
);reg [15:0] temp;

always @* begin
    case (op)
        4'b0000: temp = a + b; // Addition
        4'b0001: temp = a - b; // Subtraction
        4'b0010: temp = a * b; // Multiplication
        4'b0011: temp = a / b; // Division
        4'b0100: temp = a & b; // Bitwise AND
        4'b0101: temp = a | b; // Bitwise OR
        4'b0110: temp = ~a; // Bitwise NOT
        default: temp = 0; // Invalid operation code
    endcase
end

assign result = temp[7:0];

endmodule