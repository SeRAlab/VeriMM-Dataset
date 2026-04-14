module top_module(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, empty, prog_full)
;input rst;
  input wr_clk;
  input rd_clk;
  input [103:0]din;
  input wr_en;
  input rd_en;
  output [103:0]dout;
  output full;
  output empty;
  output prog_full;

   assign empty       =1'b0;
   assign prog_full   =1'b0;
   assign dout[103:0] =103'b0;
   assign full        =1'b0;
   

endmodule