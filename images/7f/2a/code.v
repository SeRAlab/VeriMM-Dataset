module gray_code_counter (clk, rst, gray_count);
   input clk, rst;
   output reg [2:0] gray_count;
   reg [2:0] bin_count;

   always @(posedge clk) begin
      if (rst)
         bin_count <= 3'b000;
      else
         bin_count <= bin_count + 1;
   end

   always @(posedge clk) begin
      if (rst)
         gray_count <= 3'b000;
      else
         gray_count <= bin_count ^ (bin_count >> 1);
   end
endmodule