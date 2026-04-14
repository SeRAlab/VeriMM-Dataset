module top_module( PIN1, PIN2, GIN1, GIN2, POUT, GOUT );input  PIN1;
   input  PIN2;
   input  GIN1;
   input  GIN2;
   output POUT;
   output GOUT;
   assign POUT =  ~ (PIN1 | PIN2);
   assign GOUT =  ~ (GIN2 & (PIN2 | GIN1));
endmodule