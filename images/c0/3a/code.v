module AHB2WB(
input        HCLK,
input        HRESETn,
input [31:0] HADDR,
input [31:0] HWDATA,
input        HWRITE,
input        HSEL,
input [1:0]  HTRANS,
input [2:0]  HSIZE,
input        HREADY,
output [31:0] HRDATA,
output        HRESP,
output        HREADYOUT, 
output        wb_clk_o,
output        wb_rst_o,
output [31:0] wb_adr_o, 
output [31:0] wb_dat_o,
output [3:0]  wb_sel_o,
output        wb_we_o,
output        wb_stb_o,
output        wb_cyc_o,
input [31:0]  wb_dat_i,
input         wb_ack_i 
);
reg [31:0] rHADDR;
reg        rHWRITE;
reg [1:0]  rHTRANS;
reg [2:0]  rHSIZE;
reg        rHSEL;
reg _pull_down_HREADYOUT;
wire master_wants_read;
wire master_wants_write;
reg  r_wb_cyc_o; 
 always @(posedge HCLK or negedge HRESETn) begin
   if(!HRESETn) begin
           rHADDR <= 0;
           rHWRITE <= 0;
           rHTRANS <= 0;
           rHSIZE <= 0;
           rHSEL  <= 0;
   end                  
   else if(HREADY) begin
           rHADDR <= HADDR;
           rHWRITE <= HWRITE;
           rHTRANS <= HTRANS;
           rHSIZE <= HSIZE;
           rHSEL  <= HSEL;   
   end 
 end
assign master_wants_read = rHSEL   & rHTRANS[1] & ~rHWRITE;
assign master_wants_write = rHSEL   & rHTRANS[1] & rHWRITE;
assign  wb_stb_o = master_wants_read | master_wants_write;
assign  wb_cyc_o = wb_stb_o; 
assign  wb_we_o = master_wants_write; 
assign  wb_dat_o = HWDATA;
assign  wb_adr_o = rHADDR;
assign  wb_sel_o = {4{wb_stb_o&wb_cyc_o}}; 
assign  wb_clk_o = HCLK;
assign  wb_rst_o =!HRESETn;
always @(posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) r_wb_cyc_o <= 0;
  else if((r_wb_cyc_o==1)&&(HREADYOUT==1)) r_wb_cyc_o <= 0;
  else if(wb_cyc_o) r_wb_cyc_o <= wb_cyc_o;
  else   r_wb_cyc_o <= 0;
end
assign HREADYOUT = (r_wb_cyc_o&wb_ack_i)?(1):(0); 
assign HRDATA = wb_dat_i; 
assign HRESP = 0;
endmodule