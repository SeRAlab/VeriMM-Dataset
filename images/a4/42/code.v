module reg_with_clear (
  input clk,
  input clr,
  input en,
  input [7:0] data,
  output reg [7:0] q
);

  always @(posedge clk or posedge clr) begin
    if (clr)
      q <= 8'b00000000;
    else if (en)
      q <= data;
  end

endmodule