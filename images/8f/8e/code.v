module top_module(
  input clk,
  input [7:0] a,
  input [7:0] b,
  input [2:0] op,
  output reg [7:0] res
);always @(posedge clk) begin
  case(op)
    3'b000: res <= a + b;
    3'b001: res <= a - b;
    3'b010: res <= a & b;
    3'b011: res <= a | b;
    3'b100: res <= a ^ b;
    3'b101: res <= ~(a & b);
    3'b110: res <= ~(a | b);
    3'b111: res <= ~(a ^ b);
  endcase
end

endmodule