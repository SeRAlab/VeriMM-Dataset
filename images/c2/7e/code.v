module memidxrng (
   input clk,
   input rst,
   input en,
   input [3:0] in_num,
   output reg [2:0] out_num
);

   reg [11:0] mem_idx;

   always @(posedge clk, posedge rst)
   begin
      if (rst)
         mem_idx <= 12'h0;
      else if (en)
         mem_idx <= mem_idx + 1;
   end

   always @(posedge clk)
   begin
      if (rst)
         out_num <= 3'h0;
      else if (en)
         out_num <= mem_idx[11:9];
      else
         out_num <= 3'h0;
   end

endmodule