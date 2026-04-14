module register_8bit(
  input clk,
  input rst,
  input en,
  input [7:0] d,
  output reg [7:0] q
);

  always @(posedge clk) begin
    if (rst)
      q <= 8'b00000000;
    else if (en)
      q <= d;
  end

endmodule