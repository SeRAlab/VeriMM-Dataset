module top_module(
   d_i,
   q_o);parameter g_num_bytes = 4;

   input [g_num_bytes * 8 - 1 : 0] d_i;
   output [g_num_bytes * 8 - 1 : 0] q_o;

   generate 
      genvar                        i, j;
      for(i=0;i<8;i=i+1)
        for(j=0;j<g_num_bytes;j=j+1)
          assign q_o[8 * (g_num_bytes-1-j) + i] = d_i[8 * j + i];
   endgenerate
   
endmodule