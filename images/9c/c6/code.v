module top_module(
    input [7:0] input1,
    input [7:0] input2,
    input [2:0] opcode,
    output reg [7:0] result
);always @(*) begin
    case(opcode)
        3'b000: result = input1 + input2;
        3'b001: result = input1 - input2;
        3'b010: result = input1 * input2;
        3'b011: result = input1 / input2;
        3'b100: result = input1 & input2;
        3'b101: result = input1 | input2;
        3'b110: result = input1 ^ input2;
        3'b111: result = ~input1;
        default: result = 8'b0;
    endcase
end

endmodule