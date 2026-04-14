module top_module(
    CLK,
    SSR,
    ADDR,
    DI,
    DIP,
    EN,
    WE,
    DO,
    DOP
);parameter dw = 8;
parameter dwp = 1;
parameter aw = 11;

input CLK, SSR, EN, WE;
input [dw-1:0] DI;
output [dw-1:0] DO;
input [dwp-1:0] DIP;
output [dwp-1:0] DOP;
input [aw-1:0] ADDR;

reg	[dw+dwp-1:0]	mem [(1<<aw)-1:0];	
reg	[aw-1:0]	addr_reg;		




assign DO = mem[addr_reg][dw-1:0];
assign DOP = mem[addr_reg][dwp+dw-1:dw];




always @(posedge CLK or posedge SSR)
    if ( SSR == 1'b1 )
        addr_reg <= #1 {aw{1'b0}};
    else if ( EN )
        addr_reg <= #1 ADDR;




always @(posedge CLK)
	if (EN && WE)
		mem[ADDR] <= #1 { DIP , DI };

endmodule