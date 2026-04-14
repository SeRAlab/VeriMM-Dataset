module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] OP,
    output reg [7:0] RESULT
);always @(*) begin
    case(OP)
        3'b000: RESULT = A + B;
        3'b001: RESULT = A - B;
        3'b010: RESULT = A * B;
        3'b011: RESULT = A / B;
        3'b100: RESULT = A % B;
        default: RESULT = 8'bZZZZZZZZ;
    endcase
end

endmodule