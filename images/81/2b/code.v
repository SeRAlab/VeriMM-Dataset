module top_module(
  input [8:0] in,
  output reg [1:0] out
);always @(in) begin
    out[0] <= ~(in[0] & in[1]);
    out[1] <= ~(in[2] & in[3] & in[4] & in[5]);
  end

endmodule