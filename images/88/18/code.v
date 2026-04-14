module top_module(
    clk         ,   
    ce          ,   
    nrst        ,   
    reset       ,   
    wdata       ,   
    wr          ,   
    rd          ,   
    rdata       ,   
    empty       ,   
    half_full   ,   
    full            
    ) ;parameter           WIDTH = 8 ;
parameter           DEPTH = 8 ;
parameter           ADDR_BITS = 3 ;

input               clk ;
input               ce ;
input               nrst ;
input               reset ;
input   [WIDTH-1:0] wdata ;
input               wr ;
input               rd ;
output  [WIDTH-1:0] rdata ;
output              empty ;
output              half_full ;
output              full ;





reg     [WIDTH-1:0]     mem [DEPTH-1:0] ;
reg     [ADDR_BITS:0]   cnt ;
reg     [ADDR_BITS-1:0] waddr ;
reg     [ADDR_BITS-1:0] raddr ;




assign empty = cnt == 0 ;
assign full = cnt == DEPTH ;
assign half_full = cnt >= DEPTH/2 ;


always @ (posedge clk or negedge nrst)
  if(~nrst)
    cnt <= 0 ; 
  else if(ce)
  begin
    if (reset)
      cnt <= 0 ;
    else if (wr & ~rd)
      cnt <= cnt +1 ;
    else if (rd & ~wr)
      cnt <= cnt -1 ;
  end

always @ (posedge clk or negedge nrst)
  if(~nrst)
    waddr <= 0 ;
  else if(ce)
  begin
    if (reset)
      waddr <= 0 ;
    else if (wr)
      waddr <= waddr == DEPTH -1 ? 0 : waddr +1 ;
  end
    
always @ (posedge clk or negedge nrst)
  if(~nrst)
    raddr <= 0 ;
  else if(ce)
  begin
    if (reset)
      raddr <= 0 ;
    else if (rd)
      raddr <= raddr == DEPTH -1 ? 0 : raddr +1 ;   
  end 

always @ (posedge clk)
  if(ce)
  begin
    if (wr)
      mem [waddr] <= wdata ;
  end

assign rdata = mem [raddr] ;

endmodule