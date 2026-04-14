module binary_counter_3bit(
  input clk,
  input rst_n,
  input en,
  output reg [2:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      q <= 3'b000;
    else if (en)
      q <= q + 1;
  end

endmodule