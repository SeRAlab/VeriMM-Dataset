module top_module(
  input [3:0] in,
  output reg [1:0] out
);always @(*) begin
    out = ~in + 1;
    out = out[1:0];
  end

endmodule