module top_module(
    clk,
    address,
    out,
    load
 );input clk;
    output load; 
    output [12:0] address; 
    output [15:0] out;     

    
    assign load = 0;
    assign address = 0;
    assign out = 0;
    
    
    
endmodule