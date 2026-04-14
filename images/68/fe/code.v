module top_module(
   
   clk
   );input clk;

   reg  [7:0] x;
   wire [3:0] en;
   wire       sel;
   wire       a;

   
   generate
      genvar  g_k;
      for ( g_k = 0; g_k < 8; g_k = g_k + 1 )
        begin: g_index
           always @* begin
              
              
              if(g_k<4) begin
                 x[g_k] = (sel == 1'b1) ? 1'b1 : (en[g_k] == 1'b0) ? 1'b1 : a;
              end
              else begin
                 x[g_k] = (sel == 1'b0) ? 1'b1 : (en[g_k-4] == 1'b0) ? 1'b1 : a;
              end
              
           end
        end
   endgenerate

endmodule