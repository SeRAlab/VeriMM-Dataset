module top_module(
                   input             clk, 
                   input             rst,
                   input             mem_read, 
                   input             mem_write,
                   input [31:0]      alu_result, 
                   input [31:0]      B,
                   input [4:0]       dst_reg,
                   input             wb_reg_write,
                   input             wb_mem_to_reg,
                   
                   input pstop_i,
                   
                   output reg [4:0]  MEM_WB_dst_reg,
                   output reg        MEM_WB_reg_write,
                   output reg        MEM_WB_mem_to_reg,
                   output reg [31:0] MEM_WB_mem_out,
                   output reg [31:0] MEM_WB_alu_out,

                   
                   output            d_read_en,
                   output            d_write_en,
                   output [31:0]     d_addr,
                   output [31:0]     d_write_data,
                   input [31:0]      d_data_in                   
   );assign d_read_en    = mem_read;
   assign d_write_en   = mem_write;
   assign d_addr       = alu_result;
   assign d_write_data = B;


   

   always @(posedge clk) begin
      if (rst)
        begin
           MEM_WB_dst_reg <= 0;
           MEM_WB_reg_write <= 0;
           MEM_WB_mem_to_reg <= 0;
           MEM_WB_mem_out <= 0;
           MEM_WB_alu_out <= 0;
        end
      else
        begin
           MEM_WB_dst_reg <= dst_reg;
           MEM_WB_reg_write <= wb_reg_write;
           MEM_WB_mem_to_reg <= wb_mem_to_reg;
           MEM_WB_mem_out <= d_data_in;
           MEM_WB_alu_out <= alu_result;
        end
   end


endmodule