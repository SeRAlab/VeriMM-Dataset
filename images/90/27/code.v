module top_module(
input				clk_cog,
input				clk_pll,

input				ena,

input				setctr,
input				setfrq,
input				setphs,

input		[31:0]	data,

input		[31:0]	pin_in,

output reg	[32:0]	phs,

output		[31:0]	pin_out,

output				pll
);reg [31:0] ctr;
reg [31:0] frq;

always @(posedge clk_cog or negedge ena)
if (!ena)
	ctr <= 32'b0;
else if (setctr)
	ctr <= data;

always @(posedge clk_cog)
if (setfrq)
	frq <= data;

always @(posedge clk_cog)
if (setphs || trig)
	phs <= setphs ? {1'b0, data} : {1'b0, phs[31:0]} + {1'b0, frq};




reg [1:0] dly;

always @(posedge clk_cog)
if (|ctr[30:29])
	dly <= {ctr[30] ? pin_in[ctr[13:9]] : dly[0], pin_in[ctr[4:0]]};




					
wire [15:0][2:0] tp	= {	dly == 2'b10,	!dly[0],	1'b0,		
						dly == 2'b10,	1'b0,		1'b0,		
						!dly[0],		!dly[0],	1'b0,		
						!dly[0],		1'b0,		1'b0,		
						dly == 2'b01,	!dly[0],	1'b0,		
						dly == 2'b01,	1'b0,		1'b0,		
						dly[0],			!dly[0],	1'b0,		
						dly[0],			1'b0,		1'b0,		
						1'b1,			!phs[32],	phs[32],	
						1'b1,			1'b0,		phs[32],	
						1'b1,			!phs[31],	phs[31],	
						1'b1,			1'b0,		phs[31],	
						1'b1,			!pll,		pll,		
						1'b1,			1'b0,		pll,		
						1'b1,			1'b0,		1'b0,		
						1'b0,			1'b0,		1'b0 };		

wire [3:0] pick		= ctr[29:26];
wire [2:0] tba		= tp[pick];

wire trig			= ctr[30] ? pick[dly]	: tba[2];		
wire outb			= ctr[30] ? 1'b0		: tba[1];		
wire outa			= ctr[30] ? 1'b0		: tba[0];		




assign pin_out		= outb << ctr[13:9] | outa << ctr[4:0];




reg [35:0] pll_fake;

always @(posedge clk_pll)
if (~&ctr[30:28] && |ctr[27:26])
	pll_fake <= pll_fake + {4'b0, frq};

wire [7:0] pll_taps	= pll_fake[35:28];

assign pll			= pll_taps[~ctr[25:23]];

endmodule