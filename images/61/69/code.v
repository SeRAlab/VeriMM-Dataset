module register_16bit 
(
  input clk,
  input enable,
  input [15:0] d,

  output reg [15:0] q
);

  always @(posedge clk) begin
    if (enable)
      q <= d;
  end

endmodule