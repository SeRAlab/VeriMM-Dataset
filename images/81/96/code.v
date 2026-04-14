module top_module(
        clk, din, dout             
        ) ;input                   clk ;
input       [12:0]      din ;
output reg  [3:0]       dout ;




reg     [3:0]       tmp ;





always @ (posedge clk)
  dout <= tmp ;

always @*
begin
  if ((~din[12]) && (din[11:10] != 2'b00))
    tmp = 4'b0111 ;
  else if (din[12] && (din[11:10] != 2'b11))
    tmp = 4'b1000 ;
  else if (din[12:10] == 3'b000)  
  begin
    if ((din[9:7] != 3'b111) & din[6])
      tmp = din[10:7] +1 ;
    else
      tmp = din[10:7] ;
  end
  else                  
  begin
    if ((din[9:7] != 3'b000) & din[6])
      tmp = din[10:7] +1 ;
    else
      tmp = din[10:7] ;
  end  
end

endmodule