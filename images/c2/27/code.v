module slice_module
   (Din,
    Dout);
  input [15:0]Din;
  output [4:0]Dout;

  always @(Din) begin
    Dout[4:0] = Din[12:8];
  end

endmodule