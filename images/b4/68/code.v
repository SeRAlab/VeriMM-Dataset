module top_module(
data_in    , 
parity_out   
);output  parity_out ;
input [7:0] data_in ; 
     
assign parity_out = ^data_in; 

endmodule