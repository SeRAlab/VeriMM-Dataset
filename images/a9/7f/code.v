module top_module(
  input clk, // gated clock input
  input en, // enable input
  input d, // data input
  output reg q // output
);always @(posedge clk) begin
    if (en) begin
      q <= d;
    end
  end

endmodule