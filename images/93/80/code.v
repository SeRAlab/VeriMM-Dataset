module top_module(
		  output wire [7:0] asciiHex,
		  input       [3:0] hx
		  );wire 			    lowerTen;
   assign lowerTen = ~hx[3]  | ~hx[2] & ~hx[1];

   assign asciiHex = lowerTen ? 
		  {4'h3, hx[3:0]} :
		  {4'h6, 1'b0,
                   ~hx[1] & hx[0] | hx[2] & hx[1],
                   ~hx[1] & ~hx[0] | hx[1] & hx[0],
                   ~hx[0]};endmodule