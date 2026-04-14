module top_module(sel,out,mdata0,mdata1,mdata2,mdata3);input [11:0] mdata0,mdata1,mdata2,mdata3;
	input [1:0] sel;
	output [11:0] out;
	
	wire ns0, ns1;
	
	not _n0(ns0, sel[0]);
	not _n1(ns1, sel[1]);
	
	genvar c;
	generate
		for (c = 0; c <= 11; c = c + 1) begin: loop1
			wire t0,t1,t2,t3;
			and _and00(t0,ns1,ns0,mdata0[c]);
			and _and01(t1,ns1,sel[0],mdata1[c]);
			and _and10(t2,sel[1],ns0,mdata2[c]);
			and _and11(t3,sel[1],sel[0],mdata3[c]);
			
			or _or(out[c],t0,t1,t2,t3);
		end
	endgenerate
	
endmodule