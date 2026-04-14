module top_module(output reg [7:0] reg_0x1D, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
	begin
		if(reset==0) begin
			if(wenb==0)
				reg_0x1D<=in_data;
			else
				reg_0x1D<=reg_0x1D;
		end
		else
			reg_0x1D<=8'h00;
	end
endmodule