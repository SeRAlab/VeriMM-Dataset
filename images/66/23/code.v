module top_module(OUT, IN1, IN2, Select);input   IN1, IN2, Select;
   output  OUT;
   
   assign OUT = Select ? IN1 : IN2;

endmodule