module top_module(outf, inp8, clk,load,reset);input clk, reset, load;
input [7:0] inp8; 	
output [7:0] outf; 	
wire out1, out2,out3; 	
reg [7:0] ff; 		
always @(posedge clk or posedge reset)
begin 
	if (reset) begin
		ff <= 0;
		
	end
	else if (load) begin
		ff <= inp8;
	end
	else begin
		ff[6:0] = (ff[7:1]); 
		ff[7] = out3; 
	end
end
assign out1 = ff[1];
assign out2 = ff[0];
assign out3 = out1^out2;
assign 	outf = ff;
endmodule