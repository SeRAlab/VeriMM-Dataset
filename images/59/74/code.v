module top_module(input clk_i, input rst_i, 
   input cyc_i, input stb_i, input [3:0] adr_i, input we_i, input [15:0] dat_i, 
   output reg [15:0] dat_o, output reg ack_o,
   input [31:0] atr, input [31:0] debug_0, input [31:0] debug_1, 
   inout [31:0] gpio
   );reg [31:0] 	ctrl, line, ddr, dbg, lgpio;
   
   wire 	wb_acc = cyc_i & stb_i;            
   wire 	wb_wr  = wb_acc & we_i;            

   always @(posedge clk_i or posedge rst_i)
     if (rst_i)
       begin
          ctrl <= 32'h0;
          line <= 32'h0;
	  ddr <= 32'h0;
	  dbg <= 32'h0;
       end
     else if (wb_wr)
       case( adr_i[3:1] )
	 3'b000 : 
           line[15:0] <= dat_i;
	 3'b001 : 
           line[31:16] <= dat_i;
	 3'b010 :
	   ddr[15:0] <= dat_i;
	 3'b011 :
	   ddr[31:16] <= dat_i;
	 3'b100 :
	   ctrl[15:0] <= dat_i;
	 3'b101 :
	   ctrl[31:16] <= dat_i;
	 3'b110 :
	   dbg[15:0] <= dat_i;
	 3'b111 :
	   dbg[31:16] <= dat_i;
       endcase 
   
   always @(posedge clk_i)
     case (adr_i[3:1])
       3'b000 :
	 dat_o <= lgpio[15:0];
       3'b001 :
	 dat_o <= lgpio[31:16];
       3'b010 :
	 dat_o <= ddr[15:0];
       3'b011 :
	 dat_o <= ddr[31:16];
       3'b100 :
	 dat_o <= ctrl[15:0];
       3'b101 :
	 dat_o <= ctrl[31:16];
       3'b110 :
	 dat_o <= dbg[15:0];
       3'b111 :
	 dat_o <= dbg[31:16];
     endcase 
   
   
   always @(posedge clk_i or posedge rst_i)
     if (rst_i)
       ack_o <= 1'b0;
     else
       ack_o <= wb_acc & !ack_o;
   
   
   always @(posedge clk_i)
     lgpio <= gpio;
   
   
   integer   n;
   reg [31:0] igpio; 
   
   always @(ctrl or line or debug_1 or debug_0 or atr or ddr or dbg)
     for(n=0;n<32;n=n+1)
       igpio[n] <= ddr[n] ? (dbg[n] ? (ctrl[n] ? debug_1[n] : debug_0[n]) : 
			     (ctrl[n] ?  atr[n] : line[n]) )
	 : 1'bz;
   
   assign     gpio = igpio;
   
endmodule