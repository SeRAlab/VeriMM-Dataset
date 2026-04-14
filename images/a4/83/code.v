module top_module(data,clk,reset,out);input data,clk,reset;
output reg out;

always @(posedge clk, posedge reset) begin
	if(reset) out<=0;
	else out<=data;
end

endmodule