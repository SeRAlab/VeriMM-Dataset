module top_module(clkin,clkOut);parameter n=5;
input clkin;
output reg  clkOut;

wire [27:0] stuff;

reg [27:0] divider;
reg [27:0] counter;

always@(n)
begin
	divider=n*1000000;
end

always@(posedge clkin)
	begin
	if(counter>=(divider))	
	begin
		clkOut <= !clkOut;
		counter=0;
	end
	else
		counter=counter+1;
	end
endmodule