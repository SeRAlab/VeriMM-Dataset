module dff_async_reset (
  input clk,
  input reset,
  input d,
  output reg q
);

  always @(posedge clk) begin
    if (reset == 1'b0) begin
      q <= 1'b0;
    end else begin
      q <= d;
    end
  end

endmodule