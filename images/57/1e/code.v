module top_module(
  input [3:0] a,
  input [3:0] b,
  input en,
  output reg [3:0] mux_out
);always @(*) begin
    if (en)
      mux_out = a;
    else
      mux_out = b;
  end

endmodule