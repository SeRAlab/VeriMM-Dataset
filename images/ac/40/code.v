module top_module(output reg [7:0] reg_0x60, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
	begin
		if(reset == 1) // reset
			reg_0x60 <= 8'h00;
		else if(wenb == 1) // write data
			reg_0x60 <= in_data;
	end
endmodule