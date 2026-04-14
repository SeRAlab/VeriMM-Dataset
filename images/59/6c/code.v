module top_module(mantissa, result, all_zero);input [26:0] mantissa;
  output [4:0] result;
  output all_zero;
  
  wire top_16 = ~|mantissa[26:11];
  wire top_8 = ~|mantissa[26:19];
  wire top_4 = ~|mantissa[26:23];
  wire top_2 = ~|mantissa[26:25];
  wire bottom_8 = ~(|mantissa[10:3]);
  wire bottom_4 = ~(|mantissa[10:7]);
  wire bottom_2 = ~(|mantissa[10:9]);
  wire all_clear = ~|mantissa;
  assign result[4] = top_16;
  assign result[3] = top_16 & bottom_8 | ~top_16 & top_8;
  assign result[2] = (top_16 & ~bottom_8 & bottom_4) | (~top_16 & top_8 & ~|mantissa[18:15]) | 
							(~top_16 & ~top_8 & top_4);
  assign result[1] = (top_16 & bottom_8 & ~|mantissa[2:1]) | (top_16 & ~bottom_8 & bottom_4 & ~|mantissa[6:5]) |
                     (top_16 & ~bottom_8 & ~bottom_4 & bottom_2) | 
							(~top_16 & top_8 & ~|mantissa[18:17] & |mantissa[16:15]) |
							(~top_16 & top_8 & ~|mantissa[18:13]) |
							(~top_16 & ~top_8 & top_4 & ~|mantissa[22:21]) |
                     (~top_16 & ~top_8 & ~top_4 & top_2);
  assign result[0] = (all_clear) |
						   (~|mantissa[26:2] & mantissa[1]) | 
						   (~|mantissa[26:4] & mantissa[3]) | 
						   (~|mantissa[26:6] & mantissa[5]) | 
						   (~|mantissa[26:8] & mantissa[7]) | 
						   (~|mantissa[26:10] & mantissa[9]) | 
						   (~|mantissa[26:12] & mantissa[11]) | 
						   (~|mantissa[26:14] & mantissa[13]) | 
						   (~|mantissa[26:16] & mantissa[15]) | 
						   (~|mantissa[26:18] & mantissa[17]) | 
						   (~|mantissa[26:20] & mantissa[19]) | 
						   (~|mantissa[26:22] & mantissa[21]) | 
						   (~|mantissa[26:24] & mantissa[23]) | 
						   (~mantissa[26] & mantissa[25]);
  assign all_zero = all_clear;
                     
endmodule