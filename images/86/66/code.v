module register8bit (
  input clk,
  input en,
  input rst,
  input [7:0] d,
  output reg [7:0] q
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 8'b00000000;
    else if (en)
      q <= d;
  end

endmodule