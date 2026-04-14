module top_module(
  input [3:0] a,
  input [3:0] b,
  input [1:0] ctrl,
  output reg [3:0] out
);always @(*) begin
  case (ctrl)
    2'b00: out = a & b;
    2'b01: out = a | b;
    2'b10: out = a ^ b;
    2'b11: out = ~(a & b);
    default: out = 4'b0;
  endcase
end

endmodule