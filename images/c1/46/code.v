module vga_cur_cregs (
	clk_i, rst_i, arst_i,
	hsel_i, hadr_i, hwe_i, hdat_i, hdat_o, hack_o,
	cadr_i, cdat_o
	);
	input         clk_i;         
	input         rst_i;         
	input         arst_i;        
	input         hsel_i;        
	input  [ 2:0] hadr_i;        
	input         hwe_i;         
	input  [31:0] hdat_i;        
	output [31:0] hdat_o;        
	output        hack_o;        
	reg [31:0] hdat_o;
	reg        hack_o;
	input  [ 3:0] cadr_i;        
	output [15:0] cdat_o;        
	reg [15:0] cdat_o;
	reg  [31:0] cregs [7:0];  
	wire [31:0] temp_cdat;
	always@(posedge clk_i)
		if (hsel_i & hwe_i)
			cregs[hadr_i] <= #1 hdat_i;
	always@(posedge clk_i)
		hdat_o <= #1 cregs[hadr_i];
	always@(posedge clk_i)
		hack_o <= #1 hsel_i & !hack_o;
	assign temp_cdat = cregs[cadr_i[3:1]];
	always@(posedge clk_i)
		cdat_o <= #1 cadr_i[0] ? temp_cdat[31:16] : temp_cdat[15:0];
endmodule