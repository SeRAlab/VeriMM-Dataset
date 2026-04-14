module top_module(out, cout, data, load, cin, clk);output [7:0] out;
output cout;
input [7:0] data;
input load, cin, clk;

reg [7:0] out;
reg cout;
reg [7:0] preout;


always @(posedge clk) 
begin 
	out = preout;
end




always @(out or data or load or cin) 
begin
	{cout, preout} = out + cin;
	if (load) preout = data;
end

endmodule