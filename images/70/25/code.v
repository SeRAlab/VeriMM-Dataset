module register (
  input clk,
  input load,
  input [3:0] data,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (load)
      q <= data;
  end

endmodule