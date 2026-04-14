module top_module( Q, CLK, ENA, D, CLRN, PRN );input D;
   input CLK;
   input CLRN;
   input PRN;
   input ENA;
   output Q;
   
   reg Q_reg;
   
   always @(posedge CLK) begin
      if (ENA == 1'b1) begin
         Q_reg <= D;
      end
   end
   
   always @(negedge CLRN) begin
      if (CLRN == 1'b1) begin
         Q_reg <= 1'b0;
      end
   end
   
   always @(negedge PRN) begin
      if (PRN == 1'b1) begin
         Q_reg <= 1'b1;
      end
   end
   
   assign Q = Q_reg;
endmodule