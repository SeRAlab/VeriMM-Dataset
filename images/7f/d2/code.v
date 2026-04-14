module top_module(clk, wr_enb, rd_enb, rst, rd_ptr, wr_ptr,
		      data_in, data_out);parameter RAM_WIDTH = 10;
   parameter RAM_DEPTH = 8;
   parameter PTR_SIZE = 3;

   input clk, wr_enb, rd_enb, rst;
   input [RAM_WIDTH-1:0] data_in;
   input [PTR_SIZE-1:0]  rd_ptr, wr_ptr;
   output reg [RAM_WIDTH-1:0] data_out;

   reg [RAM_WIDTH-1:0] 	      mem[RAM_DEPTH-1:0];
   integer 		      i;

   always @(posedge clk) begin
      
      if (rst) begin
	 for (i=0; i<RAM_DEPTH; i=i+1)
	   mem[i] <= 0;
	 data_out <= 0;
      end

      else begin
	 if (wr_enb)
	   mem[wr_ptr] <= data_in;
	 if (rd_enb)
	   data_out <= mem[rd_ptr];
      end 
   end 

endmodule