module counter_4bit_async_clear(
  input clk,
  input clear,
  output reg [3:0] q
);

  always @(posedge clk or posedge clear) begin
    if (clear)
      q <= 4'b0000;
    else
      q <= q + 1'b1;
  end

endmodule