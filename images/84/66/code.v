module top_module(output [7:0]hex, input [3:0]sw);assign hex[0] = (~sw[3] & ~sw[1]) & ((~sw[2] & sw[0]) | (sw[2] & ~sw[0])) |
              (sw[3] & sw[0]) & ((sw[2] & ~sw[1]) | (~sw[2] & sw[1]));
  
  assign hex[1] = (~sw[3] & sw[2]) & ((~sw[1] & sw[0]) | (sw[1] & ~sw[0])) |
              (sw[3]) & ((sw[2] & ~sw[0]) | (sw[1] & sw[0]));
  
  assign hex[2] = (~sw[3] & ~sw[2] & sw[1] & ~sw[0]) |
              (sw[3] & sw[2]) & ((~sw[1] & ~sw[0]) | sw[1]);
  
  assign hex[3] = (~sw[3] & ~sw[1]) & ((sw[2] & ~sw[0]) | (~sw[2] & sw[0])) |
              (sw[1]) & ((sw[2] & sw[0]) | (sw[3] & ~sw[2] & ~sw[0]));
  
  assign hex[4] = (~sw[3]) & (sw[0] | (sw[2] & ~sw[1] & ~sw[0])) | 
              (sw[3] & ~sw[2] & ~sw[1] & sw[0]);
  
  assign hex[5] = (~sw[3] & ~sw[2]) & (sw[1] | (~sw[1] & sw[0])) |
              (sw[3] & sw[2] & ~sw[1] & sw[0]);
  
  assign hex[6] = ~sw[3] & ((~sw[2] & ~sw[1]) | (sw[2] & sw[1] & sw[0])) |
              (sw[3] & sw[2] & ~sw[1] & ~sw[0]);endmodule