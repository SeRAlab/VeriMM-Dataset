module top_module(clk, peripheralClkEdge, parallelLoad, parallelDataIn, serialDataIn, parallelDataOut, serialDataOut);parameter width = 8;
input               clk;
input               peripheralClkEdge;
input               parallelLoad;
output[width-1:0]   parallelDataOut;
output              serialDataOut;
input[width-1:0]    parallelDataIn;
input               serialDataIn;
reg[width-1:0]      shiftregistermem;
always @(posedge clk) begin
 
if (peripheralClkEdge) begin
	shiftregistermem[width-1:0] <= {shiftregistermem[width-2:0],serialDataIn};
end

if (parallelLoad) begin
	shiftregistermem <= parallelDataIn;
end

end

assign serialDataOut = shiftregistermem[width-1];
assign parallelDataOut = shiftregistermem;endmodule