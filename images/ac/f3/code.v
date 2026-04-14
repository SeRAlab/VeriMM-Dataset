module top_module(input wire IN0,input wire IN1,input wire IN2,input wire IN3,output wire OUT);parameter [15:0] INIT = 0; 
  assign OUT = INIT[{IN3, IN2, IN1, IN0}]; 
 endmodule