module top_module(dout, so, rd_en, rd_adr, wr_en, wr_adr, din, si, se, 
	sehold, rclk, rst_tri_en, reset_l);parameter		NUMENTRIES	= 32;

	input	[4:0]		rd_adr;
	input			rd_en;
	input			wr_en;
	input	[4:0]		wr_adr;
	input	[151:0]		din;
	input			rclk;
	input			reset_l;
	input			rst_tri_en;
	input			sehold;
	input			si;
	input			se;
	output	[151:0]		dout;
	reg	[151:0]		dout;
	output			so;

	wire			clk;
	wire			wr_vld;

	reg	[151:0]		dfq_mem[(NUMENTRIES - 1):0]  ;

	assign clk = rclk;
	assign wr_vld = ((wr_en & (~rst_tri_en)) & reset_l);

	always @(posedge clk) begin
	  if (wr_vld) begin
	    dfq_mem[wr_adr] = din;
	  end
	end
	always @(posedge clk) begin
	  if (rd_en) begin
	    dout[151:0] <= dfq_mem[rd_adr[4:0]];
	  end
	end
endmodule