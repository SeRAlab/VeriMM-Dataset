module register (
  input [7:0] d,
  input clk,
  input load,
  input clr,
  output reg [7:0] q
);

  always @(posedge clk) begin
    if (clr)
      q <= 8'b00000000;
    else if (load)
      q <= d;
  end

endmodule