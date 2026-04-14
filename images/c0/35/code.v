module zzpar8 ( z, d );
   input  [7:0] d;
   output       z;
   assign  z =  d[0] ^ d[1] ^ d[2] ^ d[3] ^ d[4] ^ d[5] ^ d[6] ^ d[7]; 
endmodule