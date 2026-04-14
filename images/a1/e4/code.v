module top_module(
        clk     ,   
        nrst    ,   
        hd_a    ,   
        hd_b    ,   
        start   ,   
        vin     ,   
        vout    ,   
        dout        
        ) ;input           clk ;
input           nrst ;
input           hd_a ;
input           hd_b ;
input           start ;
input           vin ;
output          vout ;
output  [7:0]   dout ;        
        



reg     [7:2]   tmpd ;
reg     [1:0]   cnt ;   
wire    [1:0]   data_2b ;
        



assign data_2b = {hd_a, hd_b} ;
always @ (posedge clk or negedge nrst)
  if (~nrst)
    tmpd <= 0 ;
  else if (start)
    tmpd <= 0 ;
  else if (vin)
  begin
    case (cnt)
      3'd0: tmpd [7:6] <= data_2b ;
      3'd1: tmpd [5:4] <= data_2b ;
      3'd2: tmpd [3:2] <= data_2b ;
      default: tmpd <= tmpd ;
    endcase             
  end
  
always @ (posedge clk or negedge nrst)
  if (~nrst)
    cnt <= 0 ;
  else if (start)
    cnt <= 0 ;
  else if (vin)
    cnt <= cnt +1 ;

assign vout = vin & (cnt == 3) ;
assign dout = {tmpd, data_2b} ;  

endmodule