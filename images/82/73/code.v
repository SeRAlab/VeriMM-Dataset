module top_module(aport, dxport, xport, yport, uport, clk, reset);input clk;
input reset;
input [31:0]aport;
input [31:0]dxport;
output [31:0]xport;
output [31:0]yport;
output [31:0]uport;
reg [31:0]xport;
reg [31:0]yport;
reg [31:0]uport;
wire [31:0]temp;

assign temp = uport * dxport;
always @(posedge clk or posedge reset)
begin
	if (reset == 1'b1)
	begin
		xport <= 0;
		yport <= 0;
		uport <= 0;
	end
else
  	if (xport < aport) 
	begin
		xport <= xport + dxport;
		yport <= yport + temp;
		uport <= (uport - (temp * (5 * xport))) - (dxport * (3 * yport));
	end
end
endmodule