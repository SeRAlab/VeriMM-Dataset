module top_module(
`ifdef OR1200_BIST
	
	mbist_si_i, mbist_so_o, mbist_ctrl_i,
`endif
	
	clk, rst, ce, we, oe, addr, di, doq
);parameter aw = 5;
parameter dw = 24;

`ifdef OR1200_BIST



input mbist_si_i;
input [`OR1200_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i;
output mbist_so_o;
`endif




input			clk;	
input			rst;	
input			ce;	
input			we;	
input			oe;	
input 	[aw-1:0]	addr;	
input	[dw-1:0]	di;	
output	[dw-1:0]	doq;	




wire [31:24] unconnected;

`ifdef OR1200_ARTISAN_SSP
`else
`ifdef OR1200_VIRTUALSILICON_SSP
`else
`ifdef OR1200_BIST
`endif
`endif
`endif

`ifdef OR1200_ARTISAN_SSP






`ifdef UNUSED
`else
`ifdef OR1200_BIST
`else
`endif
`endif
`ifdef OR1200_BIST
	
`endif

`else

`ifdef OR1200_AVANT_ATP







`else

`ifdef OR1200_VIRAGE_SSP







`else

`ifdef OR1200_VIRTUALSILICON_SSP






`ifdef UNUSED
`else
`ifdef OR1200_BIST
`else
`endif
`endif
`ifdef OR1200_BIST
	
`endif

`else

`ifdef OR1200_XILINX_RAMB4










RAMB4_S16 ramb4_s16_0(
	.CLK(clk),
	.RST(rst),
	.ADDR({3'h0, addr}),
	.DI(di[15:0]),
	.EN(ce),
	.WE(we),
	.DO(doq[15:0])
);




RAMB4_S16 ramb4_s16_1(
	.CLK(clk),
	.RST(rst),
	.ADDR({3'h0, addr}),
	.DI({8'h00, di[23:16]}),
	.EN(ce),
	.WE(we),
	.DO({unconnected, doq[23:16]})
);

`else

`ifdef OR1200_ALTERA_LPM










`else








reg	[dw-1:0]	mem [(1<<aw)-1:0];	
reg	[aw-1:0]	addr_reg;		




assign doq = (oe) ? mem[addr_reg] : {dw{1'b0}};




always @(posedge clk or posedge rst)
	if (rst)
		addr_reg <= #1 {aw{1'b0}};
	else if (ce)
		addr_reg <= #1 addr;




always @(posedge clk)
	if (ce && we)
		mem[addr] <= #1 di;

`endif	
`endif	
`endif	
`endif	
`endif  
`endif	

endmodule