module top_module(
input wire din_0      , 
input wire din_1      , 
input wire sel        , 
output wire mux_out      
);assign mux_out = (sel) ? din_1 : din_0;

endmodule