module top_module(
   // Inputs
   clk,
   m_din
   );input clk;
   input [15:0] m_din;
   integer cyc; initial cyc=1;

   reg [15:0] b_split_1, b_split_2;
   always @ (m_din) begin
      b_split_1 = m_din;
      b_split_2 = b_split_1;
   end

   reg [15:0] c_split_1, c_split_2;
   always @ (m_din) begin
      c_split_1 = m_din;
      c_split_2 = c_split_1;
      c_split_1 = ~m_din;
   end

   reg [15:0] e_split_1, e_split_2;
   always @ (posedge clk) begin
      e_split_1 = m_din;
      e_split_2 = e_split_1;
   end

   reg [15:0] f_split_1, f_split_2;
   always @ (posedge clk) begin
      f_split_2 = f_split_1;
      f_split_1 = m_din;
   end

   reg [15:0] l_split_1, l_split_2;
   always @ (posedge clk) begin
      l_split_2 <= l_split_1;
      l_split_1 <= l_split_2 | m_din;
   end

   reg [15:0] z_split_1, z_split_2;
   always @ (posedge clk) begin
      z_split_1 <= 0;
      z_split_1 <= ~m_din;
   end
   always @ (posedge clk) begin
      z_split_2 <= 0;
      z_split_2 <= z_split_1;
   end

   reg [15:0] h_split_1;
   reg [15:0] h_split_2;
   reg [15:0] h_foo;
   always @ (posedge clk) begin
      h_foo = m_din;
      if (cyc > 2) begin
         // This conditional depends on non-primary-input foo.
         // Its dependency on foo should not be pruned. As a result,
         // the dependencies of h_split_1 and h_split_2 on this
         // conditional will also not be pruned, making them all
         // weakly connected such that they'll end up in the same graph
         // and we can't split.
         if (h_foo == 16'h0) begin
            h_split_1 <= 16'h0;
            h_split_2 <= 16'h0;
         end
         else begin
            h_split_1 <= m_din;
            h_split_2 <= ~m_din;
         end
      end
      else begin
         h_split_1 <= 16'h0;
         h_split_2 <= 16'h0;
      end
   end  // always @ (posedge clk)

endmodule