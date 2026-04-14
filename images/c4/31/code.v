module m2
  (
   input clk,
   input d,
   // Due to bug the below disable used to be ignored.
   // verilator lint_off UNOPT
   // verilator lint_off UNOPTFLAT
   output reg [1:0] q
   // verilator lint_on UNOPT
   // verilator lint_on UNOPTFLAT
   );

   always @(posedge clk) begin
      q[1] <= d;
      q[0] <= q[1];
   end

endmodule