module top_module(input clk,input reset,input en,input [1:0] d,output reg [1:0] q);always @(posedge clk) begin
    if(reset) q<=0;
    else begin
		if(en) q <= d;
		end
	end
endmodule