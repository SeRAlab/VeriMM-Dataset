module top_module(
   
   dout, full, empty,
   
   clk, rst_n, clr, din, we, re
   );input           clk, rst_n;
input           clr;
input   [7:0]   din;
input           we;
output  [7:0]   dout;
input           re;
output          full, empty;







reg     [7:0]   mem[0:3];
reg     [1:0]   wp;
reg     [1:0]   rp;
wire    [1:0]   wp_p1;
wire    [1:0]   rp_p1;
wire            full, empty;
reg             gb;











always @(posedge clk or negedge rst_n)
        if(!rst_n)      wp <=  2'h0;
        else
        if(clr)         wp <=  2'h0;
        else
        if(we)          wp <=  wp_p1;

assign wp_p1 = wp + 2'h1;

always @(posedge clk or negedge rst_n)
        if(!rst_n)      rp <=  2'h0;
        else
        if(clr)         rp <=  2'h0;
        else
        if(re)          rp <=  rp_p1;

assign rp_p1 = rp + 2'h1;


assign  dout = mem[ rp ];


always @(posedge clk)
        if(we)     mem[ wp ] <=  din;


assign empty = (wp == rp) & !gb;
assign full  = (wp == rp) &  gb;


always @(posedge clk)
        if(!rst_n)                      gb <=  1'b0;
        else
        if(clr)                         gb <=  1'b0;
        else
        if((wp_p1 == rp) & we)          gb <=  1'b1;
        else
        if(re)                          gb <=  1'b0;

endmodule