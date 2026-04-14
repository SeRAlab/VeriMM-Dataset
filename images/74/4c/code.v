module top_module(clk,rst,WriteReg,Rs_Addr,Rt_Addr,Rd_Addr,WriteData,Rs,Rt);input clk, rst;
	input WriteReg;
	input[4:0] Rs_Addr, Rt_Addr, Rd_Addr;
	input[31:0] WriteData;

	output[31:0] Rs, Rt;
		wire[31:0] Rs, Rt;

	integer i;

	reg[31:0] buff[1:31];

	assign Rs = (Rs_Addr==32'd0)?32'd0:buff[Rs_Addr];
	assign Rt = (Rt_Addr==32'd0)?32'd0:buff[Rt_Addr];

	always @(negedge clk or negedge rst)
	begin
		if(!rst)
			for(i=1; i<32; i=i+1)
				buff[i] <= 32'd0;
		else
			if(WriteReg)
				buff[Rd_Addr] <= WriteData;
	end

endmodule