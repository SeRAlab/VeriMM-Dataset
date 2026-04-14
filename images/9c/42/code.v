module counter2bit (
  input clk,
  input reset,
  input en,
  output reg [1:0] q
);

  always @(posedge clk) begin
    if (reset)
      q <= 2'b0;
    else if (en)
      q <= q + 1;
  end

endmodule