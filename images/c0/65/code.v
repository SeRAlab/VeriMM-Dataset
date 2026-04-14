module	wbudecompress(i_clk, i_stb, i_word, o_stb, o_word);
	input			i_clk, i_stb;
	input		[35:0]	i_word;
	output	reg		o_stb;
	output	reg	[35:0]	o_word;
	wire	cmd_write_not_compressed = (i_word[35:33] == 3'h3);
	reg	[7:0]	wr_addr;
	initial	wr_addr = 8'h0;
	always @(posedge i_clk)
		if ((i_stb)&&(cmd_write_not_compressed))
			wr_addr <= wr_addr + 8'h1;
	reg	[31:0]	compression_tbl	[0:255];
	always @(posedge i_clk)
		if (i_stb)
		compression_tbl[wr_addr] <= { i_word[32:31], i_word[29:0] };
	reg	[35:0]	r_word;
	always @(posedge i_clk)
		if (i_stb)
			r_word <= i_word;
	reg	[7:0]	cmd_addr;
	always @(posedge i_clk)
		cmd_addr = wr_addr - { r_word[32:31], r_word[29:24] };
	reg	[24:0]	r_addr;
	always @(posedge i_clk)
		case(r_word[32:30])
		3'b000: r_addr <= { 19'h0, r_word[29:24] };
		3'b010: r_addr <= { 13'h0, r_word[29:18] };
		3'b100: r_addr <= {  7'h0, r_word[29:12] };
		3'b110: r_addr <= {  1'h0, r_word[29: 6] };
		3'b001: r_addr <= { {(19){ r_word[29]}}, r_word[29:24] };
		3'b011: r_addr <= { {(13){ r_word[29]}}, r_word[29:18] };
		3'b101: r_addr <= { {( 7){ r_word[29]}}, r_word[29:12] };
		3'b111: r_addr <= { {( 1){ r_word[29]}}, r_word[29: 6] };
		endcase
	wire	[31:0]	w_addr;
	assign	w_addr = { {(7){r_addr[24]}}, r_addr };
	reg	[9:0]	rd_len;
	always @(posedge i_clk)
		if (~r_word[34])
			rd_len <= 10'h01 + { 6'h00, r_word[33:31] };
		else
			rd_len <= 10'h09 + { 1'b0, r_word[33:31], r_word[29:24] };
	reg	[31:0]	cword;
	always @(posedge i_clk)
		cword <= compression_tbl[cmd_addr];
	reg	[2:0]	r_stb;
	initial	r_stb = 0;
	always @(posedge i_clk)
		r_stb <= { r_stb[1:0], i_stb };
	always @(posedge i_clk)
		o_stb <= r_stb[2];
	always @(posedge i_clk)
		if (r_word[35:30] == 6'b101110)
			o_word <= r_word;
		else casez(r_word[35:30])
		6'b001??0: o_word <= { 4'h0, w_addr[31:0] };
		6'b001??1: o_word <= { 3'h1, w_addr[31:30], 1'b1, w_addr[29:0]};
		6'b010???: o_word <=
			{ 3'h3, cword[31:30], r_word[30], cword[29:0] };
		6'b10????: o_word <= { 5'b11000, r_word[30], 20'h00, rd_len };
		6'b11????: o_word <= { 5'b11000, r_word[30], 20'h00, rd_len };
		default: o_word <= r_word;
		endcase
endmodule