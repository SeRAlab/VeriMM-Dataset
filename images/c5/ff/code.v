module slice_module(
    input [17:0] Din,
    output [9:0] Dout
  );
  
  assign Dout = Din[12:3];
  
endmodule