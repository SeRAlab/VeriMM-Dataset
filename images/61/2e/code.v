module top_module(
  Din,
  Dout
);input wire [39 : 0] Din;
output wire Dout; // changed Dout width to 1 bit

// Replacing the reference to xlslice with proper functionality
assign Dout = Din[0]; // Directly assigning the least significant bit of Din to Dout

endmodule