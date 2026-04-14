module top_module(
    
    output reg heartbeat,

    input reset,
    input clk
    
    );parameter MAX_COUNT = 6250000;
   
   reg [23:0] ten_hertz_count;

   always @(posedge clk)
     if (reset) ten_hertz_count <= 'h0;
     else
       if (ten_hertz_count == MAX_COUNT) ten_hertz_count <= 'h0;
       else ten_hertz_count <= ten_hertz_count + 24'h1;
   

   reg 	      ten_hertz;

   always @(posedge clk)
     if (reset) ten_hertz <= 'h0;
     else ten_hertz <= (ten_hertz_count == MAX_COUNT) ? 1 : 0;


   
   
   reg [4:0]  slow_count;

   always @(posedge clk)
     if (reset) slow_count <= 'h0;
     else if (ten_hertz) begin
	if (slow_count == 20) slow_count <= 'h0;
	else                  slow_count <= slow_count + 'h1;
     end
   
   

   reg 	      heartbeat_nxt;
   
   always @* begin
      heartbeat_nxt = 1;
      if (slow_count == 'd0 ) heartbeat_nxt = 0;
      if (slow_count == 'd2 ) heartbeat_nxt = 0;
      if (slow_count == 'd10) heartbeat_nxt = 0;
      if (slow_count == 'd12) heartbeat_nxt = 0;
   end
     
   always @(posedge clk) heartbeat <= heartbeat_nxt;

endmodule