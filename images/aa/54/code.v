module top_module(input [63:0] time_now,input [63:0] trigger_time,output now,output early,output late,output too_early);assign now = time_now == trigger_time; 
  assign late = time_now > trigger_time; 
  assign early = ~now & ~late; 
  assign too_early = 0; 
 endmodule