module top_module(
  input data, clk, reset, enable,
  output reg q
);always @(posedge clk) begin
    if (reset) begin
      q <= 1'b0;
    end else if (enable) begin
      q <= data;
    end
  end

endmodule