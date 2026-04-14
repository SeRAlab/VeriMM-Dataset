module top_module(IN1, IN2, IN3, IN4, QN);input IN1;
 input IN2, IN3, IN4;
 output QN;

 wire n1, n2, n3, n4;

 // Define the NOR gate using the 'nor' primitive
 assign n1 = ~(IN1 | IN2);
 assign n2 = ~(IN3 | IN4);
 assign n3 = ~(n1 | n2);
 assign n4 = ~(n3 | n3);

 assign QN = ~(n4 | n4);

endmodule