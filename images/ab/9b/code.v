module top_module(
   
   o_seq_d1r, o_com, o2_com,
   
   clk, i_seq, i_com, i2_com, wide_for_trace, wide_for_trace_2
   );input clk;

   input        i_seq;
   output       o_seq_d1r;
   input        i_com;
   output       o_com;
   input [1:0]  i2_com;
   output [1:0] o2_com;
   input [127:0] wide_for_trace;
   input [127:0] wide_for_trace_2;

   
   
   

   reg                  o_seq_d1r;
   always @ (posedge clk) begin
      o_seq_d1r <= ~i_seq;
   end

   wire [1:0] o2_com = ~i2_com;
   wire       o_com = ~i_com;

endmodule