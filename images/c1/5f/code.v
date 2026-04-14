module zzpenc64 (
   z, 
  a 
   );
   input [63:0] a;
   output [5:0] z;
   integer      i;
   reg  [5:0]   z;
     always @ (a)
     begin
          z = 6'b0;
          for (i=0;i<64;i=i+1)
               if (a[i])
                      z = i;
     end
endmodule