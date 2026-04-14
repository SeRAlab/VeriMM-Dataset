module top_module(CLK, D, SET, RESET, EN, Q, QN);input CLK, D, SET, RESET, EN;
   output Q, QN;
   reg Q;

   always @(posedge CLK) begin
      if (EN) begin
         if (SET) Q <= 1'b1;
         else if (RESET) Q <= 1'b0;
         else Q <= D;
      end
   end

   assign QN = ~Q;

endmodule