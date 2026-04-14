module top_module(
          i_inverse   ,
	  i_valid     ,
         
	  o_valid0    ,
	  o_valid1     
);input                       i_inverse;
input                       i_valid;
output			  o_valid0    ;
output			  o_valid1    ;
wire			  o_valid0    ;
wire			  o_valid1    ;

assign o_valid0 = i_inverse ? i_valid : 1'b0; 
assign o_valid1 = i_inverse ? 1'b0    : i_valid;  

endmodule