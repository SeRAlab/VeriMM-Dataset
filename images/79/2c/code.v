module top_module(output reg [7:0] reg_0x3C, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
	begin
		if(reset==0) begin
			if(wenb==0)
				reg_0x3C<=in_data;
			else
				reg_0x3C<=reg_0x3C;
		end
		else
			reg_0x3C<=8'h00;
	end
endmodule