module top_module(
    input [3:0] a,
    input [3:0] b,
    input [1:0] opcode,
    output [3:0] result
);reg [3:0] temp;

always @(*) begin
    case(opcode)
        2'b00: temp = a + b;
        2'b01: temp = a - b;
        2'b10: temp = a & b;
        2'b11: temp = a | b;
    endcase
end

assign result = temp;

endmodule