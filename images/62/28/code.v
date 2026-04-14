module top_module(rst_res_n,peri_o,SVSTOP,Out1,Out0,A);input rst_res_n;
   output peri_o;
   input  SVSTOP;
   output Out1;
   output Out0;
   output  A;
      
   assign peri_o = rst_res_n;endmodule