module top_module(CLK, RST, Tao_Q, write, ready);input CLK,RST,write;
input [31:0] Tao_Q;
output reg ready=0;

reg [31:0] Tao_cnt=8'hff;
reg [31:0] tmp_cnt=0;
reg ready2;

always @(posedge CLK)
		if (RST) begin
			tmp_cnt<=0;
			ready<=0;
			ready2<=0;
			end
			
		else if (write) begin 
			Tao_cnt<=Tao_Q;
			tmp_cnt<=0;
			ready<=0;
			ready2<=0;
			end
			
		else if (tmp_cnt!=Tao_cnt && !ready2) begin 
			tmp_cnt<=tmp_cnt+1;
			ready<=0;
			end
			
		else if (tmp_cnt==Tao_cnt &&!ready2)begin 
			ready<=1;
			ready2<=1;
			tmp_cnt<=0;
			end	
			
		else if (tmp_cnt!=Tao_cnt && ready2) begin 
			tmp_cnt<=tmp_cnt+1;
			ready<=1;
			ready2<=0;
			end

endmodule