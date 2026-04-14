module simple_alu 
#(
parameter DATAWIDTH = 8
)
(
  input  [DATAWIDTH-1:0] a,
  input  [DATAWIDTH-1:0] b,
  input  [2:0]           opcode,
  output reg [DATAWIDTH-1:0] result,
  output reg              zero
);

always @(*) begin
    case (opcode)
        3'b000: result = a + b;  // ADD
        3'b001: result = a - b;  // SUB
        3'b010: result = a & b;  // AND
        3'b011: result = a | b;  // OR
        3'b100: result = a ^ b;  // XOR
        3'b101: result = ~a;     // NOT
        default: result = {DATAWIDTH{1'b0}};
    endcase

    zero = (result == {DATAWIDTH{1'b0}});
end

endmodule