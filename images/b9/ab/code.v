module top_module(
cur_addr,
disp,
disp_addr,
one_addr
);input	  wire  [11:0]	cur_addr;
input	  wire  [7:0]	  disp;
output	wire  [11:0]	disp_addr;
output	wire  [11:0]	one_addr;

assign disp_addr = 
                   (disp>=8'b10000000) ? cur_addr+disp+12'b000000000001-12'b100000000:
                   
                   cur_addr+disp+12'b1;
                   
assign one_addr = cur_addr + 12'b000000000001;

endmodule