module top_module(
   d_i,
   shifted_o,
   shift_i
   );parameter g_data_bytes = 3;
   parameter g_max_shift = 3;

   localparam c_output_width = 8 * (g_data_bytes + g_max_shift);

   input [3:0] shift_i;
   input [g_data_bytes * 8 - 1: 0] d_i;
   output [c_output_width - 1: 0]  shifted_o;
   
   wire [c_output_width - 1 : 0]   gen_array[0:g_max_shift];

   genvar                          i;

   generate
      for (i=0;i<g_max_shift;i=i+1)
        assign gen_array[i] = d_i << (i * 8);
   endgenerate

   assign shifted_o = gen_array[shift_i];
endmodule