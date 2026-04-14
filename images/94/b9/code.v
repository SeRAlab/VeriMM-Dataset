module top_module(
  haddr,
  hclk,
  hprot,
  hrdata,
  hready,
  hresp,
  hrst_b,
  hsel,
  hsize,
  htrans,
  hwdata,
  hwrite,
  intr
);input   [31:0]  haddr;        
input           hclk;         
input   [3 :0]  hprot;        
input           hrst_b;       
input           hsel;         
input   [2 :0]  hsize;        
input   [1 :0]  htrans;       
input   [31:0]  hwdata;       
input           hwrite;       
output  [31:0]  hrdata;       
output          hready;  
output  [1 :0]  hresp;    
output		intr;    
wire  [31:0]  hrdata;       
wire          hready;  
wire  [1 :0]  hresp;    
wire          intr;
assign hrdata[31:0] = 32'b0;       
assign hready = 1'b1;  
assign hresp[1:0] = 2'b0;    
assign intr = 1'b0;endmodule