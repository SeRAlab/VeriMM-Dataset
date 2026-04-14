module  omsp_sfr (
    nmie,                         
    per_dout,                     
    wdt_irq,                      
    wdt_reset,                    
    wdtie,                        
    mclk,                         
    nmi_acc,                      
    per_addr,                     
    per_din,                      
    per_en,                       
    per_wen,                      
    por,                          
    puc,                          
    wdtifg_clr,                   
    wdtifg_set,                   
    wdtpw_error,                  
    wdttmsel                      
);
output              nmie;         
output       [15:0] per_dout;     
output              wdt_irq;      
output              wdt_reset;    
output              wdtie;        
input               mclk;         
input               nmi_acc;      
input         [7:0] per_addr;     
input        [15:0] per_din;      
input               per_en;       
input         [1:0] per_wen;      
input               por;          
input               puc;          
input               wdtifg_clr;   
input               wdtifg_set;   
input               wdtpw_error;  
input               wdttmsel;     
parameter           IE1        = 9'h000;
parameter           IFG1       = 9'h002;
parameter           IE1_D      = (256'h1 << (IE1  /2));
parameter           IFG1_D     = (256'h1 << (IFG1 /2)); 
reg  [255:0]  reg_dec; 
always @(per_addr)
  case (per_addr)
    (IE1  /2):     reg_dec  =  IE1_D;
    (IFG1 /2):     reg_dec  =  IFG1_D;
    default  :     reg_dec  =  {256{1'b0}};
  endcase
wire         reg_lo_write =  per_wen[0] & per_en;
wire         reg_hi_write =  per_wen[1] & per_en;
wire         reg_read     = ~|per_wen   & per_en;
wire [255:0] reg_hi_wr    = reg_dec & {256{reg_hi_write}};
wire [255:0] reg_lo_wr    = reg_dec & {256{reg_lo_write}};
wire [255:0] reg_rd       = reg_dec & {256{reg_read}};
wire [7:0] ie1;
wire       ie1_wr  = IE1[0] ? reg_hi_wr[IE1/2] : reg_lo_wr[IE1/2];
wire [7:0] ie1_nxt = IE1[0] ? per_din[15:8]    : per_din[7:0];
reg        nmie;
always @ (posedge mclk or posedge puc)
  if (puc)          nmie  <=  1'b0;
  else if (nmi_acc) nmie  <=  1'b0; 
  else if (ie1_wr)  nmie  <=  ie1_nxt[4];    
reg        wdtie;
always @ (posedge mclk or posedge puc)
  if (puc)           wdtie <=  1'b0;
  else if (ie1_wr)   wdtie <=  ie1_nxt[0];    
assign  ie1 = {3'b000, nmie, 3'b000, wdtie};
wire [7:0] ifg1;
wire       ifg1_wr  = IFG1[0] ? reg_hi_wr[IFG1/2] : reg_lo_wr[IFG1/2];
wire [7:0] ifg1_nxt = IFG1[0] ? per_din[15:8]     : per_din[7:0];
reg        nmiifg;
always @ (posedge mclk or posedge puc)
  if (puc)           nmiifg <=  1'b0;
  else if (nmi_acc)  nmiifg <=  1'b1;
  else if (ifg1_wr)  nmiifg <=  ifg1_nxt[4];
reg        wdtifg;
always @ (posedge mclk or posedge por)
  if (por)                        wdtifg <=  1'b0;
  else if (wdtifg_set)            wdtifg <=  1'b1;
  else if (wdttmsel & wdtifg_clr) wdtifg <=  1'b0;
  else if (ifg1_wr)               wdtifg <=  ifg1_nxt[0];
assign  ifg1 = {3'b000, nmiifg, 3'b000, wdtifg};
wire [15:0] ie1_rd   = (ie1  & {8{reg_rd[IE1/2]}})  << (8 & {4{IE1[0]}});
wire [15:0] ifg1_rd  = (ifg1 & {8{reg_rd[IFG1/2]}}) << (8 & {4{IFG1[0]}});
wire [15:0] per_dout =  ie1_rd   |
                        ifg1_rd;
wire    wdt_irq      = wdttmsel & wdtifg & wdtie;
reg     wdt_reset;
always @ (posedge mclk or posedge por)
  if (por) wdt_reset <= 1'b0;
  else     wdt_reset <= wdtpw_error | (wdtifg_set & ~wdttmsel);
endmodule