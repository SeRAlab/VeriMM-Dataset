module top_module(
					        
					         clk,
					         we,
					         addr0,
					         addr1,
					         addr2,
					         wd,
					         
					         rd0,
					         rd1
			 					);input clk;
input we;
input  [4:0] addr0;
input  [4:0] addr1;
input  [4:0] addr2;
input  [31:0] wd;
output reg [31:0] rd0;
output reg [31:0] rd1;
 
reg [31:0] register [31:0];

always@(*) begin
	rd0 <= (addr0 == 5'b0) ? 5'b0 : register[addr0];
	rd1 <= (addr1 == 5'b0) ? 5'b0 : register[addr1];
end

always@(posedge clk) begin
	if(we)
		register[addr2] <= (addr2 != 5'b0) ? wd : 32'h0;
	else
		;	
end

endmodule