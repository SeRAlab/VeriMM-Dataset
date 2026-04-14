module top_module(
	input wire in,
	input wire rst,
	
	output reg out
);always @ (posedge in or negedge rst) begin
	if(rst == 0) begin
		
		out <= 0;
	
	end
	else begin
	
		out <= ~out;
		
	end
end


endmodule