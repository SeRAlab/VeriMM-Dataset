module top_module(
        clk     , 
        nrst    , 
        reset   , 
        din     , 
        dout    , 
        wr      , 
        rd      , 
        empty   , 
        full
        ) ;parameter               DEPTH = 256 ;   
parameter               ADDRW = 8 ; 
parameter               SW = 4 ;        
        
input                   clk ;       
input                   nrst ;
input                   reset ;
input   [SW*2 -1:0]     din ;       
input                   wr ;
input                   rd ;
output  [SW*2 -1:0]     dout ;
output                  empty ;
output                  full ;




reg     [SW*2 -1:0]     mem [DEPTH -1:0] ;
wire    [SW*2 -1:0]     data ;

reg     [ADDRW :0]      waddr ;
reg     [ADDRW :0]      raddr ;
wire    [ADDRW -1:0]    waddr_i ;
wire    [ADDRW -1:0]    raddr_i ;




assign dout = data ;
assign waddr_i = waddr [ADDRW -1 : 0] ;
assign raddr_i = raddr [ADDRW -1 : 0] ;
assign empty = (waddr [ADDRW] ~^ raddr [ADDRW]) & (waddr_i == raddr_i) ;
assign full = (waddr [ADDRW] ^ raddr [ADDRW]) & (waddr_i == raddr_i) ;

always @ (posedge clk or negedge nrst)
  if (~nrst)
    waddr <= 0 ;
  else if (reset)
    waddr <= 0 ;
  else if (wr)
    waddr <= waddr + 1 ;

always @ (posedge clk or negedge nrst)
  if (~nrst)
    raddr <= 0 ;
  else if (reset)
    raddr <= 0 ;
  else if (rd)
    raddr <= raddr + 1 ;

always @ (posedge clk)
  if (wr)
    mem [waddr_i] <= din ;
    
assign data = mem [raddr_i] ;


endmodule