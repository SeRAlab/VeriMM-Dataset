module top_module(input clk,en,input[4:0] addr1,addr2,addw, input [3:0]data, output[3:0] content1,content2);reg [3:0]mem_bank[4:0];

assign content1 = mem_bank[addr1];
assign content2 = mem_bank[addr2];

always @(posedge clk)
	if (en) mem_bank[addw] = data;
	
endmodule