module wishbone2bus #(
  parameter AW =  2,              
  parameter DW = 32,              
  parameter SW = DW/8             
)(
  input  wire          wb_cyc,    
  input  wire          wb_stb,    
  input  wire          wb_we,     
  input  wire [AW-1:0] wb_adr,    
  input  wire [SW-1:0] wb_sel,    
  input  wire [DW-1:0] wb_dat_w,  
  output wire [DW-1:0] wb_dat_r,  
  output wire          wb_ack,    
  output wire          wb_err,    
  output wire          wb_rty,    
  output wire          bus_wen,   
  output wire          bus_ren,   
  output wire [AW-1:0] bus_adr,   
  output wire [DW-1:0] bus_wdt,   
  input  wire [DW-1:0] bus_rdt    
);
assign bus_wen = wb_cyc & wb_stb &  wb_we;
assign bus_ren = wb_cyc & wb_stb & ~wb_we;
assign bus_adr = wb_adr;
assign bus_wdt = wb_dat_w;
assign wb_dat_r = bus_rdt;
assign wb_ack =  &wb_sel;
assign wb_err = ~&wb_sel;
assign wb_rty =     1'b0;
endmodule