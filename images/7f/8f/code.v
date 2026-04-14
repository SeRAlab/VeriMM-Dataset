module top_module(
  input [n-1:0] in1,
  input [n-1:0] in2,
  input [1:0] ctrl,
  output reg out
);parameter n = 4; // number of bits in the input signals

always @(*) begin
  case (ctrl)
    2'b00: out = (in1 == in2);
    2'b01: out = (in1 > in2);
    2'b10: out = (in1 < in2);
    default: out = 1'b0;
  endcase
end

endmodule