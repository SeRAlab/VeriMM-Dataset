module concat (
  input [7:0] In0,
  input [1:0] In1,
  input clk,
  output [9:0] dout
);

  always @(posedge clk) begin
    dout[9:8] <= In1;
    dout[7:0] <= In0;
  end

endmodule