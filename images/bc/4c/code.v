module top_module(IN1, IN2, IN3, IN4, S0, S1, Q);input IN1, IN2, IN3, IN4, S0, S1;
 output Q;

 wire t1, t2;

 // Instantiate a 2-to-1 multiplexer for inputs IN1 and IN2
 assign t1 = (S1) ? IN2 : IN1;

 // Instantiate a 2-to-1 multiplexer for inputs IN3 and IN4
 assign t2 = (S1) ? IN4 : IN3;

 // Instantiate a final 2-to-1 multiplexer to select between t1 and t2 based on S0
 assign Q = (S0) ? t2 : t1;

endmodule