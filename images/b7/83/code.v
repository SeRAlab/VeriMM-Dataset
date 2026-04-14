module top_module(clk, rst,sram_addr,sram_dq, ce_n,oe_n,we_n,ub_n,lb_n);input clk, rst;



inout [15:0] sram_dq;

output [19:0] sram_addr;
output ce_n,oe_n,we_n,ub_n,lb_n;


reg [19:0] sram_addr;
reg [15:0]sram_dq_reg;
reg oe_n,we_n;
reg reading, done, error;

wire ce_n,ub_n,lb_n;
wire dbsw;
wire clk10;
assign sram_dq = we_n ? 16'hzzzz:sram_dq_reg;

assign ce_n=1'b0,
		 ub_n=1'b0,
		 lb_n=1'b0;

		 

always@(posedge clk or negedge rst)
begin
	if (rst==1'b0)
		begin
			oe_n<=1'b0;
			we_n<=1'b0;
			sram_addr<=20'd0;

		end
	else
				begin
					oe_n<=1'b0;
					sram_addr<=count;
					sram_dq_reg<={count[9:2],8'h00};
					if(count==20'hfffff)
						we_n<=1'b1;
				end

		
		
end


reg [19:0] count;

always@(posedge clk or negedge rst)
begin
	if(rst==1'b0)
		count<=19'd0;
	else
		count<=count+19'd1;

end






endmodule