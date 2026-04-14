module top_module(
  input clk,
  input d,
  input set,
  input clear,
  output reg q
);always @(posedge clk) begin
    if (clear) begin
      q <= 0;
    end else if (set) begin
      q <= 1;
    end else begin
      q <= d;
    end
  end

endmodule