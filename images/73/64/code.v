module top_module(clk, ena, dclr, din, coef, result);parameter dwidth = 8;
	parameter cwidth = 16;
	parameter mwidth = dwidth + cwidth;  
	parameter rwidth = mwidth +3;        

	
	
	
	input               clk;    
	input               ena;    
	input               dclr;   
	input  [dwidth-1:0] din;    
	input  [cwidth-1:0] coef;   
	output [rwidth-1:0] result; 
	reg [rwidth -1:0] result;

	
	
	
	wire [mwidth-1:0] idin;
	wire [mwidth-1:0] icoef;

	reg  [mwidth -1:0] mult_res  ;
	wire [rwidth -1:0] ext_mult_res;


	
	
	
	assign icoef = { {(mwidth-cwidth){coef[cwidth-1]}}, coef};
	assign idin  = { {(mwidth-dwidth){din[dwidth-1]}}, din};

	
	always @(posedge clk)
	  if(ena)
	    mult_res <= #1 icoef * idin;

	assign ext_mult_res = { {3{mult_res[mwidth-1]}}, mult_res};

	
	always @(posedge clk)
	  if(ena)
	    if(dclr)
	      result <= #1 ext_mult_res;
	    else
	      result <= #1 ext_mult_res + result;
endmodule