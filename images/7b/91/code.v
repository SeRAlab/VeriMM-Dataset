module top_module(
    input [3:0] a,
    input [3:0] b,
    input [2:0] op,
    output reg [3:0] out
);always @(*) begin
        case(op)
            3'b000: out = a + b; // addition
            3'b001: out = a - b; // subtraction
            3'b010: out = a & b; // bitwise AND
            3'b011: out = a | b; // bitwise OR
            3'b100: out = a ^ b; // bitwise XOR
            3'b101: out = a << 1; // shift left
            default: out = 4'b0; // default output
        endcase
    end

endmodule