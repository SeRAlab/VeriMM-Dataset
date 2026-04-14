module top_module(
	input clk,    
	input rst,  
	input [4:0] src1,
	input [4:0] src2,
	input [4:0] dest,
	input [31:0] Write_Val,
	input Write_EN,
	output reg[31:0]reg1,
	output reg[31:0]reg2
);reg [31:0]register[31:0];
integer i;

always @(*) begin : proc_READ
	if(rst) begin
		reg1 = 0;
		reg2 = 0;
	end else begin
		reg1 = register[src1];
		reg2 = register[src2];
	end
end

always @(negedge clk, posedge rst) begin : proc_WRITE
	if(rst) begin
		for(i=0; i < 32; i = i + 1) begin
			register[i] = i;
		end
	end 
	else 
	begin
		if (Write_EN) 
		begin
			register[dest] <= Write_Val;
		end
	end
end

endmodule