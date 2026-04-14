module top_module(
    clk     ,   
    a       ,   
    b       ,   
    c       ,   
    d       ,   
    sa      ,   
    sb      ,   
    sc      ,   
    sd      ,   
    state   ,   
    max         
    ) ;parameter   M = 7 ;
parameter   K = 7 ;

input               clk ;
input   [M -1:0]    a ;
input   [M -1:0]    b ;
input   [M -1:0]    c ;
input   [M -1:0]    d ;

input   [K -2:0]    sa ;
input   [K -2:0]    sb ;
input   [K -2:0]    sc ;
input   [K -2:0]    sd ;

output  [K -2:0]    state ;
output  [M -1:0]    max ;




reg     [K -2:0]    pos0 ;
reg     [K -2:0]    pos1 ;
reg     [M -1:0]    max0 ;
reg     [M -1:0]    max1 ;
reg     [M -1:0]    tmp ;
reg     [K -2:0]    state_i ;
reg     [M -1:0]    max_i ;
reg     [K -2:0]    state_reg ;
reg     [M -1:0]    max_reg ;




assign state = state_reg ;
assign max = max_reg ;

always @ (posedge clk)
begin
  state_reg <= state_i ;
  max_reg <= max_i ;
end

always @*
begin  
  tmp = a-b ;
  if(~tmp[M -1])
  begin
    max0 = a ;
    pos0 = sa ;
  end
  else
  begin
    max0 = b ;
    pos0 = sb ;
  end

  tmp = c-d ;
  if(~tmp[M-1])
  begin
    max1 = c ;
    pos1 = sc ;
  end
  else
  begin
    max1 = d ;
    pos1 = sd ;
  end

  tmp = max0 - max1 ;
  if (~tmp[M-1])
  begin
    max_i = max0 ;
    state_i = pos0 ;
  end
  else
  begin
    state_i = pos1 ;
    max_i = max1 ;
  end
end

endmodule