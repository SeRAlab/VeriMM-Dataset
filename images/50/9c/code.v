module top_module( clk, d, q );parameter bitWidth = 8;

   
   input  d, clk;
   output q;

   
   reg q;
   reg [bitWidth-1:0] m_reg;

   always @ (posedge clk) begin
     {q, m_reg} = {m_reg, d};
   end

endmodule