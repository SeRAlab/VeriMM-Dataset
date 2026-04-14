module top_module(J,K,clk,reset,Qn,QnBar);input J,K,clk,reset;
output reg Qn,QnBar;
reg PS;
always @(posedge clk)
		begin
			if(reset)
				begin
					PS = 0;
				end	
			else
				begin
					if(J==0 && K==0)
						begin
							Qn = PS;
							QnBar = ~Qn;
						end
					else if(J==0 && K==1)
						begin
							PS = 0;
							Qn = PS;
							QnBar = ~Qn;
						end	
					else if(J==1 && K==0)
						begin
							PS = 1;
							Qn = PS;
							QnBar = ~Qn;
						end	
					else if(J==1 && K==1)
						begin
							Qn = ~PS;
							PS = Qn;
							QnBar = ~Qn;
						end			
				end
		end
endmodule