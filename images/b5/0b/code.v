module top_module(output reg [7:0] reg_0x1C, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
	begin
		if(reset==0) begin
			if(wenb==0)
				reg_0x1C<=in_data;
			else
				reg_0x1C<=reg_0x1C;
		end
		else
			reg_0x1C<=8'h00;
	end
endmodule