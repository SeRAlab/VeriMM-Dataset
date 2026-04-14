module top_module(
  input [7:0] ascii,
  output [n-1:0] seg
);parameter n = 8; // number of segments in the LCD display

assign seg[0] = (ascii == 8'h41 || ascii == 8'h61 || ascii == 8'hC1 || ascii == 8'hE1); // segment a
assign seg[1] = (ascii == 8'h42 || ascii == 8'h62 || ascii == 8'hC2 || ascii == 8'hE2); // segment b
assign seg[2] = (ascii == 8'h43 || ascii == 8'h63 || ascii == 8'hC3 || ascii == 8'hE3); // segment c
assign seg[3] = (ascii == 8'h44 || ascii == 8'h64 || ascii == 8'hC4 || ascii == 8'hE4); // segment d
assign seg[4] = (ascii == 8'h45 || ascii == 8'h65 || ascii == 8'hC5 || ascii == 8'hE5); // segment e
assign seg[5] = (ascii == 8'h46 || ascii == 8'h66 || ascii == 8'hC6 || ascii == 8'hE6); // segment f
assign seg[6] = (ascii == 8'h47 || ascii == 8'h67 || ascii == 8'hC7 || ascii == 8'hE7); // segment g
assign seg[7] = (ascii == 8'h20); // space

endmodule