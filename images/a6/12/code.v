module top_module(
		    input wire bclk,

		    
		    input wire [15:0] bus_ad, 
		    input wire [2:0] bus_a, 
		    input wire adv, 
		    input wire rw,  
		    input wire cs,  

		    output reg [15:0] measured_burst
		    );reg 				 activated;
   reg [15:0] 			 bus_ad_r;
   reg 				 cs_r;
   reg [2:0] 			 bus_a_r;
   reg 				 rw_r;
   reg 				 adv_r;

   reg [15:0] 			 burstcnt;
   reg [15:0] 			 finalcnt;

   reg 				 activated_d;
   
   always @(posedge bclk) begin
      bus_ad_r <= bus_ad;
      bus_a_r <= bus_a;
      cs_r <= cs;
      rw_r <= rw;
      adv_r <= adv;
      
      if( cs_r && adv_r && ({bus_a_r, bus_ad_r[15:12]} == 7'h4_F) ) begin 
	 activated <= 1'b1;
      end else if( !cs_r ) begin
	 activated <= 1'b0;
      end else begin
	 activated <= activated;
      end 

      if( !activated ) begin
	 finalcnt <= burstcnt;
	 burstcnt <= 16'h0;
      end else begin
	 burstcnt <= burstcnt + 16'h1;
	 finalcnt <= finalcnt;
      end

      activated_d <= activated;
      if( activated_d & !activated ) begin 
	 measured_burst <= finalcnt + 1'b1; 
      end else begin
	 measured_burst <= measured_burst;
      end
   end 

   

endmodule