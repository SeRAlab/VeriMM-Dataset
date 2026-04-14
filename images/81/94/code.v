module top_module(
	input clk, 
	input reset,
	
	input req,
	input [31:0] addr,
	input cmd,
	input [31:0] wdata,
	
	output reg ack,
	output reg [31:0] rdata_tr
);reg [31:0] data;
reg [31:0] rdata;
reg [31:0] addr_;



always@(posedge clk, posedge reset)
begin
	if(reset) begin
		rdata <= 32'b0;
		data <= 32'b0;
		addr_ <= 32'b0;
		ack <= 1'b0;
		end
	else if (req) 
		if (addr !== addr_) begin
			addr_<=addr;
			if (cmd) begin	
				ack <= 1'b1;
				data <= wdata;
				end
			else begin
				ack <= 1'b1;
				rdata <= data;
				end
			end
		else ack <= 1'b0;
	else ack <= 1'b0;
end


always@(posedge clk, posedge reset)
begin
if (reset)
	rdata_tr<=32'b0;
else 
	rdata_tr <= rdata;
end

endmodule