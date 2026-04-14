module down_counter (
  input clk,
  input enable,
  input reset,
  output reg [1:0] q
);

  always @(posedge clk) begin
    if (reset)
      q <= 2'b11;
    else if (enable)
      q <= q - 1;
  end

endmodule