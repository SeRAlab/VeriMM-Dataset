module top_module(
   
   o_w5, o_w5_d1r, o_w40, o_w104,
   
   clk, i_w5, i_w40, i_w104
   );input clk;

   input [4:0]          i_w5;
   output [4:0]         o_w5;
   output [4:0]         o_w5_d1r;
   input [39:0]         i_w40;
   output [39:0]        o_w40;
   input [104:0]        i_w104;
   output [104:0]       o_w104;

   wire [4:0]  o_w5 = i_w5;
   wire [39:0] o_w40 = i_w40;
   wire [104:0] o_w104 = i_w104;

   
   
   reg [4:0]            o_w5_d1r;
   

   always @ (posedge clk) begin
      o_w5_d1r <= i_w5;
   end

endmodule