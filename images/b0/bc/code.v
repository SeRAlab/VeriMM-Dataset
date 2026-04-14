module top_module(
    din         ,   
    mask        ,   
    dout        ,   
    ndout           
    ) ;input       [7:0]   din ;
input       [7:0]   mask ;

output reg  [7:0]   dout ;
output reg  [3:0]   ndout ;









always @*
begin
  ndout = 8 ;
  dout = din ;
  
  case (mask)   
    8'b1111_1111: begin 
      ndout = 8 ;
      dout = din ;
    end
    8'b1110_1110: begin 
      ndout = 6 ;
      dout = {din[7:5], din[3:1], 1'b0, 1'b0} ;
    end
    8'b1110_0111: begin 
      ndout = 6 ;
      dout = {din[7:5], din[2:0], 1'b0, 1'b0} ;
    end    
    8'b1001_1110: begin 
      ndout = 5 ;
      dout = {din[7], din[4:1], 1'b0, 1'b0, 1'b0} ;
    end  
    8'b0111_1001: begin 
      ndout = 5 ;
      dout = {din[6:3], din[0], 1'b0, 1'b0, 1'b0} ;
    end          
  endcase  
end

endmodule