module top_module(
hclk,
hrst_b,
mhrdata,
mhresp,
mhready,
mhgrant,
mhwdata,
mhburst,
mhtrans,
mhwrite,
mhaddr,
mhsize,
mhprot
);output   [31:0]  mhaddr;       
output   [2 :0]  mhburst;      
output   [3 :0]  mhprot;       
output   [2 :0]  mhsize;       
output   [1 :0]  mhtrans;      
output   [31:0]  mhwdata;      
output           mhwrite; 
input          hclk;      
input          hrst_b;      
input          mhgrant;      
input  [31:0]  mhrdata;      
input          mhready;      
input  [1 :0]  mhresp;  
wire   [31:0]  mhaddr;       
wire   [2 :0]  mhburst;      
wire   [3 :0]  mhprot;       
wire   [2 :0]  mhsize;       
wire   [1 :0]  mhtrans;      
wire   [31:0]  mhwdata;      
wire           mhwrite; 
assign mhaddr[31:0]  = 32'b0; 
assign mhburst[2 :0] = 3'b0; 
assign mhprot[3 :0]  = 4'b0;
assign mhsize[2 :0]  = 3'b0;
assign mhtrans[1 :0] = 2'b0; 
assign mhwdata[31:0] = 32'b0; 
assign mhwrite       = 1'b0;endmodule