module aeMB2_pipe (
   brk_if, gpha, gclk, grst, dena, iena,
   bra_ex, dwb_fb, xwb_fb, ich_fb, fet_fb, msr_ex, exc_dwb, exc_iwb,
   exc_ill, sys_clk_i, sys_int_i, sys_rst_i, sys_ena_i
   );
   parameter AEMB_HTX = 1;   
   output [1:0] brk_if; 
   input [1:0] 	bra_ex;
   input 	dwb_fb;
   input 	xwb_fb;   
   input 	ich_fb;
   input 	fet_fb;
   input [9:0] 	msr_ex;   
   output 	gpha,
		gclk,
		grst,
		dena,
		iena;   
   input [1:0] 	exc_dwb;
   input 	exc_iwb;
   input 	exc_ill;   
   input 	sys_clk_i,
		sys_int_i,
		sys_rst_i,
		sys_ena_i;
   reg [1:0]		brk_if;
   reg			gpha;
   reg [1:0] 		rst;   
   reg 			por;
   reg 			fet;
   reg 			hit;   
   assign 		gclk = sys_clk_i;
   assign 		grst = !rst[1];
   assign 		iena = ich_fb &
			       xwb_fb & 
			       dwb_fb & 
			       sys_ena_i;
   assign 		dena = iena;
   reg 			int_lat; 
   always @(posedge sys_clk_i)
     if (sys_rst_i) begin
	int_lat <= 1'h0;
     end else begin	
	int_lat <= #1 msr_ex[1] & (int_lat | sys_int_i);	
     end
   wire 		exc_lat; 
   assign exc_lat = exc_ill | exc_dwb[1];   
   always @(posedge gclk)
     if (grst) begin
	brk_if <= 2'h0;
     end else if (dena) begin	
	brk_if[1] <= #1 exc_lat; 
	brk_if[0] <= #1 !exc_lat & !msr_ex[9] & !msr_ex[3] & int_lat; 
     end
   always @(posedge sys_clk_i)
     if (sys_rst_i) begin
	rst <= 2'h0;
     end else begin
	rst <= #1 {rst[0], !sys_rst_i};
     end
   always @(posedge sys_clk_i)
     if (sys_rst_i) begin
	gpha <= 1'h0;
     end else if (dena | grst) begin
	gpha <= #1 !gpha;
     end
endmodule