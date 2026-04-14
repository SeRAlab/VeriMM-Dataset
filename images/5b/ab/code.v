module top_module(input clk, input rst, input MEM_R_EN, input MEM_W_EN, input [31:0]addr, input [31:0]wrData, output reg [31:0]rdData);reg [7:0] Mem [0:1023];
  reg [10:0] i;
  
  always @(posedge clk) begin
	if (rst) begin
		for (i = 0; i <= 1023; i= i+1) Mem[i] = 0;
	end
	if(MEM_W_EN)
	  {Mem[addr-1024], Mem[addr+1-1024], Mem[addr+2-1024], Mem[addr+3-1024]} <= wrData;
  end
  
  always @(addr, MEM_R_EN)
    if(MEM_R_EN) rdData <= {Mem[addr-1024], Mem[addr+1-1024], Mem[addr+2-1024], Mem[addr+3-1024]};
endmodule