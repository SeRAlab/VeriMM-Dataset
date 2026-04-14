module top_module(output reg [7:0] reg_0x19, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
	begin
		if(reset==0) begin
			if(wenb==0)
				reg_0x19<=in_data;
			else
				reg_0x19<=reg_0x19;
		end
		else
			reg_0x19<=8'h00;
	end
endmodule