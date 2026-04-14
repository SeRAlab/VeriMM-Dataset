module top_module(input clk, input reset,
   input run,
   input [7:0] decim,
   output strobe,
   output reg [31:0] sample);reg [15:0] 	  pktnum = 0;
   reg [15:0] 	 counter = 0;

   reg 		 run_d1;
   always @(posedge clk) run_d1 <= run;
   
   always @(posedge clk)
     if(run & ~run_d1)
       begin
	  counter 		<= 0;
	  pktnum 		<= pktnum + 1;
       end
     else if(run & strobe)
       counter 			<= counter + 1;
       
   assign sample 		 = {pktnum,counter};

   reg [7:0] stb_ctr = 0;
   
   always @(posedge clk)
     if(reset)
       stb_ctr 	 <= 0;
     else if(run & ~run_d1)
       stb_ctr 	 <= 1;
     else if(run)
       if(stb_ctr == decim-1)
	 stb_ctr <= 0;
       else
	 stb_ctr <= stb_ctr + 1;

   assign strobe  = stb_ctr == decim-1;
   
endmodule