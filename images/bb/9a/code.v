module top_module(
    input [3:0] a,
    input [3:0] b,
    input [2:0] op,
    output reg [3:0] out
);reg [3:0] temp;

always @(*) begin
    case (op)
        3'b000: temp = a + b; // addition
        3'b001: temp = a - b; // subtraction
        3'b010: temp = a & b; // bitwise AND
        3'b011: temp = a | b; // bitwise OR
        3'b100: temp = a ^ b; // bitwise XOR
        3'b101: temp = {a[2:0], 1'b0}; // shift left
        default: temp = 4'b0; // default to 0
    endcase
end

assign out = temp;

endmodule