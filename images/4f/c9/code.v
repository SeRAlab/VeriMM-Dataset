module top_module(oSEG, iDIG);input   [4:0]   iDIG;
output  [6:0]   oSEG;
reg     [6:0]   oSEG;

always @(iDIG)
begin
  case(iDIG)
  5'h00: oSEG = 7'b1000000;
  5'h01: oSEG = 7'b1111001;        
  5'h02: oSEG = 7'b0100100;        
  5'h03: oSEG = 7'b0110000;        
  5'h04: oSEG = 7'b0011001;        
  5'h05: oSEG = 7'b0010010;        
  5'h06: oSEG = 7'b0000010;        
  5'h07: oSEG = 7'b1111000;        
  5'h08: oSEG = 7'b0000000;        
  5'h09: oSEG = 7'b0010000;        
  5'h0a: oSEG = 7'b0001000;
  5'h0b: oSEG = 7'b0000011;
  5'h0c: oSEG = 7'b1000110;
  5'h0d: oSEG = 7'b0100001;
  5'h0e: oSEG = 7'b0000110;
  5'h0f: oSEG = 7'b0001110;
  5'h10: oSEG = 7'b1111111; 
  5'h11: oSEG = 7'b0001001; 
  5'h12: oSEG = 7'b0001011; 
  5'h13: oSEG = 7'b0100011; 
  5'h14: oSEG = 7'b1000111; 
  5'h15: oSEG = 7'b0001100; 
  5'h16: oSEG = 7'b0000111; 
  5'h17: oSEG = 7'b1100011; 
  5'h18: oSEG = 7'b0010001; 
  5'h19: oSEG = 7'b0111111; 
  5'h1a: oSEG = 7'b0100000; 
  5'h1b: oSEG = 7'b0011100; 
  5'h1c: oSEG = 7'b0100111; 
  5'h1d: oSEG = 7'b0101011; 
  5'h1e: oSEG = 7'b0000100; 
  5'h1f: oSEG = 7'b0101111; 
  endcase
end

endmodule