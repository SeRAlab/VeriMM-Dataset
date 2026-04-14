module top_module(	phy_clk, wclk, rst,

		
		sram_adr, sram_din, sram_dout, sram_re, sram_we,

		
		madr, mdout, mdin, mwe, mreq, mack,

		
		wadr, wdout, wdin, wwe, wreq, wack

		);parameter	SSRAM_HADR = 14;

input		phy_clk, wclk, rst;

output	[SSRAM_HADR:0]	sram_adr;
input	[31:0]	sram_din;
output	[31:0]	sram_dout;
output		sram_re, sram_we;

input	[SSRAM_HADR:0]	madr;
output	[31:0]	mdout;
input	[31:0]	mdin;
input		mwe;
input		mreq;
output		mack;

input	[SSRAM_HADR:0]	wadr;
output	[31:0]	wdout;
input	[31:0]	wdin;
input		wwe;
input		wreq;
output		wack;






wire		wsel;
reg	[SSRAM_HADR:0]	sram_adr;
reg	[31:0]	sram_dout;
reg		sram_we;
wire		mack;
wire		mcyc;
reg		wack_r;











assign wsel = (wreq | wack) & !mreq;




always @(wsel or wdin or mdin)
	if(wsel)	sram_dout = wdin;
	else		sram_dout = mdin;


always @(wsel or wadr or madr)
	if(wsel)	sram_adr = wadr;
	else		sram_adr = madr;


always @(wsel or wwe or wreq or mwe or mcyc)
	if(wsel)	sram_we = wreq & wwe;
	else		sram_we = mwe & mcyc;

assign sram_re = 1'b1;




assign mdout = sram_din;

assign mack = mreq;

assign mcyc = mack;	



assign wdout = sram_din;

assign wack = wack_r & !mreq;

`ifdef USBF_ASYNC_RESET
always @(posedge phy_clk or negedge rst)
`else
always @(posedge phy_clk)
`endif




	if(rst)	wack_r <= 1'b0;
	else		wack_r <= wreq & !mreq & !wack;

endmodule