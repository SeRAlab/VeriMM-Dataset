module top_module(
        clk         ,   
        ce          ,   
        nrst        ,   
        reset       ,   
        din         ,   
        dout        ,   
        rd          ,   
        wr          ,   
        full        ,   
        empty       ,   
        nsin        ,   
        nsout           
        ) ;input           clk ;
input           ce ;
input           nrst ;
input           reset ;
input   [7:0]   din ;
output  [7:0]   dout ;
input           rd ;
input           wr ;
output          full ;
output          empty ;
input   [3:0]   nsin ;
input   [3:0]   nsout ;




reg     [23:0]  buffer ;        
reg     [5:0]   cnt ;           
wire    [31:0]  shift_out ;
wire    [31:0]  shift_in ;
wire    [5:0]   space_left ;




assign dout = shift_out [31:24] ;
assign full = (cnt + nsin) > 24 ;
assign empty = cnt < nsout ;

always @ (posedge clk or negedge nrst)
  if (~nrst)
    cnt <= 0 ;
  else if (ce)
  begin
    if (reset)
      cnt <= 0 ;
    else
    begin
      if (wr & rd)
        cnt <= cnt + nsin - nsout ;
      if (wr & ~rd)
        cnt <= cnt + nsin ;
      if (~wr & rd)
        cnt <= cnt - nsout ;
    end
  end
  
assign shift_out = {8'h0, buffer} << nsout ;  
assign space_left = rd ? 24 -cnt + nsout : 24 -cnt ;  
assign shift_in = {24'h0, din} << space_left ;
  
always @ (posedge clk or negedge nrst)
  if (~nrst)
    buffer <= 0 ;
  else if (ce)
  begin
    if (reset)
      buffer <= 0 ;
    else
    begin
      if (wr & rd)
        buffer <= shift_out [23:0] | shift_in [31:8] ;
      if (wr & ~rd)
        buffer <= buffer | shift_in [31:8] ;
      if (~wr & rd)
        buffer <= shift_out [23:0] ;
    end
  end  

endmodule