module top_module(
    input wire [7:0] num1,
    input wire [7:0] num2,
    input wire [1:0] opcode,
    output reg [7:0] result
);always @(*) begin
    case(opcode)
        2'b00: result = num1 + num2;
        2'b01: result = num1 - num2;
        2'b10: result = num1 * num2;
        2'b11: result = num1 / num2;
    endcase
end

endmodule