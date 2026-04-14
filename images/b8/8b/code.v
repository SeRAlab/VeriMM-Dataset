module top_module(
    CLK, RST, 
	 
	 WEnable, WDone, Send, WCnt,           
	 REnable, RReady, Receive, RcvOut, RCnt        
);input CLK, RST;
	 input WDone, RReady;
	 input [15:0] Receive;
	 output reg WEnable, REnable;
	 output reg [15:0] Send;
	 output reg [15:0] RcvOut;
	 
	 output reg [9:0] WCnt;               
	 output reg [9:0] RCnt;                    
	 
	 
	 
	 reg [3:0] StatW;
	 reg [3:0] StatR;            
	 
	 
	 always @ (posedge CLK or negedge RST)
	 
		if (!RST) begin
			WEnable <= 0;
			Send <= 0;
			WCnt <= 0;
			StatW <= 4'd0;
		end
		else begin
			case (StatW)
			0: begin
					WEnable <= 0;
					Send <= 0;
					WCnt <= 10;
					StatW <= 1;
				end



















				
			 default: StatW <= 0;
			 endcase
		end
		
	 
	 always @ (posedge CLK or negedge RST)
	 
		if (!RST) begin
			REnable <= 0;
			RCnt <= 0;
			RcvOut <= 0;
			StatR <= 4'd0;
		end
		else begin
			
		end
		
						
endmodule