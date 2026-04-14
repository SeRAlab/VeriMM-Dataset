module top_module(
	input wire clk,
	input wire reset,
	output wire [31:0]y
    );reg[31:0]q;
	always@(posedge clk) begin
		if( reset )  begin 
			q= 32'd0;
		end else begin
			q= q + 32'd1; 
		end
	end 
	assign y= q;
endmodule