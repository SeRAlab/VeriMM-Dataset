module top_module(clk, rst,

	so_ld, slt0, slt1, slt2, slt3, slt4,
	slt6, slt7, slt8, slt9,

	sdata_out
	);input		clk, rst;



input		so_ld;
input	[15:0]	slt0;
input	[19:0]	slt1;
input	[19:0]	slt2;
input	[19:0]	slt3;
input	[19:0]	slt4;
input	[19:0]	slt6;
input	[19:0]	slt7;
input	[19:0]	slt8;
input	[19:0]	slt9;



output		sdata_out;






wire		sdata_out;

reg	[15:0]	slt0_r;
reg	[19:0]	slt1_r;
reg	[19:0]	slt2_r;
reg	[19:0]	slt3_r;
reg	[19:0]	slt4_r;
reg	[19:0]	slt5_r;
reg	[19:0]	slt6_r;
reg	[19:0]	slt7_r;
reg	[19:0]	slt8_r;
reg	[19:0]	slt9_r;
reg	[19:0]	slt10_r;
reg	[19:0]	slt11_r;
reg	[19:0]	slt12_r;











assign	sdata_out = slt0_r[15];

always @(posedge clk)
	if(so_ld)	slt0_r <= #1 slt0;
	else		slt0_r <= #1 {slt0_r[14:0], slt1_r[19]};

always @(posedge clk)
	if(so_ld)	slt1_r <= #1 slt1;
	else		slt1_r <= #1 {slt1_r[18:0], slt2_r[19]};

always @(posedge clk)
	if(so_ld)	slt2_r <= #1 slt2;
	else		slt2_r <= #1 {slt2_r[18:0], slt3_r[19]};

always @(posedge clk)
	if(so_ld)	slt3_r <= #1 slt3;
	else		slt3_r <= #1 {slt3_r[18:0], slt4_r[19]};

always @(posedge clk)
	if(so_ld)	slt4_r <= #1 slt4;
	else		slt4_r <= #1 {slt4_r[18:0], slt5_r[19]};

always @(posedge clk)
	if(so_ld)	slt5_r <= #1 20'h0;
	else		slt5_r <= #1 {slt5_r[18:0], slt6_r[19]};

always @(posedge clk)
	if(so_ld)	slt6_r <= #1 slt6;
	else		slt6_r <= #1 {slt6_r[18:0], slt7_r[19]};

always @(posedge clk)
	if(so_ld)	slt7_r <= #1 slt7;
	else		slt7_r <= #1 {slt7_r[18:0], slt8_r[19]};

always @(posedge clk)
	if(so_ld)	slt8_r <= #1 slt8;
	else		slt8_r <= #1 {slt8_r[18:0], slt9_r[19]};

always @(posedge clk)
	if(so_ld)	slt9_r <= #1 slt9;
	else		slt9_r <= #1 {slt9_r[18:0], slt10_r[19]};

always @(posedge clk)
	if(so_ld)	slt10_r <= #1 20'h0;
	else		slt10_r <= #1 {slt10_r[18:0], slt11_r[19]};

always @(posedge clk)
	if(so_ld)	slt11_r <= #1 20'h0;
	else		slt11_r <= #1 {slt11_r[18:0], slt12_r[19]};

always @(posedge clk)
	if(so_ld)	slt12_r <= #1 20'h0;
	else		slt12_r <= #1 {slt12_r[18:0], 1'b0 };

endmodule