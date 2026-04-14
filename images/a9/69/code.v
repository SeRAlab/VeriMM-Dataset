module top_module(IN1, IN2, IN3, IN4, IN5, IN6, QN);input IN1, IN2, IN3, IN4, IN5, IN6;
   output QN;

   wire Otemp0, Otemp1, Otemp2;
   
   // Implement the three OR2 gates
   assign Otemp0 = IN1 | IN2;
   assign Otemp1 = IN3 | IN4;
   assign Otemp2 = IN5 | IN6;
   
   // Implement the NAND3 gate
   assign QN = ~(Otemp0 & Otemp1 & Otemp2);
   
endmodule