module top_module(
   input               clk,
   input               reset_l,
   input               enable,

   input       [ 9:0]  q_var0,
   input       [ 9:0]  q_var2,
   input       [ 9:0]  q_var4,
   input       [ 9:0]  q_var6,

   output reg  [2:0]   q
   );reg [7:0] 	       p1_r [6:0];

   always @(posedge clk) begin
      if (!reset_l) begin
         p1_r[0]       <= 'b0;
         p1_r[1]       <= 'b0;
         p1_r[2]       <= 'b0;
         p1_r[3]       <= 'b0;
         p1_r[4]       <= 'b0;
         p1_r[5]       <= 'b0;
         p1_r[6]       <= 'b0;
      end
      else if (enable) begin : pass1
         match(q_var0, q_var2, q_var4, q_var6);
      end
   end

   
   always @(posedge clk) begin : l
      reg [10:0]  bd;
      reg [3:0]   idx;

      q = 0;
      bd = 0;
      for (idx=0; idx<7; idx=idx+1) begin
	 q       = idx+1;
	 bd    = bd + p1_r[idx];
      end
   end


   task match;
      input   [9:0]   p0, p1, p2, p3;
      reg [9:0]       p[3:0];
      begin
	 p[0]  = p0;
	 p[1]  = p1;
	 p[2]  = p2;
	 p[3]  = p3;
	 p1_r[0] = p[0];
	 p1_r[1] = p[1];
      end
   endtask
endmodule