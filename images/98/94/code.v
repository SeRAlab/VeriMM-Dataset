module top_module(
	
	input clk,
	input reset,
	input load,
	input signed [15:0] lin, rin,
	output lpdm, rpdm
);reg [15:0] lob, rob;
	always @(posedge clk)
	begin
		lob <= lin ^ 16'h8000;
		rob <= rin ^ 16'h8000;
	end
	
	
	reg [16:0] lsdacc, rsdacc;
	always @(posedge clk)
	begin
		lsdacc <= {1'b0,lsdacc[15:0]} + {1'b0,lob};
		rsdacc <= {1'b0,rsdacc[15:0]} + {1'b0,rob};
	end
	
	
	assign lpdm = lsdacc[16];
	assign rpdm = rsdacc[16];
endmodule