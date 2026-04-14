module top_module(
    DPO,
    SPO,
    A0,
    A1,
    A2,
    A3,
    A4,
    D,
    DPRA0,
    DPRA1,
    DPRA2,
    DPRA3,
    DPRA4,
    WCLK,
    WE
);parameter dw = 1;
parameter aw = 5;

output DPO, SPO;
input DPRA0, DPRA1, DPRA2, DPRA3, DPRA4;
input A0, A1, A2, A3, A4;
input D;
input WCLK;
input WE;

reg	[dw-1:0]	mem [(1<<aw)-1:0];	




assign DPO = mem[{DPRA4 , DPRA3 , DPRA2 , DPRA1 , DPRA0}][dw-1:0];
assign SPO = mem[{A4 , A3 , A2 , A1 , A0}][dw-1:0];




always @(posedge WCLK)
	if (WE)
		mem[{A4 , A3 , A2 , A1 , A0}] <= #1 D;

endmodule