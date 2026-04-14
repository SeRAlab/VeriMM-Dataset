module sub (
   input clk,
   input [125:0] a,
   output reg q
   );

   reg [125:0] g_r;

   wire [127:0] g_extend = { g_r, 1'b1, 1'b0 };

   reg [6:0] sel;
   wire g_sel = g_extend[sel];

   always @ (posedge clk) begin
      g_r <= a;
      sel <= a[6:0];
      q <= g_sel;
   end

endmodule