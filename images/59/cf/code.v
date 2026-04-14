module top_module(


    wkup_out,                  


    scan_clk,                  
    scan_mode,                 
    scan_rst,                  
    wkup_clear,                
    wkup_event                 
);output         wkup_out;       



input          scan_clk;       
input          scan_mode;      
input          scan_rst;       
input          wkup_clear;     
input          wkup_event;     







`ifdef ASIC
   wire wkup_rst;
   omsp_scan_mux scan_mux_rst (
                               .scan_mode    (scan_mode),
                               .data_in_scan (scan_rst),
                               .data_in_func (wkup_clear),
                               .data_out     (wkup_rst)
   );

   wire wkup_clk;
   omsp_scan_mux scan_mux_clk (
                               .scan_mode    (scan_mode),
                               .data_in_scan (scan_clk),
                               .data_in_func (wkup_event),
                               .data_out     (wkup_clk)
   );

`else
   wire wkup_rst  =  wkup_clear;
   wire wkup_clk  =  wkup_event;
`endif


reg    wkup_out;
always @(posedge wkup_clk or posedge wkup_rst)
  if (wkup_rst) wkup_out <= 1'b0;
  else          wkup_out <= 1'b1;


endmodule