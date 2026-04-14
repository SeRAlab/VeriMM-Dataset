module top_module(
		
		iDIG,							
		
		oHEX_D		
	);input	  [3:0]   iDIG;				

output	  [6:0]	  oHEX_D;   






reg	  [6:0]	  oHEX_D;	




always @(iDIG) 
        begin
			case(iDIG)
			4'h0: oHEX_D <= 7'b1000000; 
			4'h1: oHEX_D <= 7'b1111001; 
			4'h2: oHEX_D <= 7'b0100100; 
			4'h3: oHEX_D <= 7'b0110000; 
			4'h4: oHEX_D <= 7'b0011001; 
			4'h5: oHEX_D <= 7'b0010010; 
			4'h6: oHEX_D <= 7'b0000010; 
			4'h7: oHEX_D <= 7'b1111000; 
			4'h8: oHEX_D <= 7'b0000000; 
			4'h9: oHEX_D <= 7'b0011000; 
			4'ha: oHEX_D <= 7'b0001000; 
			4'hb: oHEX_D <= 7'b0000011; 
			4'hc: oHEX_D <= 7'b1000110; 
			4'hd: oHEX_D <= 7'b0100001; 
			4'he: oHEX_D <= 7'b0000110; 
			4'hf: oHEX_D <= 7'b0001110; 
	     default: oHEX_D <= 7'b1000000; 
			endcase
		end

endmodule