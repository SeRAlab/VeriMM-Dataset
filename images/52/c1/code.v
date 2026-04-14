module top_module(output reg [7:0] reg_0x5F, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
	begin
		if(reset==0) begin
			if(wenb==0)
				reg_0x5F<=in_data;
			else
				reg_0x5F<=reg_0x5F;
		end
		else
			reg_0x5F<=8'h00;
	end
endmodule