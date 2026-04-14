module top_module(
	input wire clk,reset, we4,bt,
	input wire [31:0]d,
	output reg [31:0]q
);always@(posedge clk) begin 
		if(reset) begin
			q<=32'd0;
		end else begin 
			if(we4) begin
				q<=d;				
			end 
		end
	end
endmodule